## Flips the direction of the entity and its child nodes.
##
## To use this properly, put everything that should flip — sprites, hitboxes/hurtboxes,
## attacks, rays, animations — under a folder [Node2D], excluding the entity root itself, and
## assign that folder as the node to flip. and set [member scale_target]
class_name Scale extends BehaviourBase
const RIGHT = Vector2(1,1)
const LEFT = Vector2(-1,1) 

## the thing you want to scacle
@export var scale_target: Node2D
## a value to store the scale that is current 
var current_flip_direction: Vector2 = Vector2.ONE
## the check for if turing around



func _ready():
	self.name= "scale"
	super._ready()
	HelperFuncs.check_if_null(host,"host",self)
	HelperFuncs.check_if_null(scale_target,"scale_target",self)
	if host.stats == null:
		push_error("Scale: stats not set on "+ str(host.name))
		return
	
## this sets the new scale of the [member node] after the delay from the [meber timer]
func set_scale(new_scale: Vector2):
	if !enabled: 
		return
	scale_target.scale = new_scale
	if scale_target.scale.x>0: host.is_facing_right = true
	elif scale_target.scale.x<0: host.is_facing_right = false

		
#TODO add more conditons to tuitning around  # this may be consederd done else whare
## identifies when to flip player on ground
## this sets the new scale of the [member node] after the delay from the [meber timer]
func flip_x_logic(dir: int ):
	if !enabled: 
		return
		
	var new_scale: Vector2 = current_flip_direction
	if dir == -1:
		new_scale = Vector2(-1,1)
	elif dir == 1:
		new_scale = Vector2(1,1)
		# only update if direction actually changed
	if new_scale != current_flip_direction:
		current_flip_direction = new_scale
		set_scale(new_scale)
