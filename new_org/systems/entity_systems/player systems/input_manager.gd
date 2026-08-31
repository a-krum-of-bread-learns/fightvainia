## Reads and filters player input, builds motion history, and selects attacks.
## Uses numpad notation for directions and numpad +10 for attack buttons — see [MoveList].
##
## input_history and buffered_array both hold the last several frames of input, newest
## first, and grow during hit stop to preserve inputs pressed during freeze frames.[br]
## Notation reference: [br]
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
## single frame of inputs built each frame before being pushed into arrays that use it
var inputs_of_curent_frame_for_attacks: Array[int]

## how many frames back motion inputs are checked against
var max_check_frames: int = 20
## how many frames an attack button press stays valid for action selection
var max_buffer_frames: int = 5

## the number of extra frames the buffer stays larger- for after hit stop ends set in [method resize_and_append_to_array]
var bonus_frames_remaining: int = 0
var input_direction: int = 0
@export var input_release_on: bool = false ##acesablity setting or somthing
@export_group("player info")
#REFACTOR remove these and set them to player?
@export var move_list: MoveList
@export var movement_componet: Movement
@export var scale_component: Scale


signal dash_signal(direction: Vector2)
signal jump_signal(direction: Vector2)

## prints all relevant player state values for debugging
func state_print() -> void:
	print("dash: " + str(host.is_dashing))
	print("jumping: " + str(host.is_jumping))
	print("attacking: " + str(host.is_attacking))
	print("crouch: " + str(host.is_crouching))
	print("block: " + str(host.is_blocking))
	print("stun: " + str(host.is_stuned))
	print("falling: " + str(host.is_falling))
	
#region setup
func _ready() -> void:
	self.name = "input_manager"
	HelperFuncs.check_if_null(host,"host",self)
	HelperFuncs.check_if_null(movement_componet, "movement_componet", self)
	HelperFuncs.check_if_null(scale_component, "scale_component", self)
	self.process_mode = Node.PROCESS_MODE_ALWAYS
#endregion


#region input array management
## checks if a full motion sequence exists in input_history AND the corresponding
## attack button is in buffered_array. sequence and Attack_buttion use numpad notation.
#this doent implie dash can work how i want
func buffer_check(input_h: Array, sequence: Array[int], Attack_buttion: Array[int]) -> bool:
	if reader(input_h,sequence).size() > 0 and reader_single_input(buffered_array,Attack_buttion[0]):
		return true
	return false

## searches an entire array for a single input value across all frames
## used for attack button buffer checking since buttons are two digit values
func reader_single_input(array: Array, what: int)-> bool:
	if array == null:
		push_error("Array empty when calling single input check")
		return false
	for inputs in array:
		if inputs.has(what):
			return true
	return false


## scans input history for a completed motion sequence
## allows gaps between inputs so neutral frames do not break motions
## returns a dictionary of end_index:sequence pairs for all valid completions
## lowest index = most recent completion since history is newest first
func reader(input_h: Array[Array], digits: Array[int]):
	var sequnce: Array[int] = digits.duplicate()
	var correct_digits: int = 0
	var total_digits: int = digits.size()
	var index_of_most_recent: int
	sequnce.reverse()
	for index in input_h.size():
		if input_h[index].has(sequnce.get(correct_digits)):# check if an input is vaild for that sqeuence 
			if correct_digits == 0:
				index_of_most_recent = index
			correct_digits += 1
			if correct_digits == total_digits:
				return {index_of_most_recent: digits}
	return {}

## maintains the sliding window size of input arrays
## does not trim during hit stop so inputs pressed during freeze are preserved
## this intentionally grows the buffer during hit stop giving a larger cancel window
func resize_and_append_to_array(array: Array, max_size: int, this_frame_inputs: Array[int]) -> void:
	if array.size() > max_size + 1:
		if HitStopAndShake.frames_left == 0:
			push_warning("input history exceeded max size by more than 1 frame, something is adding to it externally")
	array.push_front(this_frame_inputs.duplicate())
	if HitStopAndShake.frames_left > 0:
		if host.attack_manager.is_attack_safe_to_read():
			bonus_frames_remaining = host.attack_manager.current_attack.start_frame_combo-host.attack_manager.current_attack.active_frame
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
	var light_punch: bool = Input.is_action_just_pressed("LP") or (Input.is_action_just_released("LP") and input_release_on)
	var light_kick: bool = Input.is_action_just_pressed("LK and jump") or (Input.is_action_just_released("LK and jump") and input_release_on)
	var heavy_punch: bool = Input.is_action_just_pressed("HP") or (Input.is_action_just_released("HP") and input_release_on)
	var heavy_kick: bool = Input.is_action_just_pressed("HK and block") or (Input.is_action_just_released("HK and block") and input_release_on)
	var light_punch_hold: bool = Input.is_action_pressed("LP")
	var light_kick_hold: bool = Input.is_action_pressed("LK and jump")
	var heavy_punch_hold: bool = Input.is_action_pressed("HP")
	var heavy_kick_hold: bool = Input.is_action_pressed("HK and block")

	# binary math selects the correct numpad direction from 4 booleans
	var bit_index = (int(up) << 3) | (int(down) << 2) | (int(left) << 1) | int(right)
	inputs_of_curent_frame_for_attacks.append_array(direction_look_up_array[bit_index])

	# frame by frame mode uses held state so attacks register on the advanced frame
	if FrameByFrameMode.frame_by_frame_mode_endabled:
		if (light_kick_hold and heavy_kick_hold): inputs_of_curent_frame_for_attacks.append_array(MoveList.EXK)
		if (light_punch_hold and heavy_punch_hold): inputs_of_curent_frame_for_attacks.append_array(MoveList.EXP)
		if (light_kick_hold and light_punch_hold): inputs_of_curent_frame_for_attacks.append_array(MoveList.LPK)
		if (heavy_kick_hold and heavy_punch_hold): inputs_of_curent_frame_for_attacks.append_array(MoveList.HPK)
		if light_punch_hold: inputs_of_curent_frame_for_attacks.append_array(MoveList.LP)
		if light_kick_hold: inputs_of_curent_frame_for_attacks.append_array(MoveList.LK)
		if heavy_punch_hold: inputs_of_curent_frame_for_attacks.append_array(MoveList.HP)
		if heavy_kick_hold: inputs_of_curent_frame_for_attacks.append_array(MoveList.HK)
	else:
		# normal play uses just_pressed so holding a button only registers once
		if (light_kick and heavy_kick): inputs_of_curent_frame_for_attacks.append_array(MoveList.EXK)
		if (light_punch and heavy_punch): inputs_of_curent_frame_for_attacks.append_array(MoveList.EXP)
		if (light_kick and light_punch): inputs_of_curent_frame_for_attacks.append_array(MoveList.LPK)
		if (heavy_kick and heavy_punch): inputs_of_curent_frame_for_attacks.append_array(MoveList.HPK)
		if light_punch: inputs_of_curent_frame_for_attacks.append_array(MoveList.LP)
		if light_kick: inputs_of_curent_frame_for_attacks.append_array(MoveList.LK)
		if heavy_punch: inputs_of_curent_frame_for_attacks.append_array(MoveList.HP)
		if heavy_kick: inputs_of_curent_frame_for_attacks.append_array(MoveList.HK)

	resize_and_append_to_array(input_history, max_check_frames, inputs_of_curent_frame_for_attacks)
	resize_and_append_to_array(buffered_array, max_buffer_frames, inputs_of_curent_frame_for_attacks)
