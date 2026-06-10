## InputManager
## Manages all player input reading, filtering and action selection.
## Uses numpad notation for directions (1-9) and numpad +10 for attack buttons.
## Input history is maintained as an Array[Array] where index 0 is the most recent frame.
## Two arrays are maintained - input_history for motion detection and buffered_array for
## attack button buffering. Both grow during hit stop to preserve inputs during freeze frames.
##
## Notation reference:
## Directions: DL=1 D=2 DR=3 L=4 NEUTRAL=5 R=6 UL=7 U=8 UR=9
## Attacks: LPK=11 LK=12 EXK=13 LP=14 HP=18 HK=16 EXP=17 HPK=19
class_name InputManager extends BehaviourBase

## maps 4 bit binary input index to numpad direction value
## bit order is up(3) down(2) left(1) right(0)
var direction_look_up_array = [
	MoveList.NEUTRAL,  # 0000 - no input
	MoveList.R,        # 0001 - right only
	MoveList.L,        # 0010 - left only
	MoveList.NEUTRAL,  # 0011 - left + right conflict
	MoveList.D,        # 0100 - down only
	MoveList.DR,       # 0101 - down + right
	MoveList.DL,       # 0110 - down + left
	MoveList.D,        # 0111 - down + left + right (priority to down)
	MoveList.U,        # 1000 - up only
	MoveList.UR,       # 1001 - up + right
	MoveList.UL,       # 1010 - up + left
	MoveList.U,        # 1011 - up + left + right (priority to up)
	MoveList.NEUTRAL,  # 1100 - up + down conflict
	MoveList.R,        # 1101 - up + down + right (priority to right)
	MoveList.L,        # 1110 - up + down + left (priority to left)
	MoveList.NEUTRAL   # 1111 - all directions pressed
]

## full input history newest at index 0, used for motion input detection
var input_history: Array[Array] = [[5],[5]]
## short window history newest at index 0, used for attack button buffering
var buffered_array: Array[Array] = [[5],[5]]
## single frame of inputs built each frame before being pushed into both arrays
var inputs_of_curent_frame_for_attacks: Array[int]

## how many frames back motion inputs are checked against
var max_check_frames: int = 20
## how many frames an attack button press stays valid for action selection
var max_buffer_frames: int = 5

## extra frames the buffer stays large after hit stop ends
## commented out until cancel window tuning is needed
var bonus_frames_remaining: int = 0

var input_direction: int = 0
var jump_relesed: bool = false

@export_group("player info")
@export var player: Player
@export var attack_manager: AttackManager
@export var movement_componet: Movement
@export var scale_component: Scale
@export var dash_component: Dash
@export var gravity_component: Gravity

@export_category("fake inputs")
@export var fake_U: bool
@export var fake_R: bool
@export var fake_D: bool
@export var fake_L: bool


func _ready() -> void:
	self.name = "input_manager"
	if attack_manager == null: push_error("InputManager: attack_manager not assigned")
	if movement_componet == null: push_error("InputManager: movement_componet not assigned")
	if scale_component == null: push_error("InputManager: scale_component not assigned")
	if dash_component == null: push_error("InputManager: dash_component not assigned")
	if gravity_component == null: push_error("InputManager: gravity_component not assigned")
	self.process_mode = Node.PROCESS_MODE_ALWAYS


## simulates button presses using exported booleans
## warning: releases any held button that is not set to true
func press() -> void:
	if fake_D: Input.action_press("down")
	else: Input.action_release("down")
	if fake_L: Input.action_press("left")
	else: Input.action_release("left")
	if fake_R: Input.action_press("right")
	else: Input.action_release("right")
	if fake_U: Input.action_press("up")
	else: Input.action_release("up")


## prints all relevant player state values for debugging
func state_print() -> void:
	print("dash: " + str(dash_component.is_dashing))
	print("jumping: " + str(movement_componet.is_jumping))
	print("attacking: " + str(attack_manager.is_attacking))
	print("turning: " + str(scale_component.is_turning))
	print("crouch: " + str(player.is_crouching))
	print("block: " + str(player.is_blocking))
	print("stun: " + str(player.stun_manager.is_stuned))
	print("falling: " + str(gravity_component.is_falling))


# --- movement ---

## stops horizontal movement when crouching or attacking
## allows movement when on floor, not crouching, and not dashing
func movement_manager() -> void:
	if player.is_on_floor() and (player.is_crouching or attack_manager.is_attacking):
		player.velocity.x = 0
		dash_component.is_dashing = false
	elif (player.is_on_floor()
	and not player.is_crouching
	and dash_component.is_dashing == false):
		movement_componet.movement_update(input_direction)


# --- input array management ---

