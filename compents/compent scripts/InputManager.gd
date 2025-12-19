## This component manages the control of the player selection of Attacks input filtering
## Inputs that are filtered use numpad notation for direction
## and uses numpad notation +10 for Attack buttons
#TODO decide if i call thos player contoller instead 
class_name InputManager extends MoveList
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

#TODO add a boolen to tell me when i can do somthing
#both Array[Array]s need a bit to not cause erroron start elsewher in code
# FIXME refactor input history is a global varable remove it a few time from 
#FIXME function calls speicifly sequence reader
var input_history: Array[Array] = [[5],[5]] ## holds the full input history up to [member max_check_frames]
var buffered_array: Array[Array] = [[5],[5]]## holds the buffer input history up to [member max_buffer_frames]
var inputs_of_curent_frame: Array[int] ## the single frame of input that is used in [members input_history] and [member buffered_array]
var max_check_frames: int = 20 ## the frame cap for motion inputs to be checked used with [method resize_and_append_to_array]
var max_buffer_frames: int = 5 ## the frame cap for the final input of an action to be checked used with [method resize_and_append_to_array]


var input_direction: int = 0 ## tells us the direstion the playre wants to move
var can_air_action_jump: bool = false ## tracks if the player can jump again in air
var can_air_action_dash: bool = false  ## tracks if the player can dach again in air
var jump_relesed: bool= false

# combining player script with input manager
@export_group("player info")
@export var player: Player ## the player host see [Player]
@export var attack_manager: AttackManger ##see [AttackManger]
@export var coyote_timer: FrameTimer ## a timer to check if we can still jump without it being considerd in air see [TimerComponet]
@export var c_timer_length: int = 6 # same as .1 seconds
var can_c_jump: bool = false# can coyote jump
@export var movement_componet: Movement ## see [Movement] 
@export var scale_component: Scale ## see [Scale] 
@export var dash_component: Dash ## see [Dash]
@export var gravity_component: Gravity
# TODO move the 2 expeot vars below to movnment componet 
@export var jump_velocityY: float = -300 #controls hight
@export var move_speed: float = 100 #contols walk speed

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


#TODO add more conditons to tuitning around  # this may be consederd done else whare
## identifies when to flip player on ground
func flip_x_logic():
	if scale_component:
		if player.is_on_floor() and input_direction == -1:
			scale_component.set_scale(Vector2(-1,1))
		elif player.is_on_floor() and input_direction == 1:
			scale_component.set_scale(Vector2(1,1))
#-------------------------------------------------------------start of movemnt handling 
## contols logic for what type of jump it is (grounded, coyote or air) and if they can still jump
#func jump_handler():
	#var jump_ = Input.is_action_just_pressed("jump") or Input.is_action_pressed("up")
	## ground jump 
	#if player.is_on_floor() and movement_componet.is_jumping == false:
		#can_air_action_jump = true
		#coyote_timer.expired = false
		#if jump_:
			#movement_componet.jump(Vector2(move_speed*input_direction,jump_velocityY)) 
			#coyote_timer.expired = true
	##coyote jump
	#elif coyote_timer.expired == false:
		#if coyote_timer.is_stopped():
			#coyote_timer.start(c_timer_length)
		#if jump_:
			#movement_componet.jump(Vector2(move_speed*input_direction,jump_velocityY)) 
			#coyote_timer.expired = true
	## air jump
	#elif can_air_action_jump and jump_:
		#movement_componet.jump(Vector2(move_speed*input_direction,jump_velocityY)) 
		#can_air_action_jump = false

