## This component manages the control of the player selection of Attacks input filtering
## Inputs that are filtered use numpad notation for direction
## and uses numpad notation +10 for Attack buttons
#TODO decide if i call this player contoller instead 
class_name InputManager extends BehaviourBase
enum {DL=1,D=2,DR=3,L=4,NEUTRAL=5,R=6,UL=7,U=8,UR=9, # input directions
LK=12,HK=16,EXK=13,LP=14,HP=18,EXP=17,LPK=11,HPK=19, #attack buttons
DQCR=236,DQCL=214,UQCR=896,UQCL=874,LQCD=412,RQCD=632,LQCU=478,RQCU=698, #quarter circle motions
RDPD=623,LDPD=421,RDPU=689,LDPU=487, #dragon punch motions
DASHR=5656,DASHL=5454} 
# array made by ai
## this array helps to select a motion input using binary math see [method input_filter]
var direction_look_up_array = [
		NEUTRAL,  # 0000 - no input
		R,        # 0001 - right only
		L,        # 0010 - left only
		NEUTRAL,  # 0011 - left + right conflict
		D,        # 0100 - down only
		DR,       # 0101 - down + right
		DL,       # 0110 - down + left
		D,        # 0111 - down + left + right (priority to down)
		U,        # 1000 - up only
		UR,       # 1001 - up + right
		UL,       # 1010 - up + left
		U,        # 1011 - up + left + right (priority to up)
		NEUTRAL,  # 1100 - up + down conflict
		R,        # 1101 - up + down + right (priority to right)
		L,        # 1110 - up + down + left (priority to left)
		NEUTRAL   # 1111 - all directions pressed
	]

#TODO add a boolen to tell me when i can do somthing?
#both Array[Array]s need a bit to not cause erroron start elsewher in code

var input_history: Array[Array] = [[5],[5]] ## holds the full input history up to [member max_check_frames]
var buffered_array: Array[Array] = [[5],[5]]## holds the buffer input history up to [member max_buffer_frames]
var inputs_of_curent_frame_for_attacks: Array[int] ## the single frame of input that is used in [members input_history] and [member buffered_array]
#var inputs_of_curent_frame_for_display: Array[int]
var max_check_frames: int = 20 ## the frame cap for motion inputs to be checked used with [method resize_and_append_to_array]
var max_buffer_frames: int = 5 ## the frame cap for the final input of an action to be checked used with [method resize_and_append_to_array]


var input_direction: int = 0 ## tells us the direstion the playre wants to move
var jump_relesed: bool = false

# combining player script with input manager
@export_group("player info")
@export var player: Player ## the player see [Player]
@export var attack_manager: AttackManager ##see [AttackManger]
@export var movement_componet: Movement ## see [Movement] 
@export var scale_component: Scale ## see [Scale] 
@export var dash_component: Dash ## see [Dash]
@export var gravity_component: Gravity

#becuse my key board is broken use lp to use the boolens
@export_category("fake inputs")
@export var fake_U:bool
@export var fake_R:bool
@export var fake_D:bool
@export var fake_L:bool


# filters ou nulls to reduce processing whan chosceing Attack 
## filters out uneccary Attacks ????
func _ready():
	self.name= "input_manager"
	super._ready()

## used to alow for false butions because keybard is bad as many butions at the same time 
## waring this has relse sp if a bution is held and this is called the buttion is relsed 
func press():
	if fake_D: Input.action_press("down")
	else: Input.action_release("down")
	if fake_L: Input.action_press("left")
	else: Input.action_release("left")
	if fake_R: Input.action_press("right")
	else: Input.action_release("right")
	if fake_U: Input.action_press("up")
	else: Input.action_release("up")
## debug function to hel see what the stae of the player is
func state_print():
	print("dash: " + str(dash_component.is_dashing))
	print("jumping: " + str(movement_componet.is_jumping))
	print("attacking: " + str(attack_manager.is_attacking))
	print("turning: " + str(scale_component.is_turning))
	print("crouch: " + str(player.is_crouching))
	print("block: " + str(player.is_blocking))
	print("stun: "+ str(player.stun_manager.is_stuned))
	print("falling: "+ str( gravity_component.is_falling))
	
#TODO add more conditons to tuitning around  # this may be consederd done else whare
## identifies when to flip player on ground

#-------------------------------------------------------------start of movemnt handling 


## handels logic for when to move removes the crouch checks for crouch walk
func movement_manager():
	if player.is_on_floor() and (player.is_crouching or 
	attack_manager.is_attacking):
		player.velocity.x = 0
		dash_component.is_dashing = false
	elif (player.is_on_floor()
	and not player.is_crouching
	and dash_component.is_dashing == false):
		movement_componet.movement_update(input_direction) # no deceleration exists
		
	

