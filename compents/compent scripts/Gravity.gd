## holds all the main movemnt opptions may want to splitit up into separte compents
class_name Gravity extends BehaviourBase
@export var gravity: int = 1000
var is_falling: bool = false # used in other scripts

func _ready():
	self.name= "gravity"
	super._ready()


## this fucntion alows falling due to gravity
func fall(delta_):
	if !enabled: 
		return
		#falling gravity
	if not host.is_on_floor():
		if host.velocity.y > 300: host.velocity.y = 300
		else: host.velocity.y += gravity * delta_
		

func _process(delta):
	fall(delta)
	
