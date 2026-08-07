@tool
class_name SimpleMovingObject extends Path2D
@export var use_by_pixel: bool:
	set(value):
		use_by_pixel = value
		notify_property_list_changed()
@export var speed_by_pixels_per_frame: float = 0 
@export_range(0,1,0.0001) var speed_by_percent_per_frame: float = 0
@export var pathfollow: PathFollow2D
@export var anibody: AnimatableBody2D
#@export var 1d progress curve:

func _validate_property(property: Dictionary) -> void:
	if property.name == "speed_by_pixels_per_frame" and use_by_pixel == false:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name == "speed_by_percent_per_frame" and use_by_pixel:
		property.usage = PROPERTY_USAGE_NO_EDITOR
		
func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		pass
	else:
		if use_by_pixel: pathfollow.progress += speed_by_pixels_per_frame
		else: pathfollow.progress_ratio += speed_by_percent_per_frame
		anibody.global_position = pathfollow.global_position
	
