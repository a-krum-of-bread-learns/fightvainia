## this is used to change the size of a node and may be used to flip direction as well
##
class_name Scale extends BehaviourBase
## the thing you want to scacle
@export var node: Node2D
##the delay for the scale to be used by a [FrameTimer]
@export var prescale_frames: int = 3
## the timer used to make a delay
@export var timer: FrameTimer
## a value to store the scale that will be used 
var current_flip_direction: Vector2
## the check for if turing around
var is_turning: bool = false



##ready set go (3) renaming  
func _ready():
	self.name= "scale"
	super._ready()


## this sets the new scale of the [member node] after the delay from the [meber timer]
func set_scale(new_scale: Vector2):
	if !enabled: 
		return
	if is_turning == false:
		is_turning = true
		timer.start_frame_timer(prescale_frames)
		current_flip_direction=new_scale
	elif timer.is_stoped():
		node.scale = new_scale
		if node.scale.x>0: host.is_facing_right=true
		elif node.scale.x<0: host.is_facing_right=false
		is_turning = false
		
			

##process is process (5) 
## makes the check every frame then alows recalling the scaleing and calls [method set_scale]
func _process(_delta):
	if is_turning: set_scale(current_flip_direction)
