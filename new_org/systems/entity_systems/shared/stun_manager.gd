
## Holds stun information and moves the entity while stunned.
##
## [member current_type] tracks which [enum STUN_TYPE] is active, set in
## [method start_stun_with_tween]. Each frame, [method continue_stun] computes
## [member next_type] (defaulting to no change) and applies it at the end of the call.
## DEFUALT_KNOCK_DOWN and DEFUALT_AIR/DEFUALT_LAUNCH both eventually transition into
## DEFUALT_ON_FLOOR then DEFUALT_WAKEUP before calling [method end_stun]. CUSTOM and
## BLOCK count down [member remaining_duration] directly with no state transition.[br]
class_name StunManager extends BehaviourBase

## these 3 are usbale for hitboxes and are expoeted on them
enum HIT_BOX_STUN_TYPE {CUSTOM = 0, DEFUALT_KNOCK_DOWN = 1, DEFUALT_LAUNCH = 4,}
##type of stun
enum STUN_TYPE {
	CUSTOM = 0, ##the most flexable option 
	DEFUALT_KNOCK_DOWN = 1, ##best for hiting some one straight down to the ground
	DEFUALT_LAUNCH = 4, ## for launching someone into the air 
	DEFUALT_ON_FLOOR = 2, ## otg state meaing they are hit-able on the floor and have not yet entered inot an invunrable state
	DEFUALT_WAKEUP = 3, ## cant be hit and cant act when waking up may be cahnged for wake up options
	DEFUALT_AIR = 5, ## if any attack with air stun overide off this will take prioty over that attack's set option
	BLOCK = 40 ## block stun 
	}
@export var player_animation_tool: AnimationTool # for later whne grabs are made
var remaining_duration: int ## frames remaining
var speed: Vector2 ## the speed per frame
var current_type: int ## type need to be tracked
var next_type: int
const DEFUALT_AIR_STUN: Vector2 = Vector2(100,-400) ## values for the coresponding stun 
const DEFUALT_KNOCKDOWN_STUN: Vector2 = Vector2(0,200)## values for the coresponding stun 
const DEFUALT_LAUNCH_STUN: Vector2 = Vector2(50,-400) ## values for the coresponding stun 
const PUSH_BACK_TIME_IN_FRAMES: int = 5 ## the time in witch push back is fully done should be small value 
const ON_FLOOR_TIME: int = 45
const WAKE_UP_TIME: int = 45
signal stun_has_started(_stun_type)
signal stun_has_ended
#TODO use the new animation tool for the stun manager if it makes sensef other wize keep as is
#TODO have an option for aninmation type stun
#TODO make the viusals for stuns of type like fire and electricty or ice here
# FIXME error for hit type overides blocking = grab?
func _ready():
	HelperFuncs.check_if_null(host,"host",self)
	
func get_time()-> float:
	return PUSH_BACK_TIME_IN_FRAMES/60.0
	
## time in frames shall be set to a fixed value but may be chaned for custim values 
func get_velocty(displacement: Vector2,stun_dir: Vector2) -> Vector2:
	return Vector2(displacement*stun_dir)/(get_time())
	
