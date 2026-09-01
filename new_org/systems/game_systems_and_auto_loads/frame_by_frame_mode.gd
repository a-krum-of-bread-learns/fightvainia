## Autoload for a debug frame-by-frame mode. Toggled with the "frame by frame mode" input,
## which pauses the game. While paused, "frame forward" advances exactly one physics
## frame, then re-pauses — used to step through gameplay frame by frame for testing.
extends Node
var frame_by_frame_mode_endabled = false
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _physics_process(_delta: float) -> void:
	if frame_by_frame_mode_endabled:
		get_tree().paused = true
	if Input.is_action_just_pressed("frame by frame mode"): 
		get_tree().paused = !get_tree().paused
		frame_by_frame_mode_endabled = not frame_by_frame_mode_endabled
	
	if frame_by_frame_mode_endabled:
		get_tree().paused = true
	else:
		return

	if Input.is_action_just_pressed("frame forward"):
		if get_tree().paused:
			get_tree().paused = false   
			await get_tree().physics_frame# this must be the same process type
			get_tree().paused = true
