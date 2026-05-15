##holds helth info and the call on death
class_name Health extends BehaviourBase
var current_health: int## self explantoy
## sets health to max at start 
func _ready():
	current_health = host.stats.max_health

## changes helth has option to set to a number currently can make it more than max
#TODO make it a max helth
func change_health(change: int, set_health: bool = false):
	if set_health == false: current_health -= change
	else: current_health = change
	if current_health <= 0:
		die()
#may become a signal 
## calls what to do on death may be custom for child classes
func die():
	print("died or somthing")
	host.queue_free()
	pass
