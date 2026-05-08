class_name Dash extends BehaviourBase
@export var timer: FrameTimer ## the timer for duration
@export var max_duration_frames: int = 20
@export var dash_speed: int = 2400
var current_speed: Vector2
var is_dashing: bool = false
#seting the reday name
func _ready():
	self.name = "dash"
	super._ready()



## sets the speed of the player 
func dash(dir:Vector2): 
	if !enabled:
		return
	if  is_dashing == false: 
		timer.start_frame_timer(max_duration_frames)
		is_dashing = true
		current_speed = dash_speed*dir
		host.velocity = current_speed
	elif is_dashing and timer.is_stoped():
		is_dashing = false
	elif is_dashing:
		host.velocity = current_speed


func _process(_delta):
	if is_dashing: dash(current_speed)
	
	
