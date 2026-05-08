extends Node
var frame_by_frame_mode_endabled = false
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta: float) -> void:
	if frame_by_frame_mode_endabled:
		get_tree().paused = true
	if Input.is_action_just_pressed("frame by frame mode"):
		get_tree().paused = !get_tree().paused
		frame_by_frame_mode_endabled = not frame_by_frame_mode_endabled
	
	if Input.is_action_just_pressed("frame forward"):
		if get_tree().paused:
			get_tree().paused = false   
			await get_tree().process_frame# this must be the same process tiype
			get_tree().paused = true