#--------------------------------------------------------------end of movemnt hadling 
#--------------------------------------------------------------start of array managent 
#this doent implie dash can work how i want
func buffer_check(input_h: Array, sequence: Array[int], Attack_buttion: Array[int]) -> bool:
	if get_vaild_sequences(input_h,sequence).size() > 0 and single_input_check(buffered_array,Attack_buttion):
		return true
	return false

## checks if there is a matcing value in the provided array this is uded to buffer things 
func single_input_check(array: Array, what: Array[int])-> bool:
	if array == null:
		push_error("Array empty when calling single input check")
		return false #TODO check if this is a good idea 
	for inputs in array:
		if inputs.has(what):
			return true
	return false


#FIXME accept the cahnge in main for the sequnce reader over the one in ai review
## retuns the index of the sequnce if its vaild
func get_vaild_sequences(input_h: Array[Array], sequence: Array[int]) -> Dictionary[int, int]:
	var valid: Dictionary[int,int]
	var curent_digit: int = 0
	var total_digits: int = sequence.size()
	var index_of_most_recent: int  =0 
	sequence.reverse()
	for index in input_h.size():
		if input_h[index].has(sequence.get(curent_digit)):# check if an input is vaild for that sqeuence 
			if curent_digit == 0:
				index_of_most_recent = index
			curent_digit += 1
			if curent_digit == total_digits:
				valid.get_or_add(index_of_most_recent,sequence)
				curent_digit = 0
	return valid

## cuts array size to the max that was decided and appends the newest frame of info 
func resize_and_append_to_array(array: Array, max_size: int, this_frame_inputs: Array[int]):
	if array.size() > max_size + 1:
		push_error("input history exceeded max size by more than 1 frame, something is adding to it externally")
	while array.size() >= max_size:
		array.remove_at(-1) # last index
		
		#add the new input the end
	array.push_front(this_frame_inputs.duplicate()) # add to front
	

## filters the inputs to get the needed and valid ones first should allways be running
func input_filter():
	inputs_of_curent_frame_for_attacks.clear()
	#inputs_of_curent_frame_for_display.clear()
	#optimized by ai useing vars to not need to call the function a milion times 
	var up: bool = Input.is_action_pressed("up")
	var down: bool = Input.is_action_pressed("down")
	var left: bool = Input.is_action_pressed("left")
	var right: bool = Input.is_action_pressed("right")
	var light_punch: bool = Input.is_action_just_pressed("LP")
	var light_kick: bool = Input.is_action_just_pressed("LK")
	var heavy_punch: bool = Input.is_action_just_pressed("HP") 
	var heavy_kick: bool = Input.is_action_just_pressed("HK") 
	var light_punch_hold: bool = Input.is_action_pressed("LP")
	var light_kick_hold: bool = Input.is_action_pressed("LK")
	var heavy_punch_hold: bool = Input.is_action_pressed("HP") 
	var heavy_kick_hold: bool = Input.is_action_pressed("HK") 
	
	
	#picking a direction with binary math
	var bit_index =(int(up) << 3) | (int(down) << 2) | (int(left) << 1) | int(right)
	inputs_of_curent_frame_for_attacks.append(direction_look_up_array[bit_index])
	#inputs_of_curent_frame_for_display.append(direction_look_up_array[bit_index])
	# end of ai work
	if Input.is_action_pressed("fake inputs enabled"):
		press() 
	# Attacks
	if FrameByFrameMode.frame_by_frame_mode_endabled:
		if (light_kick_hold and heavy_kick_hold):
			inputs_of_curent_frame_for_attacks.append(EXK) 
		if (light_punch_hold and heavy_punch_hold):
			inputs_of_curent_frame_for_attacks.append(EXP)
		if (light_kick_hold and light_punch_hold):
			inputs_of_curent_frame_for_attacks.append(LPK)
		if (heavy_kick_hold and heavy_punch_hold):
			inputs_of_curent_frame_for_attacks.append(HPK)
		if light_punch_hold: inputs_of_curent_frame_for_attacks.append(LP)
		if light_kick_hold: inputs_of_curent_frame_for_attacks.append(LK)
		if heavy_punch_hold: inputs_of_curent_frame_for_attacks.append(HP)
		if heavy_kick_hold: inputs_of_curent_frame_for_attacks.append(HK)
	
	if (light_kick and heavy_kick):
		inputs_of_curent_frame_for_attacks.append(EXK) 
	if (light_punch and heavy_punch):
		inputs_of_curent_frame_for_attacks.append(EXP)
	if (light_kick and light_punch):
		inputs_of_curent_frame_for_attacks.append(LPK)
	if (heavy_kick and heavy_punch):
		inputs_of_curent_frame_for_attacks.append(HPK)
	if light_punch: inputs_of_curent_frame_for_attacks.append(LP)
	if light_kick: inputs_of_curent_frame_for_attacks.append(LK)
	if heavy_punch: inputs_of_curent_frame_for_attacks.append(HP)
	if heavy_kick: inputs_of_curent_frame_for_attacks.append(HK)
	
	# for the display version
	#if (Input.is_action_pressed("LK") and Input.is_action_pressed("HK")):
		#inputs_of_curent_frame_for_display.append(EXK) 
	#if (Input.is_action_pressed("LP") and Input.is_action_pressed("HP")):
		#inputs_of_curent_frame_for_display.append(EXP)
	#if (Input.is_action_pressed("LK") and Input.is_action_pressed("LP")):
		#inputs_of_curent_frame_for_display.append(LPK)
	#if (Input.is_action_pressed("HK") and Input.is_action_pressed("HP")):
		#inputs_of_curent_frame_for_display.append(HPK)
	#if Input.is_action_pressed("LP"): inputs_of_curent_frame_for_display.append(LP)
	#if Input.is_action_pressed("LK"): inputs_of_curent_frame_for_display.append(LK)
	#if Input.is_action_pressed("HP"): inputs_of_curent_frame_for_display.append(HP)
	#if Input.is_action_pressed("HK"): inputs_of_curent_frame_for_display.append(HK)

	resize_and_append_to_array(input_history,max_check_frames,inputs_of_curent_frame_for_attacks) # or call it rezise 
	resize_and_append_to_array(buffered_array,max_buffer_frames,inputs_of_curent_frame_for_attacks)

