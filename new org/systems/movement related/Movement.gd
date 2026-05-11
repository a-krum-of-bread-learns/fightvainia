## holds all the main movemnt opptions may want to splitit up into separte compents
class_name Movement extends BehaviourBase
@export var prejump_frames: int = 4 ##prejump delay
@export var timer: FrameTimer ## the timer fro prejumping 
@export var jump_velocityY: float = -2400 ## vertacial jump speed value 
@export var move_speed: float = 200 ## horazontall speed value
var current_jump_direction: int ## saves the value for the jump while the delay happens
var is_jumping: bool = false## tracks if the entity is trying to jump

##ready set go (8) ## renameing 
func _ready():
	self.name= "movement"
	super._ready()
	
## this fucntion alows side ways movement based on speed ans direction
func movement_update(desired_dir: int):
	if !enabled: 
		return
	#travel direction in x
	if desired_dir:
		host.velocity.x = move_speed * desired_dir
	else:
		host.velocity.x = 0


#TODO consider using += if the speed is greater than or less then in the same direction 
# probably wont to above comment
## allows the player to set speed to a vector
func jump(input_direction: int):
	if !enabled: 
		return
	var jump_vector: Vector2 = Vector2(move_speed*input_direction,jump_velocityY)
	if is_jumping == false: 
		timer.start_frame_timer(prejump_frames)
		is_jumping = true
		current_jump_direction = sign(jump_vector.x)
	elif timer.frames_left == 1:
		host.position = host.position + Vector2(0,-2)
	elif is_jumping and timer.is_stoped():
		host.velocity = jump_vector
		is_jumping = false
		current_jump_direction = 0
		
## process is process (7)
func _process(_delta):
	if is_jumping: jump(current_jump_direction)
