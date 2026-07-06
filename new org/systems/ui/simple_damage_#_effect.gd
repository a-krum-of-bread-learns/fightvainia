class_name SimpleDamageNumberEffect extends Label
@export var host: EntityBase
var tween: Tween
func _ready() -> void:
	HelperFuncs.check_if_null(host,"host",self)
	host.health_component.health_changed.connect(_on_damage_taken)

func _on_damage_taken(damage: int):
	if damage >=0:
		label_settings.font_color = Color.GREEN
	else:
		label_settings.font_color = Color.RED
	if tween:
		tween.kill() # Abort the previous animation if ther was any .
	tween = create_tween()
	modulate.a = 1
	tween.tween_property(self,"modulate:a",0,.5)
	text = str(abs(damage))
	
	