#endregion


#region action selection
## checks a single attack dictionary for a valid input match
## uses a 4 part key: [is_on_floor, is_facing_right, motion_sequence, attack_button]
## picks the most recently completed motion when multiple valid sequences exist
func chose_actions_get_attack(dic: Dictionary[MoveList.AttackKey, Attack]):
	var most_recent_attack: Attack
	var valids: Dictionary[int,Array]
	
	if Input.is_action_pressed("HK and block") and host.is_on_floor():
		host.is_blocking = true
		if host.is_crouching: host.block_type = host.BLOCK_TYPE.LOW
		else: host.block_type = host.BLOCK_TYPE.OVER
		return
	else: host.is_blocking = false

	for move_key: MoveList.AttackKey in dic:
		#this if stamnted does 3 / 4 of the key checks 
		if (move_key.is_on_floor == host.is_on_floor()
		and move_key.is_facing_right == host.is_facing_right 
		and reader_single_input(buffered_array, move_key.attack_button[0])):
			valids.merge(reader(input_history, move_key.sequence),true)# the 4th key check that also grabs the index of the seqxnrex 
			# add the most recent attack 
			if valids: 
				var most_recent_sequence: Array[int] = valids.get(valids.keys().min())
				if move_key.sequence == most_recent_sequence:
					most_recent_attack = dic.get(move_key)
		#loop end
		if most_recent_attack: host.attack_manager.start_attack(most_recent_attack)#starts the attack
		

## selects attacks in priority order: specials > command normals > neutral normals
## when already attacking checks for special cancels and combo continuations
func chose_action3() -> void:
	if host.is_attacking == false:
		chose_actions_get_attack(move_list.all_specials)
	if host.is_attacking == false:
		chose_actions_get_attack(move_list.command_normals)
	if host.is_attacking == false:
		chose_actions_get_attack(move_list.neutral_normals)
	else:
		if (host.attack_manager.current_attack.can_speical_cancel
		and host.attack_manager.current_attack.has_hit):
			chose_actions_get_attack(move_list.all_specials)

		
		for key in host.attack_manager.current_attack.combo_attacks_dictionary:
			if (reader_single_input(buffered_array,key) 
			and host.attack_manager.current_attack.can_combo
			and host.attack_manager.current_attack.has_hit):
				host.attack_manager.start_attack(host.attack_manager.current_attack.combo_attacks_dictionary[key])
#endregion


func _physics_process(_delta: float) -> void:
	if enabled == false: return
	# frame by frame mode - record inputs but skip all game logic until unpaused
	if get_tree().paused and HitStopAndShake.frames_left <= 0:
		return
	input_filter()
	# stunned - record inputs but skip action selection and movement
	if host.is_stuned == true:
		return
	host.is_crouching = Input.is_action_pressed("down") and host.is_on_floor()
	input_direction = round(Input.get_axis("left", "right"))
	movement_componet.movement_update(input_direction)

	# input_filter runs after chose_action3 so the buffer read by chose_action3
	# reflects last frame's inputs, not the current frame being built
	#if host.is_dashing == false:
	chose_action3()
	if host.is_attacking == false:
		host.primary_hurt_box_manager()
		scale_component.flip_x_logic(input_direction)
		
		if (buffer_check(input_history, MoveList.DASHR,MoveList.R)):
			dash_signal.emit(Vector2.RIGHT)
		elif (buffer_check(input_history, MoveList.DASHL,MoveList.L)):
			dash_signal.emit(Vector2.LEFT)
			
		if (#buffer_check(buffered_array,MoveList.LK,MoveList.LK)
			#and host.is_jumping == false):
			Input.is_action_just_pressed("LK and jump")
			or (Input.is_action_pressed("LK and jump") and FrameByFrameMode.frame_by_frame_mode_endabled)):
			jump_signal.emit(input_direction)
	else:
		host.primary_boxes_and_sprites.disable_all_pimary_sprites_excluding()
	#state_print()
	#print(input_history)
