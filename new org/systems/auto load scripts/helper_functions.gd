class_name HelperFuncs

static func roll_chance(chance: float) -> bool:
	if chance < 0.0 or chance > 1.0:
		push_error("roll_chance: chance must be between 0 and 1, got " + str(chance) + "has be set to 0 or 1" )
		chance = clamp(chance, 0.0, 1.0)
	return chance >= randf()
	

static func check_if_null(value, label: String, node: Node) -> bool:
	if value == null:
		push_error(label + " is null | " + str(node.owner.scene_file_path) + " | " + str(node.get_path()))
		return true
	return false

static func facing_sign(is_facing_right: bool) -> int:
	return int(is_facing_right) * 2 - 1
