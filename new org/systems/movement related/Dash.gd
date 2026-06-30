class_name Dash extends BehaviourBase
@export var timer: FrameTimer ## the timer for duration
#TODO change can_air_action_dash to a count value so it can be use for multiple air dashes and such
@onready var remaining_air_dashes: int = (host.stats as PlayerStats).max_air_dash_count ## tracks if the player can dach again in air
var current_speed: Vector2
#seting the reday name
func _ready():
	self.name = "dash"
	super._ready()
	host.contol_node.dash_signal.connect(start_dash)


func start_dash(dir: Vector2):
	#some set up 
	host.is_falling = false if host.is_dashing else true
	if (host.is_dashing == false):
		if host.is_on_floor():
			print("ground dash")
			continue_dash(dir)
			host.is_dashing = true
		elif remaining_air_dashes > 0:
			continue_dash(dir)
			host.is_dashing = true
			remaining_air_dashes -=1

## sets the speed of the player 
func continue_dash(dir: Vector2): 
	if !enabled:
		return
	if host.is_dashing == false: 
		timer.start_frame_timer((host.stats as PlayerStats).max_dash_duration_frames)
		host.is_dashing = true
		current_speed = (host.stats as PlayerStats).dash_speed*dir
		host.velocity = current_speed
	elif host.is_dashing and timer.is_stoped():
		host.is_dashing = false
		host.is_falling = true
	elif host.is_dashing:
		host.velocity = current_speed


func _process(_delta):
	if host.is_stuned:
		host.is_dashing = false
		timer.reset()
		return
	if host.is_attacking == false:
		if host.is_on_floor(): remaining_air_dashes = (host.stats as PlayerStats).max_air_dash_count
		if host.is_dashing: 
			continue_dash(current_speed)

		
	
	
	
