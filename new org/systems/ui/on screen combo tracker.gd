class_name ComboTracker extends Label
@export var host: EntityBase
var combo_count: int = 0
var target: EntityBase



func _ready():
	HelperFuncs.check_if_null(host,"host",self)
	host.attack_manager.has_hit_signal_attack_manger.connect(combo_tracker_logic)

func combo_tracker_logic(entity: EntityBase, blocked: bool) -> void:
	target = entity
	if target.stun_manager.stun_has_ended.is_connected(reset) == false:
		target.stun_manager.stun_has_ended.connect(reset)
		
	if blocked == true:
		reset()
		return
	combo_count += 1
	update_text()
	
func reset():
	combo_count = 0
	update_text()
	
func update_text():
	if combo_count >= 2:
		self.visible = true
		text = ("combo: " + str(combo_count))
	else: self.visible = false