## checks if a full motion sequence exists in input history AND
## the corresponding attack button is in the buffer
## sequence and Attack_buttion use numpad notation values
func buffer_check(input_h: Array, sequence: int, Attack_buttion: int) -> bool:
	if get_vaild_sequences(input_h, sequence).size() > 0 and single_input_check(buffered_array, Attack_buttion):
		return true
	return false

## searches an entire array for a single input value across all frames
## used for attack button buffer checking since buttons are two digit values
## and cannot be passed through sequence_spliter
func single_input_check(array: Array, what: int) -> bool:
	if array == null:
		push_error("Array empty when calling single input check")
		return false
	for inputs in array:
		if inputs.has(what):
			return true
	return false

## converts an integer sequence like 236 into an array of digits [2,3,6]
## used by get_vaild_sequences to check each step of a motion input
func sequence_spliter(sequence: int) -> Array[int]:
	var digits: Array[int]
	while (sequence):
		digits.push_front(sequence % 10)
		@warning_ignore("integer_division")
		sequence = sequence / 10
	return digits

## scans input history for a completed motion sequence
## allows gaps between inputs so neutral frames do not break motions
## returns a dictionary of end_index:sequence pairs for all valid completions
## lowest index = most recent completion since history is newest first
func get_vaild_sequences(input_h: Array[Array], sequence: int) -> Dictionary[int, int]:
	var valid: Dictionary[int, int]
	var curent_digit: int = 0
	var digits: Array[int] = sequence_spliter(sequence)
	var total_digits: int = digits.size()
	var index_of_most_recent: int = 0
	digits.reverse()
	for index in input_h.size():
		if input_h[index].has(digits.get(curent_digit)):
			if curent_digit == 0:
				index_of_most_recent = index
			curent_digit += 1
			if curent_digit == total_digits:
				valid.get_or_add(index_of_most_recent, sequence)
				curent_digit = 0
	return valid

## maintains the sliding window size of input arrays
## does not trim during hit stop so inputs pressed during freeze are preserved
## this intentionally grows the buffer during hit stop giving a larger cancel window
func resize_and_append_to_array(array: Array, max_size: int, this_frame_inputs: Array[int]) -> void:
	if array.size() > max_size + 1:
		if HitStop.frames_left == 0:
			push_warning("input history exceeded max size by more than 1 frame, something is adding to it externally")
	array.push_front(this_frame_inputs.duplicate())
	if HitStop.frames_left > 0:
		if attack_manager.is_attack_safe_to_read():
			bonus_frames_remaining = attack_manager.current_attack.start_frame_combo-attack_manager.current_attack.active_frame
		return
	## cancel window bonus - keeps buffer large for extra frames after hit stop ends
	## uncomment and add bonus_frames_remaining logic when cancel window tuning is needed
	if bonus_frames_remaining>0:
		bonus_frames_remaining -=1
		return
		
	while array.size() > max_size:
		array.remove_at(-1)


