@tool
class_name HealBoxData extends Resource
@export var heal_amount: int = -1
#@export var heal_percent: float = 0.0  
#@export var affects_self_only: bool = false


func validate_data(owner) -> void:
	var context: String = str(owner.scene_file_path) + " | " + str(get_path())
	if heal_amount == -1:
		push_error("heal_amount not assigned | " + context)
