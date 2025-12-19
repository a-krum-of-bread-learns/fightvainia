
## holds all the main movemnt opptions may want to splitit up into separte compents
class_name Movement extends BehaviourBase
@export var prejump_frames: int = 4 ##prejump delay
@export var timer: FrameTimer ## the timer fro prejumping 
@export var jump_velocityY: float = -300 ## vertacial jump speed value 
@export var move_speed: float = 100 ## horazontall speed value


var current_jump_vector: Vector2 ## saves the value for the jump while the delay happens
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
func jump(jump_vector: Vector2):
	if !enabled: 
		return
	
	if is_jumping == false: 
		timer.start_frame_timer(prejump_frames)
		is_jumping = true
		current_jump_vector = jump_vector
	elif timer.frames_left == 1:
		host.position = host.position + Vector2(0,-2)
	elif is_jumping and timer.is_stoped():
		host.velocity = jump_vector
		is_jumping = false
		current_jump_vector = Vector2.ZERO
		
## process is process (7)
func _process(_delta):
	if is_jumping: jump(current_jump_vector)
