class_name SelfComboTracker extends BehaviourBase
@export var must_be_comboed: = false
@export var must_be_comboed_threshold: int = 0
signal combo_count_changed(count: int)
signal combo_broken()
var combo_count: int = 0

#setting the ready name
func _ready():
	self.name = "combo_tracker"
	super._ready()
	HelperFuncs.check_if_null(host,"host",self)
	host.stun_manager.stun_has_ended.connect(reset)


func combo_tracker_logic(entity: EntityBase, blocked: bool) -> void:
	if not enabled:
		return
	if blocked == true:
		reset()
		return
	combo_count += 1
	combo_count_changed.emit(combo_count) # for UI and maybe a really speisifc move 
	
func reset():
	combo_count = 0
	combo_broken.emit()
	
func damage_allowed() -> bool:
	if not must_be_comboed:
		return true
	return combo_count >= must_be_comboed_threshold
