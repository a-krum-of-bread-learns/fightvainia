## holds stun information and moves the entity as well 
class_name StunManager extends BehaviourBase
enum STUN_TYPE {BASIC, DEFUALT_KNOCK_DOWN, DEFUALT_LAUNCH, DEFUALT_AIR, BLOCK = 40} ## type of stun
@export var player_animation_tool: AnimationTool
@export var sprite: Sprite2D
# const if it never changes at runtime
var remaining_duration: int ## frames remaining
var speed: Vector2 ## the speed per frame
var is_stuned: bool = false
var current_type: int ## type need to be tracked
const DEFUALT_AIR_STUN: Vector2 = Vector2(100,-400)
const DEFUALT_KNOCKDOWN_STUN: Vector2 = Vector2(0,200)
const DEFUALT_LAUNCH_STUN: Vector2 = Vector2(50,-400) 
const PUSH_BACK_TIME_IN_FRAMES: int = 5

#TODO use the new animation tool for the stun manager if it makes sensef other wize keep as is
#TODO make a way to have the huratble player stop when on ground so it stops sliding 
#TODO have an option for aninmation type stun
#TODO make the viusals for stuns of type like fire and electricty or ice here
# FIXME error for hit type overides blocking = grab?

func get_time()-> float:
	return PUSH_BACK_TIME_IN_FRAMES/60.0
	
## time in frames shall be set to a fixed value but may be chaned for custim values 
func get_velocty(displacement: Vector2,stun_dir: Vector2) -> Vector2:
	return Vector2(displacement*stun_dir)/(get_time())
##the twwens in this fucntion are related to push back
func start_stun_with_tween(attack_data: HitBoxData, default_dir: Vector2, blocked: bool):
	HitStop.hit_stop_start(attack_data.hit_stop_frames)
	is_stuned = true
	#stun direction form attack data 
	var stun_dir: Vector2 = (default_dir*1 if attack_data.stun_away == true else default_dir*-1)

	#TODO decide if i want air block
	#decides what the stun type is
	if blocked: current_type = STUN_TYPE.BLOCK
	#defualt air stun
	elif host.is_on_floor() == false and attack_data.air_stun_overide == false:
		current_type = STUN_TYPE.DEFUALT_AIR
	#the attacks stun
	else: current_type = attack_data.stun_type


	# start sthe stun animation by moving the player
	if host.tween:
		host.tween.kill() # Abort the previous animation.
	host.tween = create_tween()
	
	match current_type:
		STUN_TYPE.BLOCK: # block based on attack data
			var velocity = get_velocty(Vector2(attack_data.block_back_distance,0),stun_dir)
			host.tween.tween_property(host,"velocity",Vector2(attack_data.block_back_distance*stun_dir.x,0),0)# reset line 
			host.tween.tween_property(host,"velocity",velocity,get_time()).from(velocity) # actual interpoation 
			host.tween.tween_property(host,"velocity",Vector2(0,0),0)
			remaining_duration = attack_data.block_stun_duration
	#basic
		STUN_TYPE.BASIC: # custom stun based on attack data
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



## contiues stun for the duration proied or other condtion based on type
func continue_stun():
	match current_type:
		STUN_TYPE.DEFUALT_KNOCK_DOWN: 
			if host.is_on_floor() and remaining_duration >= 0:
				remaining_duration -= 1
				host.velocity = DEFUALT_KNOCKDOWN_STUN
				
			else: end_stun()
			
		STUN_TYPE.DEFUALT_AIR, STUN_TYPE.DEFUALT_LAUNCH:
			if remaining_duration > 0:
				print("stun is air type")
				remaining_duration -= 1
			elif host.is_on_floor(): 
				current_type = STUN_TYPE.DEFUALT_KNOCK_DOWN
				host.velocity = Vector2.ZERO
				remaining_duration = 45
				if remaining_duration <=0:
					end_stun()

		STUN_TYPE.BASIC, STUN_TYPE.BLOCK:
			remaining_duration -= 1
			if remaining_duration <= 0:
				end_stun()

				
			


## ends the stun and clears info here
func end_stun():
	is_stuned = false
	remaining_duration = 0


func set_stun_color():
	if is_stuned and current_type == STUN_TYPE.BLOCK:
		sprite.modulate.b = 0
	elif is_stuned and current_type != STUN_TYPE.BLOCK:
		sprite.modulate.b = 0
		sprite.modulate.g = 0
	else:
		sprite.modulate.b = 1
		sprite.modulate.g = 1
		sprite.modulate.r = 1
		
		
func _process(_delta):
	if is_stuned: 
		continue_stun()
	set_stun_color()
	
	
	
	
	
	
	
	