##the twwens in this fucntion are related to push back
func start_stun_with_tween(attack_data: HitBoxData, default_dir: Vector2, blocked: bool):
	#TODO difrent hit stop for on block and on hit same with screen shake maybe per attack?
	HitStopAndShake.hit_stop_start(attack_data.hit_stop_frames)
	host.is_stuned = true
	#stun direction form attack data 
	var stun_dir: Vector2 = (default_dir*1 if attack_data.stun_away == true else default_dir*-1)
	#TODO decide if i want air block
	if blocked: next_type = STUN_TYPE.BLOCK
	elif host.is_on_floor() == false and attack_data.air_stun_overide == false:
		next_type = STUN_TYPE.DEFUALT_AIR
	else: next_type = attack_data.stun_type

	current_type = next_type

	# start sthe stun animation by moving the player
	if current_type in [STUN_TYPE.BLOCK, STUN_TYPE.CUSTOM, STUN_TYPE.DEFUALT_KNOCK_DOWN]:
		if host.tween:
			host.tween.kill()
		host.tween = create_tween()
	
	match current_type:
		
		STUN_TYPE.BLOCK: # block based on attack data
			var velocity = get_velocty(Vector2(attack_data.block_back_distance,0),stun_dir)
			host.tween.tween_property(host,"velocity",Vector2(attack_data.block_back_distance*stun_dir.x,0),0)# reset line 
			host.tween.tween_property(host,"velocity",velocity,get_time()).from(velocity) # actual interpoation 
			host.tween.tween_property(host,"velocity",Vector2(0,0),0)
			remaining_duration = attack_data.block_stun_duration
	#basic
		STUN_TYPE.CUSTOM: # custom stun based on attack data
			var velocity = get_velocty(attack_data.hit_back_distance_vector,stun_dir)
			host.tween.tween_property(host,"velocity",attack_data.hit_back_distance_vector*stun_dir,0)
			host.tween.tween_property(host,"velocity",velocity,get_time()).from(velocity)
			host.tween.tween_property(host,"velocity",Vector2(0,0),0)
			remaining_duration = attack_data.hit_stun_duration

		STUN_TYPE.DEFUALT_KNOCK_DOWN:
			host.tween.tween_property(host,"velocity",DEFUALT_KNOCKDOWN_STUN,get_time())
			
		STUN_TYPE.DEFUALT_AIR:
			host.velocity = Vector2(DEFUALT_AIR_STUN.x*stun_dir.x,DEFUALT_AIR_STUN.y)
			remaining_duration = 5
		
		STUN_TYPE.DEFUALT_LAUNCH:
			host.velocity = Vector2(DEFUALT_LAUNCH_STUN.x*stun_dir.x,DEFUALT_LAUNCH_STUN.y)
			remaining_duration = 5
	stun_has_started.emit(current_type)



## contiues stun for the duration proied or other condtion based on type
func continue_stun():
	next_type = current_type
	match current_type:
		STUN_TYPE.DEFUALT_KNOCK_DOWN: 
			if host.is_on_floor() and remaining_duration >= 0:
				next_type = STUN_TYPE.DEFUALT_ON_FLOOR
				
		STUN_TYPE.DEFUALT_ON_FLOOR:
			host.velocity = Vector2.ZERO
			remaining_duration -= 1
			if remaining_duration == 0:
				next_type = STUN_TYPE.DEFUALT_WAKEUP
			
		STUN_TYPE.DEFUALT_WAKEUP: 
			host.velocity = Vector2.ZERO
			remaining_duration -= 1
			host.primary_boxes_and_sprites.disable_all_pimary_boxes_exluding()
			if remaining_duration <= 0:
				end_stun()
				
		STUN_TYPE.DEFUALT_AIR, STUN_TYPE.DEFUALT_LAUNCH:
			if remaining_duration > 0:
				print("stun is air type")
				remaining_duration -= 1
			elif host.is_on_floor(): 
				next_type = STUN_TYPE.DEFUALT_KNOCK_DOWN
				host.velocity = Vector2.ZERO

		STUN_TYPE.CUSTOM, STUN_TYPE.BLOCK:
			remaining_duration -= 1
			if remaining_duration <= 0:
				end_stun()
				
	if next_type != current_type:
		current_type = next_type
		match current_type:
			STUN_TYPE.DEFUALT_ON_FLOOR: remaining_duration = ON_FLOOR_TIME
			STUN_TYPE.DEFUALT_WAKEUP: remaining_duration = WAKE_UP_TIME
			STUN_TYPE.DEFUALT_KNOCK_DOWN: remaining_duration = 45


## ends the stun and clears info here only use when you want the entity to leave hit stun other wise set the next stun type 
func end_stun():
	stun_has_ended.emit()
	host.is_stuned = false
	remaining_duration = 0

		
		
func _process(_delta):
	if host.is_stuned: 
		continue_stun()
