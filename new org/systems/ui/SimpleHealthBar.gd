class_name SimpleHealthBar extends TextureProgressBar
@export var host: EntityBase
##holds helth info and the call on death
var current_health: int ## self explantoy
signal health_changed(change: int)
signal zero_or_less_health

## sets health to max at start 
func _ready():
	HelperFuncs.check_if_null(host,"host",self)
	if host.stats == null:
		push_error("Health: stats not set on " + host.name)
	if host.stats.max_health <= 0:
		push_error("Health: max_health must be positive on " + host.name)
	current_health = host.stats.max_health
	max_value = host.stats.max_health
	min_value = 0
	value = current_health

## changes helth has option to set to a number currently can make it more than max
#TODO make it a max helth
func change_health(change: int, set_health: bool = false):
	var actual_change: int
	if set_health == false: 
		actual_change = -change
		current_health -= change
	else: 
		actual_change = change - current_health 
		current_health = change
	
	if current_health <= 0:
		die()
	health_changed.emit(actual_change)
	value = value + actual_change

## calls what to do on death may be custom for child classes
func die():
	print("died or somthing")
	zero_or_less_health.emit()
	#queue_free()
	
	
	