# 2 cases for jumping: when frame by frame mode is actictive use space bar / 
#Input.is_action_pressed("jump") other witch will use both jumps imediatly 
#if pressed for more than 1 frame and one for up is pressed so that it is 
#read as true for a single frame
#FIXME refactor the vars move speed and jump velcityY  
func jump_handler2():
	#bit of set up 
	if player.is_on_floor() and movement_componet.is_jumping == false: 
		coyote_timer.start_frame_timer(c_timer_length)
		can_c_jump = true
	elif movement_componet.is_jumping:
		can_c_jump = false
		gravity_component.is_falling = true
		dash_component.is_dashing = false
		
	if ((checks_for_Attacks(buffered_array,U,U)
		or checks_for_Attacks(buffered_array,UR,UR)
		or checks_for_Attacks(buffered_array,UL,UL))
		or Input.is_action_pressed("jump")):
		#ground 
		if player.is_on_floor() and movement_componet.is_jumping == false:
			can_air_action_jump = true
			movement_componet.jump(Vector2(move_speed*input_direction,jump_velocityY))
			coyote_timer.frames_left = 0
			print("g")
		
		#coyote jump
		elif (player.is_on_floor() == false
		and coyote_timer.frames_left > 0 
		and can_c_jump 
		and (Input.is_action_just_pressed("up") or Input.is_action_pressed("jump"))): 
			coyote_timer.frames_left = 0
			movement_componet.jump(Vector2(move_speed*input_direction,jump_velocityY))
			print("c")
		
		#air jump
		elif (can_air_action_jump
		 and movement_componet.is_jumping == false
		 and (Input.is_action_just_pressed("up") or Input.is_action_pressed("jump"))):
			can_air_action_jump = false
			movement_componet.jump(Vector2(move_speed*input_direction,jump_velocityY))
			print("a")
		

#func dash_handler():
	#if dash_component.is_dashing:
		#gravity_component.is_falling = false
	#else: gravity_component.is_falling = true
	#
	#if player.is_on_floor(): can_air_action_dash = true
	#if not dash_component.is_dashing:
		#if (checks_for_Attacks(input_history, DASHR,R)
		#and dash_component.is_dashing == false 
		#and (player.is_on_floor() or can_air_action_dash)):
			#dash_component.dash(Vector2.RIGHT)
			#dash_component.is_dashing = true
		#elif (checks_for_Attacks(input_history, DASHL,L)
		#and dash_component.is_dashing == false 
		#and (player.is_on_floor() or can_air_action_dash)):
			#dash_component.dash(Vector2.LEFT)
			#dash_component.is_dashing = true
	##slight ground dash
	#elif not in_nested_array(buffered_array,R) and player.is_on_floor():
		#dash_component.is_dashing = false
	#elif not in_nested_array(buffered_array,L) and player.is_on_floor():
		#dash_component.is_dashing = false

