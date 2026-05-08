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
var inputs_of_curent_frame: Array[int] ## the single frame of input that is used in [members input_history] and [member buffered_array]
var max_check_frames: int = 20 ## the frame cap for motion inputs to be checked used with [method resize_and_append_to_array]
var max_buffer_frames: int = 5 ## the frame cap for the final input of an action to be checked used with [method resize_and_append_to_array]


var input_direction: int = 0 ## tells us the direstion the playre wants to move
var can_air_action_jump: bool = false ## tracks if the player can jump again in air
var can_air_action_dash: bool = false  ## tracks if the player can dach again in air
var jump_relesed: bool = false

# combining player script with input manager
@export_group("player info")
@export var player: Player ## the player see [Player]
@export var attack_manager: AttackManager ##see [AttackManger]
@export var coyote_timer: FrameTimer ## a timer to check if we can still jump without it being considerd in air see [TimerComponet]
@export var c_timer_length: int = 6 # same as .1 seconds
var can_c_jump: bool = false# can coyote jump
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
func flip_x_logic():
	if scale_component:
		if player.is_on_floor() and input_direction == -1:
			scale_component.set_scale(Vector2(-1,1))
		elif player.is_on_floor() and input_direction == 1:
			scale_component.set_scale(Vector2(1,1))
#-------------------------------------------------------------start of movemnt handling 

func jump_handler2():
	#bit of set up 
	if player.is_on_floor() and movement_componet.is_jumping == false: 
		coyote_timer.start_frame_timer(c_timer_length)
		can_c_jump = true
	elif movement_componet.is_jumping:
		can_c_jump = false
		gravity_component.is_falling = true
		dash_component.is_dashing = false
		
	if (#(buffer_check(buffered_array,U,U)
		#or buffer_check(buffered_array,UR,UR)
		#or buffer_check(buffered_array,UL,UL))
		#or 
		Input.is_action_pressed("jump")):
		#ground 
		if player.is_on_floor() and movement_componet.is_jumping == false:
			can_air_action_jump = true
			movement_componet.jump(input_direction)
			coyote_timer.frames_left = 0
			print("g")
		
		#coyote jump
		elif (player.is_on_floor() == false
		and coyote_timer.frames_left > 0 
		and can_c_jump 
		and (Input.is_action_just_pressed("up") or 
		Input.is_action_pressed("jump"))): 
			coyote_timer.frames_left = 0
			movement_componet.jump(input_direction)
			print("c")
		
		#air jump
		elif (can_air_action_jump
		 and movement_componet.is_jumping == false
		 and (Input.is_action_just_pressed("up") or 
		Input.is_action_pressed("jump"))):
			can_air_action_jump = false
			movement_componet.jump(input_direction)
			print("a")


func dash_handler2():
	#some set up 
	if dash_component.is_dashing:
		gravity_component.is_falling = false
	else: gravity_component.is_falling = true
	if player.is_on_floor(): can_air_action_dash = true
	
	if (buffer_check(input_history, DASHR,R)
		and dash_component.is_dashing == false):
		if player.is_on_floor():
			print("ground dash")
			dash_component.dash(Vector2.RIGHT)
			dash_component.is_dashing = true
		elif can_air_action_dash:
			dash_component.dash(Vector2.RIGHT)
			dash_component.is_dashing = true
			can_air_action_dash = false

	elif (buffer_check(input_history, DASHL,L)
		and dash_component.is_dashing == false):
		if player.is_on_floor():
			print("ground dash")
			dash_component.dash(Vector2.LEFT)
			dash_component.is_dashing = true
		elif can_air_action_dash:
			dash_component.dash(Vector2.LEFT )
			dash_component.is_dashing = true
			can_air_action_dash = false
		

## handels logic for when to move
func movement_manager():
	if player.is_on_floor() and (player.is_crouching or attack_manager.is_attacking):
		player.velocity.x = 0
		dash_component.is_dashing = false
	elif (player.is_on_floor()
	and not player.is_crouching
	and dash_component.is_dashing == false):
		movement_componet.movement_update(input_direction) # no deceleration exists
		
	

#--------------------------------------------------------------end of movemnt hadling 
#--------------------------------------------------------------start of array managent 
#this doent implie dash can work how i want
func buffer_check(input_h: Array, sequence: int, Attack_buttion: int) -> bool:
	if get_vaild_sequences(input_h,sequence).size() > 0 and single_input_check(buffered_array,Attack_buttion):
		return true
	return false

## checks if there is a matcing value in the provided array this is uded to buffer things 
func single_input_check(array: Array, what: int)-> bool:
	if array == null: return false #TODO check if this is a good idea 
	for inputs in array:
		if inputs.has(what):
			return true
	return false

##spilts a sequnce into indicaul digits to be used by otehr functions
func sequence_spliter(sequence: int) -> Array[int]:
	var digits: Array[int]
	while (sequence):
		digits.push_front(sequence%10)
		@warning_ignore("integer_division")# that is intedned 
		sequence = sequence / 10
	return digits

## retuns the index of the sequnce if its vaild
func get_vaild_sequences(input_h: Array[Array], sequence: int) -> Dictionary[int, int]:
	var valid: Dictionary[int,int]
	var curent_index: int = 0
	var curent_digit: int = 0
	var digits: Array[int] = sequence_spliter(sequence)
	var total_digits: int = digits.size()
	digits.reverse()
	for inputs in input_h:
		curent_index += 1
		if inputs.has(digits.get(curent_digit)):# check if an input is vaild for that sqeuence 
			curent_digit += 1
			if curent_digit == total_digits:
				valid.get_or_add(curent_index,sequence)
				curent_index = 0
				curent_digit = 0
			else: pass
	return valid