#--------------------------------------------------------end of array manamgent

func chose_actions_get_attack(dic: Dictionary[MoveList.AttackKey, Attack]):
	var most_recent_attack: Attack
	var valids: Dictionary[int,Array]
	var attack_partial_key: MoveList.AttackKey = MoveList.AttackKey.new(# the 2/4 keys
	player.is_on_floor(),
	player.is_facing_right,[],[])
	for attack: MoveList.AttackKey in dic:
		#this if stamnted does 3 / 4 of the key checks 
		if (attack.is_on_floor == attack_partial_key.is_on_floor 
		and attack.is_facing_right == attack_partial_key.is_facing_right 
		and single_input_check(buffered_array, attack.attack_button)):
			valids.merge(get_vaild_sequences(input_history, attack.sequence),true)# the 4th key check that also grabs the index of the seqxnrex 
			# add the most recent attack 
			if valids: 
				var index = valids.keys().min() # edit the most recent index if it needs to change
				var key: MoveList.AttackKey = MoveList.AttackKey.new(attack.is_on_floor,attack.is_facing_right,valids.get(index),attack.attack_button)
				most_recent_attack = dic.get(key)
		#loop end
		if most_recent_attack: attack_manager.start_attack(most_recent_attack)#stars the attack
		
	print(valids)
	
## choses what attack is to be used based on player state and the most recent sequenc
## howver ther is a workaround where a sequence must be at least 3 inputs otherwize
## the prioraity is not the first attack but is intseat the first in the dictionary  
func chose_action3():
	# check orrder is specials then comand noramls then nurtal normals and if attacking then combo attacks
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
		
		#for key in attack_manager.current_attack.combo_attacks_dictionary:
			#if (single_input_check(buffered_array,key) 
			#and attack_manager.current_attack.can_combo
			#and attack_manager.current_attack.has_hit):
				#print("you did it")
				#attack_manager.start_attack(attack_manager.current_attack.combo_attacks_dictionary[key])

func _physics_process(_delta: float) -> void:
	input_filter()
	#print(input_history)
	#state_print()
	if player.stun_manager.is_stuned == true:
		return
		
	input_direction = round(Input.get_axis("left","right"))
	movement_manager()
	if dash_component.is_dashing == false: # this decides if dash is cancelable
		chose_action3()
	if attack_manager.is_attacking == false:
		player.primary_hurt_box_manager()
		scale_component.flip_x_logic()
		dash_component.dash_handler2()
		movement_componet.jump_handler2()
	else: player.PrimaryHurtBoxes_component.disable_all_pimary_sprites()
	#input_history.reverse()
	#print(input_history)
	#input_history.reverse()

	
	
		
	
	
	
