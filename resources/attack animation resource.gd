class_name AttackAnimationPart extends Resource

@export var displacement: Vector2
@export var time_in_frames: int = 30
#add var kill momentum

func get_time()-> float:
	return time_in_frames/60.0
	
func get_velocty(is_facing_right: bool) -> Vector2:
	if is_facing_right:
		return displacement/(get_time())
	elif is_facing_right == false:
		return Vector2(displacement.x*-1,displacement.y)/(get_time())
	else:
		push_error("tweens are not working find the error")
		return Vector2.ZERO
	
