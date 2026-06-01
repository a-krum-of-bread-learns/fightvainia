## this is used to change the size of a node and may be used to flip direction as well
##
class_name Scale extends BehaviourBase
const RIGHT = Vector2(1,1)
const LEFT = Vector2(-1,1) 

## the thing you want to scacle
@export var node: Node2D
##the delay for the scale to be used by a [FrameTimer]
## the timer used to make a delay
@export var timer: FrameTimer
@export var input_manager: InputManager
## a value to store the scale that is current 
var current_flip_direction: Vector2 = Vector2.ONE
## the check for if turing around
var is_turning: bool = false


##ready set go (3) renaming  
func _ready():
	self.name= "scale"
	super._ready()
	if host.stats == null:
		push_error("Scale: stats not set on "+ str(host.name))
		return
	
## this sets the new scale of the [member node] after the delay from the [meber timer]
func set_scale(new_scale: Vector2):
	if !enabled: 
		return
	node.scale = new_scale
	if node.scale.x>0: host.is_facing_right = true
	elif node.scale.x<0: host.is_facing_right = false
	is_turning = false
		
#TODO add more conditons to tuitning around  # this may be consederd done else whare
## identifies when to flip player on ground
## this sets the new scale of the [member node] after the delay from the [meber timer]
func flip_x_logic():
	if !enabled: 
		return
		
	var new_scale: Vector2 = current_flip_direction
	if host.is_on_floor() and input_manager.input_direction == -1:
		new_scale = Vector2(-1,1)
	elif host.is_on_floor() and input_manager.input_direction == 1:
		new_scale = Vector2(1,1)
	
	set_scale(new_scale)
