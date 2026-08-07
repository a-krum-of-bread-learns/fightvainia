class_name framemini extends Node2D
@export var repeat_this_frame: int 
var box_shapes: Array[CollisionShape2D] ## 2 layers down in the forced structor are CollisionShape2D refrenced here

func _ready() -> void:
	for area in get_children():
		for shape in area.get_children():
			if shape is CollisionShape2D:
				box_shapes.append(shape)
				shape.disabled = true
				#if Engine.is_editor_hint():
					#shape.visible = true
				#else: shape.visible = false
				

## sets this frames box_shapes diabled
func set_frame_disabled(value: bool):
	for box in box_shapes:
		box.disabled = value
		box.visible = not value
