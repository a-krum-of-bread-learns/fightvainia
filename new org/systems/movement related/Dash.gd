class_name Dash extends BehaviourBase
@export var timer: FrameTimer ## the timer for duration
@export var input_manager: InputManager
@export var gravity_component: Gravity
var can_air_action_dash: bool = false  ## tracks if the player can dach again in air
var current_speed: Vector2
var is_dashing: bool = false
#seting the reday name
func _ready():
	self.name = "dash"
	super._ready()

func dash_handler2():
	#some set up 
	if is_dashing:
		gravity_component.is_falling = false
	else: gravity_component.is_falling = true
	if host.is_on_floor(): can_air_action_dash = true
	
	if (input_manager.buffer_check(input_manager.input_history, MoveList.DASHR,MoveList.R)
		and is_dashing == false):
		if host.is_on_floor():
			print("ground dash")
			dash(Vector2.RIGHT)
			is_dashing = true
		elif can_air_action_dash:
			dash(Vector2.RIGHT)
			is_dashing = true
			can_air_action_dash = false

	elif (input_manager.buffer_check(input_manager.input_history, MoveList.DASHL,MoveList.L)
		and is_dashing == false):
		if host.is_on_floor():
			print("ground dash")
			dash(Vector2.LEFT)
			is_dashing = true
		elif can_air_action_dash:
			dash(Vector2.LEFT )
			is_dashing = true
			can_air_action_dash = false

## sets the speed of the player 
func dash(dir:Vector2): 
	if !enabled:
		return
	if  is_dashing == false: 
		timer.start_frame_timer(host.stats.max_dash_duration_frames)
		is_dashing = true
		current_speed = host.stats.dash_speed*dir
		host.velocity = current_speed
	elif is_dashing and timer.is_stoped():
		is_dashing = false
	elif is_dashing:
		host.velocity = current_speed


func _process(_delta):
	if host.stun_manager.is_stuned:
		is_dashing = false
		timer.reset()
		return
	if is_dashing: dash(current_speed)
	
	
