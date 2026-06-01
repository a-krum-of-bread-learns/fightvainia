## holds all the main movemnt opptions may want to splitit up into separte compents
class_name Movement extends BehaviourBase
@export var prejump_timer: FrameTimer ## the timer fro prejumping 
@export var coyote_timer: FrameTimer ## a timer to check if we can still jump without it being considerd in air see [TimerComponet]
@export var input_manager: InputManager
var current_jump_direction: int ## saves the value for the jump while the delay happens
var is_jumping: bool = false## tracks if the entity is trying to jump
var can_c_jump: bool = false
# cuold change can_air_action_jump to a int for multiple jumps
var can_air_action_jump: bool = false ## tracks if the player can jump again in air


##ready set go (8) ## renameing 
func _ready():
	self.name= "movement"
	super._ready()
	if coyote_timer == null: push_error("InputManager: coyote_timer not assigned")
	
## this fucntion alows side ways movement based on speed ans direction
func movement_update(desired_dir: int):
	if !enabled: return
	#travel direction in x
	if desired_dir: host.velocity.x = host.stats.move_speed * desired_dir
	else: host.velocity.x = 0


func jump_handler2():
	#bit of set up 
	if host.is_on_floor() and is_jumping == false: 
		coyote_timer.start_frame_timer(host.stats.c_timer_length)
		can_c_jump = true
	elif is_jumping:
		can_c_jump = false
		input_manager.gravity_component.is_falling = true
		input_manager.dash_component.is_dashing = false
		
	if (#(buffer_check(buffered_array,U,U)
		#or buffer_check(buffered_array,UR,UR)
		#or buffer_check(buffered_array,UL,UL))
		#or 
		Input.is_action_just_pressed("jump")
		or (Input.is_action_pressed("jump") and FrameByFrameMode.frame_by_frame_mode_endabled)):
		#ground 
		if host.is_on_floor() and is_jumping == false:
			can_air_action_jump = true
			jump(input_manager.input_direction)
			coyote_timer.frames_left = 0
			print("g")
		
		#coyote jump
		elif (host.is_on_floor() == false
		and coyote_timer.frames_left > 0 
		and can_c_jump 
		and (Input.is_action_just_pressed("up") or 
		Input.is_action_pressed("jump"))): 
			coyote_timer.frames_left = 0
			jump(input_manager.input_direction)
			print("c")
		
		#air jump
		elif (can_air_action_jump
		 and is_jumping == false
		 and (Input.is_action_just_pressed("up") or 
		Input.is_action_pressed("jump"))):
			can_air_action_jump = false
			jump(input_manager.input_direction)
			print("a")

#TODO consider using += if the speed is greater than or less then in the same direction 
# probably wont to above comment
## allows the player to set speed to a vector
func jump(input_direction: int):
	if !enabled: 
		return
	var jump_vector: Vector2 = Vector2(host.stats.move_speed*input_manager.input_direction,host.stats.jump_velocityY)
	if is_jumping == false: 
		prejump_timer.start_frame_timer(host.stats.prejump_frames)
		is_jumping = true
		current_jump_direction = sign(jump_vector.x)
	elif prejump_timer.frames_left == 1:
		host.position = host.position + Vector2(0,-2)
	elif is_jumping and prejump_timer.is_stoped():
		host.velocity = jump_vector
		is_jumping = false
		current_jump_direction = 0
		
## process is process (7)
func _process(_delta):
	if is_jumping: jump(current_jump_direction)