## reads all inputs for the current frame and builds inputs_of_curent_frame_for_attacks
## directions use is_action_pressed so held directions appear every frame for motion inputs
## attack buttons use is_action_just_pressed so each press only enters the buffer once
## in frame by frame mode attack buttons use is_action_pressed so held buttons register
## when the game is unpaused one frame at a time
func input_filter() -> void:
	inputs_of_curent_frame_for_attacks.clear()

	var up: bool = Input.is_action_pressed("up")
	var down: bool = Input.is_action_pressed("down")
	var left: bool = Input.is_action_pressed("left")
	var right: bool = Input.is_action_pressed("right")
	var light_punch: bool = Input.is_action_just_pressed("LP") or Input.is_action_just_released("LP")
	var light_kick: bool = Input.is_action_just_pressed("LK") or Input.is_action_just_released("LK")
	var heavy_punch: bool = Input.is_action_just_pressed("HP") or Input.is_action_just_released("HP")
	var heavy_kick: bool = Input.is_action_just_pressed("HK") or Input.is_action_just_released("HK")
	var light_punch_hold: bool = Input.is_action_pressed("LP")
	var light_kick_hold: bool = Input.is_action_pressed("LK")
	var heavy_punch_hold: bool = Input.is_action_pressed("HP")
	var heavy_kick_hold: bool = Input.is_action_pressed("HK")

	# binary math selects the correct numpad direction from 4 booleans
	var bit_index = (int(up) << 3) | (int(down) << 2) | (int(left) << 1) | int(right)
	inputs_of_curent_frame_for_attacks.append(direction_look_up_array[bit_index])

	if Input.is_action_pressed("fake inputs enabled"):
		press()

	# frame by frame mode uses held state so attacks register on the advanced frame
	if FrameByFrameMode.frame_by_frame_mode_endabled:
		if (light_kick_hold and heavy_kick_hold): inputs_of_curent_frame_for_attacks.append(MoveList.EXK)
		if (light_punch_hold and heavy_punch_hold): inputs_of_curent_frame_for_attacks.append(MoveList.EXP)
		if (light_kick_hold and light_punch_hold): inputs_of_curent_frame_for_attacks.append(MoveList.LPK)
		if (heavy_kick_hold and heavy_punch_hold): inputs_of_curent_frame_for_attacks.append(MoveList.HPK)
		if light_punch_hold: inputs_of_curent_frame_for_attacks.append(MoveList.LP)
		if light_kick_hold: inputs_of_curent_frame_for_attacks.append(MoveList.LK)
		if heavy_punch_hold: inputs_of_curent_frame_for_attacks.append(MoveList.HP)
		if heavy_kick_hold: inputs_of_curent_frame_for_attacks.append(MoveList.HK)
	else:
		# normal play uses just_pressed so holding a button only registers once
		if (light_kick and heavy_kick): inputs_of_curent_frame_for_attacks.append(MoveList.EXK)
		if (light_punch and heavy_punch): inputs_of_curent_frame_for_attacks.append(MoveList.EXP)
		if (light_kick and light_punch): inputs_of_curent_frame_for_attacks.append(MoveList.LPK)
		if (heavy_kick and heavy_punch): inputs_of_curent_frame_for_attacks.append(MoveList.HPK)
		if light_punch: inputs_of_curent_frame_for_attacks.append(MoveList.LP)
		if light_kick: inputs_of_curent_frame_for_attacks.append(MoveList.LK)
		if heavy_punch: inputs_of_curent_frame_for_attacks.append(MoveList.HP)
		if heavy_kick: inputs_of_curent_frame_for_attacks.append(MoveList.HK)

	resize_and_append_to_array(input_history, max_check_frames, inputs_of_curent_frame_for_attacks)
	resize_and_append_to_array(buffered_array, max_buffer_frames, inputs_of_curent_frame_for_attacks)


# --- action selection ---

## checks a single attack dictionary for a valid input match
## uses a 4 part key: [is_on_floor, is_facing_right, motion_sequence, attack_button]
## picks the most recently completed motion when multiple valid sequences exist
func chose_actions_get_attack(dic: Dictionary[Array, Attack]) -> void:
	var most_recent_attack: Attack
	var valids: Dictionary[int, int]
	var attack_partial_key: Array = [
		player.is_on_floor(),
		player.is_facing_right
	]
	for attack: Array in dic:
		if (attack[0] == attack_partial_key[0]
		and attack[1] == attack_partial_key[1]
		and single_input_check(buffered_array, attack[3])):
			valids.merge(get_vaild_sequences(input_history, attack[2]), true)
			if valids:
				var index = valids.keys().min()
				most_recent_attack = dic.get([attack[0], attack[1], valids.get(index), attack[3]])
		if most_recent_attack:
			attack_manager.start_attack(most_recent_attack)
	print(valids)

## selects attacks in priority order: specials > command normals > neutral normals
## when already attacking checks for special cancels and combo continuations
func chose_action3() -> void:
	if attack_manager.is_attacking == false:
		chose_actions_get_attack(attack_manager.all_specials)
	if attack_manager.is_attacking == false:
		chose_actions_get_attack(attack_manager.command_normals)
	if attack_manager.is_attacking == false:
		chose_actions_get_attack(attack_manager.neutral_normals)
	else:
		if (attack_manager.current_attack.can_speical_cancel
		and attack_manager.current_attack.has_hit):
			chose_actions_get_attack(attack_manager.all_specials)
		for key in attack_manager.current_attack.combo_attacks_dictionary:
			if (single_input_check(buffered_array, key)
			and attack_manager.current_attack.can_combo
			and attack_manager.current_attack.has_hit):
				print("you did it")
				attack_manager.start_attack(attack_manager.current_attack.combo_attacks_dictionary[key])


func _process(_delta: float) -> void:
	# frame by frame mode - record inputs but skip all game logic until unpaused
	if get_tree().paused and HitStop.frames_left <= 0:
		return
	input_filter()
	# stunned - record inputs but skip action selection and movement
	if player.stun_manager.is_stuned == true:
		return

	input_direction = round(Input.get_axis("left", "right"))
	movement_manager()

	# input_filter runs after chose_action3 so the buffer read by chose_action3
	# reflects last frame's inputs, not the current frame being built
	if dash_component.is_dashing == false:
		chose_action3()
	if attack_manager.is_attacking == false:
		player.primary_hurt_box_manager()
		scale_component.flip_x_logic()
		dash_component.dash_handler2()
		movement_componet.jump_handler2()
	else:
		player.PrimaryHurtBoxes_component.disable_all_pimary_sprites_excluding()
	print(input_history)
