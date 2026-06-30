## holds all the main movemnt opptions may want to splitit up into separte compents
class_name Movement extends BehaviourBase
@export var prejump_timer: FrameTimer ## the timer fro prejumping 
@export var coyote_timer: FrameTimer ## a timer to check if we can still jump without it being considerd in air see [TimerComponet]
var current_jump_direction: int ## saves the value for the jump while the delay happens
var can_c_jump: bool = false

@onready var remaining_air_jumps: int = (host.stats as PlayerStats).max_air_jump_count ## tracks if the player can jump again in air

#FIXME jump buffering or make it an "attack" 

##ready set go (8) ## renameing 
func _ready():
	self.name= "movement"
	super._ready()
	if coyote_timer == null: push_error("Movement: coyote_timer not assigned")
	(host.contol_node as InputManager).jump_signal.connect(start_jump)
	
## this fucntion alows side ways movement based on speed ans direction
func movement_update(desired_dir: int):
	if !enabled: return
	#travel direction in x
	if desired_dir: host.velocity.x = host.stats.move_speed * desired_dir
	else: host.velocity.x = 0


func start_jump(dir: int):
	#bit of set up 
	if host.is_on_floor() and host.is_jumping == false: 
		coyote_timer.start_frame_timer(host.stats.c_timer_length)
		can_c_jump = true
	elif host.is_jumping:
		can_c_jump = false
		host.is_falling = true
		host.is_dashing = false
		
	#ground 
	if host.is_on_floor():
		remaining_air_jumps = (host.stats as PlayerStats).max_air_jump_count
		continue_jump(dir)
		coyote_timer.frames_left = 0
		print("g")
	
	#coyote jump
	elif (host.is_on_floor() == false
	and coyote_timer.frames_left > 0 
	and can_c_jump): 
		coyote_timer.frames_left = 0
		continue_jump(dir)
		print("c")
	
	#air jump
	elif (remaining_air_jumps > 0):
		remaining_air_jumps -= 1
		continue_jump(dir)
		print("a")

#TODO consider using += if the speed is greater than or less then in the same direction 
# probably wont to above comment for a while
## allows the player to set speed to a vector
func continue_jump(input_direction: int):
	if !enabled: 
		return
	var jump_vector: Vector2 = Vector2(host.stats.move_speed*input_direction,host.stats.jump_velocityY)
	if host.is_jumping == false: 
		prejump_timer.start_frame_timer(host.stats.prejump_frames)
		host.is_jumping = true
		current_jump_direction = sign(jump_vector.x)
	elif prejump_timer.frames_left == 1:
		host.position = host.position + Vector2(0,-2)
	elif host.is_jumping and prejump_timer.is_stoped():
		host.velocity = jump_vector
		host.is_jumping = false
		current_jump_direction = 0
		
## process is process (7)
func _process(_delta):
	if host.is_stuned: return
	if host.is_attacking == false:
		if host.is_jumping: continue_jump(current_jump_direction)
		