func dash_handler2():
	#soem set up 
	if dash_component.is_dashing:
		gravity_component.is_falling = false
	else: gravity_component.is_falling = true
	if player.is_on_floor(): can_air_action_dash = true
	
	if (checks_for_Attacks(input_history, DASHR,R)
		and dash_component.is_dashing == false):
		if player.is_on_floor():
			print("ground dash")
			dash_component.dash(Vector2.RIGHT)
			dash_component.is_dashing = true
		elif can_air_action_dash:
			dash_component.dash(Vector2.RIGHT)
			dash_component.is_dashing = true
			can_air_action_dash = false

	elif (checks_for_Attacks(input_history, DASHL,L)
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
	if player.is_on_floor() and not player.is_crouching and dash_component.is_dashing == false:
		movement_componet.movement_update(input_direction) # no deceleration exists
	elif player.is_on_floor() and Input.is_action_pressed("down"):
		player.velocity.x = 0
		dash_component.is_dashing = false

#--------------------------------------------------------------end of movemnt hadling 
#--------------------------------------------------------------start of array managent 
#FIXME refactor make this nicer to under stand 
## breaks the sequneces into usable parts for the other method
func seqcence_reader(inputs_h: Array[Array], check: int) -> Array[int]:
	inputs_h.reverse() #this here to read form the most recent side of the array
	var digits:Array[int]
	var num = check
	var count: int = 0
	var curent_index: = 0
	var last_index: = -1
	# tells us size of the seqcunce to check 
	count = str(check).length()
	# this while splits the check to be used in an easey to work with array 
	# TODO try with just int?
	while (num):
		digits.push_back(num%10)
		@warning_ignore("integer_division")# that is intedned 
		num = num / 10
	
	# the check happens here
	var in_sequence_count: int = 0
	for inputs in inputs_h:
		curent_index+=1
		for input in inputs:
			if input == digits.get(in_sequence_count): 
				last_index = curent_index
				in_sequence_count += 1
				break # next frame if true
		if in_sequence_count == count:
			inputs_h.reverse()
			return [check,last_index]
	inputs_h.reverse()
	return [0,-1] # default return 

## cuts array size to the max that was decided and appends the newest frame of info 
func resize_and_append_to_array(array: Array, max_size: int, this_frame_inputs: Array[int]):
	if array.size() >= max_size:
		array.remove_at(0)
		#add the new input the end
	array.append(this_frame_inputs.duplicate())

## checks if there is a matcing value in the provided array this is uded to buffer things 
func in_nested_array(array: Array, what: int)-> bool:
	if array == null: return false #TODO check if this is a good idea 
	for i in array:
		if i.has(what):
			return true
	return false

## filters the imputs to get the needed and valid ones first
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
	if Input.is_action_pressed("LP"):
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
	
	#if Input.is_action_pressed("jump"): inputs_of_curent_frame.append()
	#size limit by removing the earlist input
	resize_and_append_to_array(input_history,max_check_frames,inputs_of_curent_frame) # or call it rezise 
	resize_and_append_to_array(buffered_array,max_buffer_frames,inputs_of_curent_frame)
	# print check
	#print(input_history)
	#print(buffered_array)
	#if input_history[-1] != input_history[-2]:
		#print("input changed")
	#print(seqcence_reader(input_history, DQCR))

# TODO ask ai about how it would best be to orgaisze this this that will be very big a some point
## this is where an Attack will be selected using many of the function in this class this will be a big part
#func chose_action():
	#if attack_manager.is_attacking == false:
		#for attack in Attacks:   <<<<<<<<<<<<<<<<<<<<<<<< use this formath for gernreal sequences
			#match attack:
				#lk: 
					##air specials
					##air normal
					##specials
					#if player.is_facing_right == true and checks_for_Attacks(input_history,DQCR,LK):
						#attack_manager.start_attack(dqcflk)
						#break
					#elif player.is_facing_right == false and checks_for_Attacks(input_history,DQCL,LK):
						#attack_manager.start_attack(dqcflk)
						#break
						##back Attack
					#elif player.is_facing_right == true and checks_for_Attacks(input_history,L,LK):
						#attack_manager.start_attack(blk)
						#break
					#elif player.is_facing_right == false and checks_for_Attacks(input_history,R,LK):
						#attack_manager.start_attack(blk)
						#break
						##regular buttion
					#elif Input.is_action_pressed("LK"):
						#attack_manager.start_attack(lk)
						#break
				#lp:
					##specials
					#if player.is_facing_right == true and checks_for_Attacks(input_history,DQCR,LP):
						#attack_manager.start_attack(dqcflp)
						#break
					#elif player.is_facing_right == false and checks_for_Attacks(input_history,DQCL,LP):
						#attack_manager.start_attack(dqcflp)
						#break
					##regular buttion
					#elif Input.is_action_pressed("LP"):
						#attack_manager.start_attack(lp)
						#break
				#
				#hk:
					#if Input.is_action_pressed("HK"):
						#attack_manager.start_attack(hk)
						#break
				#hp:
					#if Input.is_action_pressed("HP"):
						#attack_manager.start_attack(hp)
						#break
				#null: 
					#print(null)
					#continue
				#
	#elif attack_manager.is_attacking:
		##add loop
		#if attack_manager.current_attack.combo_attacks_dictionary.is_empty():
			#return
		#else:
			#
			#for key in attack_manager.current_attack.combo_attacks_dictionary:
				#
				#if in_nested_array(buffered_array,key) and attack_manager.current_attack.can_combo:
					#print("you did it")
					#attack_manager.start_attack(attack_manager.current_attack.combo_attacks_dictionary[key])
					#
					#
			#
	#
	#
	#
		##match seqcence_reader(input_history, DQCR):
			##DQCR when in_nested_array(buffered_array,EXK) and player.is_facing_right==true: 
				##print(str(DQCR) + str(EXK) + " forward")
			##DQCR when in_nested_array(buffered_array,EXK) and player.is_facing_right==false: 
				##print(str(DQCR) + str(EXK) + " back")
			##DQCR when in_nested_array(buffered_array,LK) and player.is_facing_right==true: 
				##print(str(DQCR) + str(LK) + " forward")
			##DQCR when in_nested_array(buffered_array,LK) and player.is_facing_right==false: 
				##print(str(DQCR) + str(LK) + " back")
			##DQCR when in_nested_array(buffered_array,HK) and player.is_facing_right==true: 
				##print(str(DQCR) + str(HK) + " forward")
			##DQCR when in_nested_array(buffered_array,HK) and player.is_facing_right==false: 
				##print(str(DQCR) + str(HK) + " back")

#--------------------------------------------------------end of array manamgent

#this doent implie dash can work how i want
func checks_for_Attacks(input_h:Array, sequence:int, Attack_buttion:int) -> bool:
	if seqcence_reader(input_h, sequence).front() == sequence and in_nested_array(buffered_array,Attack_buttion):
		return true
	return false

func get_attack_button()-> int:
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

func chose_action2():
	var sequnce: Array[int]
	var dic: Dictionary
	var valid: Array[Array]
	# sort order?
	#[LPK, lk, EXK, lp, HP, EXP, hp, HPK]
	if attack_manager.is_attacking == false:
	#special moves
		var a_buttion: int = get_attack_button()
		print(all_special_motions.get([player.is_facing_right, a_buttion]))
		if all_special_motions.get([player.is_facing_right, a_buttion]):
			dic = all_special_motions.get([player.is_facing_right, a_buttion])
		for motion in dic.keys():
			if seqcence_reader(input_history,motion).front() == motion:
				valid.append(seqcence_reader(input_history,motion))
				print(valid)
				# could be an enitre video 
				sequnce = valid.reduce(func(min0, seq): return seq if seq.back() < min0.back() else min0)
				print(sequnce)
				
		
		if sequnce:
			if sequnce == seqcence_reader(input_history,sequnce.front()):
				attack_manager.start_attack(all_special_motions[[player.is_facing_right, a_buttion]][sequnce.front()])
				print("you did it")
			
			
		if attack_manager.is_attacking: return
	#basic normals
		var buttion_normals: Dictionary = normals.get(a_buttion,{})
		if buttion_normals == {}: return
		# air attack set
		if player.is_on_floor() == false:
			if player.is_facing_right == true and checks_for_Attacks(input_history,L,LK):
				if buttion_normals.has(attack_type.AB): return
				attack_manager.start_attack(buttion_normals[attack_type.AB])
			elif player.is_facing_right == false and checks_for_Attacks(input_history,R,LK):
				if buttion_normals.has(attack_type.AB) == false: return
				attack_manager.start_attack(buttion_normals[attack_type.AB])
			else:
				if buttion_normals.has(attack_type.A) == false: return
				attack_manager.start_attack(buttion_normals[attack_type.A])
		# crouch set
		elif Input.is_action_pressed("down") and player.is_on_floor():
			if buttion_normals.has(attack_type.C) == false: return
			attack_manager.start_attack(buttion_normals[attack_type.C])
		# grounded set
		elif player.is_on_floor(): 
			if player.is_facing_right == true and checks_for_Attacks(input_history,L,LK):
				if buttion_normals.has(attack_type.B) == false: return
				attack_manager.start_attack(buttion_normals[attack_type.B])
			elif player.is_facing_right == false and checks_for_Attacks(input_history,R,LK):
				if buttion_normals.has(attack_type.B) == false: return
				attack_manager.start_attack(buttion_normals[attack_type.B])
			else:
				if buttion_normals.has(attack_type.N) == false: return
				attack_manager.start_attack(buttion_normals[attack_type.N])
	
	

		# sequnce 
		# "buttion"
		# facnig right
		#groups: air, ground, back, special
	#combo attacks 
	elif attack_manager.is_attacking:
		#TODO make check for combo attacks if it needs a sqecence for special 
		#TODO and a dictary that holds all special moves 
		if attack_manager.current_attack.combo_attacks_dictionary.is_empty():
			return
		else:
			for key in attack_manager.current_attack.combo_attacks_dictionary:
				if in_nested_array(buffered_array,key) and attack_manager.current_attack.can_combo:
					print("you did it")
					attack_manager.start_attack(attack_manager.current_attack.combo_attacks_dictionary[key])

func _process(_delta):
	input_direction = round(Input.get_axis("left","right"))
	#print(input_history)
	#print(player.get_last_motion())
	input_filter()
	chose_action2()
	movement_manager()
	flip_x_logic()
	dash_handler2()
	jump_handler2()
	
	
	
