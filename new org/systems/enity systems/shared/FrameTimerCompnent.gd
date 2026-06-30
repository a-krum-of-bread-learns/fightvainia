## a timer used for frame by frame stuff insted of time in seconds
class_name FrameTimer extends Node
## the frames remaing when this is runing 
var running: bool
var frames_left: int = 0


## begins the timer with an error check
func start_frame_timer(wait_frames: int):
	if wait_frames <= 0:
		push_error("FrameTimer: wait_frames must be positive, got " + str(wait_frames))
		return
	frames_left = wait_frames
	running = true
	
## similar to a regular timer tells us if the timer has stoped
func is_stoped() -> bool:
	if frames_left == 0: return true
	return false

func reset():
		frames_left = 0
		running = false
##process is process (6) 
##counts doen timer 
func _process(_delta):
	#timer ccount down
	if frames_left > 0: 
		frames_left -= 1 
		if frames_left == 0: running = false
	elif frames_left < 0 and running: 
		running = false
		push_error("timer overdecresed")
		frames_left = 0
	
