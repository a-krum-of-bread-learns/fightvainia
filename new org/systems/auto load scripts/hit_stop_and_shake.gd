## Autoload handling hit stop (game freeze) and screen shake on hit.
##
## Call [method hit_stop_start] with a frame count to pause the game and shake the
## camera for that many frames. Emits [signal hit_stop_fin] once the freeze ends.
## Does not unpause if [FrameByFrameMode] is controlling the pause instead.

extends Node
var frames_left: int
var cam: Camera2D
var enabled: bool = false
signal hit_stop_fin

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if cam == null:
		push_warning("the screen shake is not enabled attach the script set cam.gd to your camera2D if you want to try it") 
	

func set_cam(camera: Camera2D):
	cam = camera

#TODO off= 0 low = 1 or less high is 10 mid is 5
func screen_shake():
		cam.offset = Vector2(randf(),randf())*1

func hit_stop_start(wait_frames: int) -> void:
	get_tree().paused = true
	frames_left = wait_frames

func _process(_delta):
	if frames_left > 0: 
		if cam:
			screen_shake()
		frames_left -= 1 
	elif frames_left == 0: 
		frames_left -= 1 
		hit_stop_fin.emit()
		if cam:
			cam.offset = Vector2.ZERO
		# only unpause if frame by frame mode is not controlling the pause
		if not FrameByFrameMode.frame_by_frame_mode_endabled:
			get_tree().paused = false
