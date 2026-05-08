## holds all the main movemnt opptions may want to splitit up into separte compents
class_name Gravity extends BehaviourBase
@export var gravity: int = 8000
@export var terminal_velocity: int = 2000
@export var is_falling: bool = false

func _ready():
	self.name= "gravity"
	super._ready()


## this fucntion alows falling due to gravity
func fall(delta_):
	if !enabled: 
		return
	if not host.is_on_floor():
		if host.velocity.y > terminal_velocity: host.velocity.y = terminal_velocity
		else: host.velocity.y += gravity * delta_
		

func _process(delta):
	if is_falling:
		fall(delta)
	
