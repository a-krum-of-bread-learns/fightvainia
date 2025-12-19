extends Node
var frames_left: int
var cam: Camera2D


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func set_cam(camera: Camera2D):
	cam = camera

#TODO off= 0 low = 1 or less high is 10 nid is 5
func screen_shake():
	cam.offset = Vector2(randf(),randf())*1

func hit_stop_start(wait_frames: int) -> void:
	get_tree().paused = true
	frames_left = wait_frames

func _process(_delta):
	if frames_left > 0: 
		screen_shake()
		frames_left -= 1 
	elif frames_left == 0: 
		frames_left -= 1 
		get_tree().paused = false
		cam.offset =Vector2.ZERO