## cuts array size to the max that was decided and appends the newest frame of info 
func resize_and_append_to_array(array: Array, max_size: int, this_frame_inputs: Array[int]):
	if array.size() >= max_size:
		array.remove_at(-1) # last index
		
		#add the new input the end
	array.push_front(this_frame_inputs.duplicate()) # add to front
	

## filters the inputs to get the needed and valid ones first should allways be running
func input_filter():
	inputs_of_curent_frame.clear()
	#optimized by ai useing vars to not need to call the function a milion times 
	var up: bool = Input.is_action_pressed("up")
	var down: bool = Input.is_action_pressed("down")
	var left: bool = Input.is_action_pressed("left")
	var right: bool = Input.is_action_pressed("right")
	#picking a direction with binary math
	var bit_index =(int(up) << 3) | (int(down) << 2) | (int(left) << 1) | int(right)
	inputs_of_curent_frame.append(direction_look_up_array[bit_index])
	# end of ai work
	if Input.is_action_pressed("fake inputs enabled"):
		press() 
	# Attacks
	if (Input.is_action_pressed("LK") and Input.is_action_pressed("HK")):
		inputs_of_curent_frame.append(EXK) 
	if (Input.is_action_pressed("LP") and Input.is_action_pressed("HP")):
		inputs_of_curent_frame.append(EXP)
	if (Input.is_action_pressed("LK") and Input.is_action_pressed("LP")):
		inputs_of_curent_frame.append(LPK)
	if (Input.is_action_pressed("HK") and Input.is_action_pressed("HP")):
		inputs_of_curent_frame.append(HPK)
	if Input.is_action_pressed("LP"): inputs_of_curent_frame.append(LP)
	if Input.is_action_pressed("LK"): inputs_of_curent_frame.append(LK)
	if Input.is_action_pressed("HP"): inputs_of_curent_frame.append(HP)
	if Input.is_action_pressed("HK"): inputs_of_curent_frame.append(HK)
	

	resize_and_append_to_array(input_history,max_check_frames,inputs_of_curent_frame) # or call it rezise 
	resize_and_append_to_array(buffered_array,max_buffer_frames,inputs_of_curent_frame)

#--------------------------------------------------------end of array manamgent

func get_attack_button() -> int:
	if FrameByFrameMode.frame_by_frame_mode_endabled == true:# for if so that when it unfecese you can use the attack by holding the butiion
		if (Input.is_action_pressed("LK") and Input.is_action_pressed("HK")):
			return EXK
		elif (Input.is_action_pressed("LP") and Input.is_action_pressed("HP")):
			return EXP
		elif (Input.is_action_pressed("LK") and Input.is_action_pressed("LP")):
			return LPK
		elif (Input.is_action_pressed("HK") and Input.is_action_pressed("HP")):
			return HPK
		elif Input.is_action_pressed("LP"): return LP
		elif Input.is_action_pressed("LK"): return LK
		elif Input.is_action_pressed("HP"): return HP
		elif Input.is_action_pressed("HK"): return HK
	else:
		if (Input.is_action_just_pressed("LK") and Input.is_action_just_pressed("HK")):
			return EXK
		elif (Input.is_action_just_pressed("LP") and Input.is_action_just_pressed("HP")):
			return EXP
		elif (Input.is_action_just_pressed("LK") and Input.is_action_just_pressed("LP")):
			return LPK
		elif (Input.is_action_just_pressed("HK") and Input.is_action_just_pressed("HP")):
			return HPK
		elif Input.is_action_just_pressed("LP"): return LP
		elif Input.is_action_just_pressed("LK"): return LK
		elif Input.is_action_just_pressed("HP"): return HP
		elif Input.is_action_just_pressed("HK"): return HK
	return 0

func chose_actions_get_attack(dic: Dictionary[Array, Attack]):
	var index: int
	var most_recent_attack: Attack
	var valids: Dictionary[int,int]
	var attack_partial_key: Array = [# the 2/4 keys
	player.is_on_floor(),
	player.is_facing_right]
	
	for attack in dic:
		#this if stamnted does 3 / 4 of the key checks 
		if (attack[0] == attack_partial_key[0] 
		and attack[1] == attack_partial_key[1] 
		and single_input_check(buffered_array, attack[3])):
			valids.merge(get_vaild_sequences(input_history, attack[2],),true)# the 4th key check that also grabs the index of the seqxnrex 
			# add the most recent attack 
			if valids: 
				index = valids.keys().min() # edit the most recent index if it needs to change
				most_recent_attack = dic.get([attack[0],attack[1],valids.get(index),attack[3]])
		#loop end
		if most_recent_attack: attack_manager.start_attack(most_recent_attack)#stars the attack
		
	#print(valids)
	
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
		
		for key in attack_manager.current_attack.combo_attacks_dictionary:
			if (single_input_check(buffered_array,key) 
			and attack_manager.current_attack.can_combo
			and attack_manager.current_attack.has_hit):
				print("you did it")
				attack_manager.start_attack(attack_manager.current_attack.combo_attacks_dictionary[key])

func _process(_delta):
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
		flip_x_logic()
		dash_handler2()
		jump_handler2()
	else: player.PrimaryHurtBoxes_component.disable_all_pimary_sprites()

	
	
		
	
	
	
