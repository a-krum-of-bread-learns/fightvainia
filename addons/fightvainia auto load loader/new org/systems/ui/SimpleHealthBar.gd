## this node trackes and updates the health of an entity in both code and viusaly 
class_name SimpleHealthBar extends TextureProgressBar
@export var host: EntityBase
##holds helth info and the call on death
var current_health: float ## self explantoy

signal health_changed(change: int)
signal current_health_value(current: int)
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

func reduce_health(change: float):
	current_health = current_health - change
	health_changed.emit(-change)
	current_health_value.emit(current_health)
	if current_health <= 0:
		die()
		
func increse_health(change: float):
	var previous_health: float = current_health
	var actual_change: float
	current_health = min(current_health + change, max_value)
	actual_change = current_health - previous_health
	health_changed.emit(actual_change)
	current_health_value.emit(current_health)


func set_health(set_val: float):
	var previous_health: float = current_health
	var actual_change: float
	current_health = set_val
	actual_change = current_health - previous_health
	health_changed.emit(actual_change)
	current_health_value.emit(current_health)
	if current_health <= 0:
		die()

## calls what to do on death may be custom for child classes
func die():
	print("died or somthing")
	zero_or_less_health.emit()
	#queue_free()
	
	
	
