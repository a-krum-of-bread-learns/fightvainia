class_name Turret extends SpawnObject
@export var is_facing_right: bool
@export var frame_timer: FrameTimer
@export_range(1,10000) var delay: int

func _process(_delta: float) -> void:
	if frame_timer.is_stoped():
		frame_timer.start_frame_timer(delay)
		spawn(is_facing_right)
			
