## holds stun information and moves the entity as well 
class_name StunManager extends BehaviourBase
enum STUN_TYPE {BASIC, DEFUALT_KNOCK_DOWN, DEFUALT_LAUNCH, DEFUALT_AIR, BLOCK = 40} ## type of stun
var remaining_duration: int ## frames remaining
var speed: Vector2 ## the speed per frame
var is_stuned: bool = false
var current_type: int ## type need to be tracked


#TODO make a way to have the huratble player stop when on ground so it stops sliding 
#TODO have an option for aninmation type stun
# FIXME error for hit type overides blocking = grab?

func get_time(time_in_frames: int)-> float:
	return time_in_frames/60.0
	
func get_velocty(displacement: Vector2,stun_dir: Vector2, time_in_frames: int) -> Vector2:
	return Vector2(displacement*stun_dir)/(get_time(time_in_frames))

func start_stun_with_tween(attack_data: HitBoxData, default_dir: Vector2, blocked: bool):
	HitStop.hit_stop_start(attack_data.hit_stop_frames)
	is_stuned = true
	#stun direction form attack data 
	var stun_dir: Vector2 = default_dir*int(attack_data.stun_away)

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
	host.tween.finished.connect(end_stun)
	match current_type:
		STUN_TYPE.BLOCK: # block based on attack data
			host.tween.tween_property(host,"velocity",Vector2(attack_data.block_back_distance*stun_dir.x,0),0)
			host.tween.tween_property(host,"velocity",
			get_velocty(Vector2(attack_data.block_back_distance,0),stun_dir,attack_data.block_stun_duration),
			get_time(attack_data.block_stun_duration))
			host.tween.tween_property(host,"velocity",Vector2(0,0),0)
	#basic
		STUN_TYPE.BASIC: # custom stun based on attack data
			host.tween.tween_property(host,"velocity",attack_data.hit_back_distance_vector*stun_dir,0)
			host.tween.tween_property(host,"velocity",
			get_velocty(attack_data.hit_back_distance_vector,stun_dir,attack_data.hit_stun_duration),
			get_time(attack_data.hit_stun_duration))
			host.tween.tween_property(host,"velocity",Vector2(0,0),0)
			
		STUN_TYPE.DEFUALT_LAUNCH:
			host.tween.tween_property(host,"velocity",Vector2(stun_dir.x*100,-300),0)
			host.tween.tween_property(host,"velocity",Vector2(stun_dir.x*100,-300),get_time(10))

		
		STUN_TYPE.DEFUALT_KNOCK_DOWN:
			host.tween.tween_property(host,"velocity",Vector2(0,200),0)
			host.tween.tween_property(host,"velocity",Vector2(0,200),get_time(99))
			
		STUN_TYPE.DEFUALT_AIR:
			host.velocity = Vector2(50*stun_dir.x,-300)
			remaining_duration = 30
			

## begins stun stuff and sets a few params based on [enum STUN_TYPE]
#func start_stun(attack_data: AttackData, default_dir: Vector2, blocked: bool):
	#if host.tween:
		#host.tween.kill()
	#HitStop.hit_stop_start(attack_data.hit_stop_frames)
	#var stun_dir: Vector2
	#if attack_data.stun_away:
		#stun_dir = default_dir
	#else:#this is for when you want to move them towads you 
		#stun_dir = default_dir*-1
	#is_stuned = true
	##TODO decide if i want air block
	#if blocked: current_type = STUN_TYPE.BLOCK
	#elif host.is_on_floor() == false and attack_data.air_stun_overide == false:
		#current_type = STUN_TYPE.BASIC_AIR
	#else: current_type = attack_data.stun_type
	#
	#
	#match current_type:
		#STUN_TYPE.BLOCK: 
			#remaining_duration = attack_data.block_stun_duration
			#speed = Vector2(stun_dir.x*attack_data.block_back_distance/(remaining_duration/60.0),0)
	##basic
		#STUN_TYPE.BASIC: 
			#remaining_duration = attack_data.hit_stun_duration
			#speed = stun_dir*attack_data.hit_back_distance_vector/(remaining_duration/60.0)
			#
		#STUN_TYPE.DEFUALT_KNOCK_DOWN: 
			#remaining_duration = 99
			#speed = Vector2(0,200)
			#
		#STUN_TYPE.DEFUALT_LAUNCH:
			#remaining_duration = 10
			#speed = Vector2(stun_dir.x*100,-300)
			#
		#STUN_TYPE.BASIC_AIR:
			#host.velocity = Vector2(50*stun_dir.x,-300)
			#remaining_duration = 30


## contiues stun for the duration proied or other condtion based on type
func continue_stun():
	match current_type:
		#STUN_TYPE.BLOCK, STUN_TYPE.BASIC: 
			#if not remaining_duration == 0:
				#remaining_duration-=1
				#host.velocity = speed
			#else: end_stun()
			## set state airborne
		STUN_TYPE.DEFUALT_KNOCK_DOWN: 
			if host.is_on_floor():
				current_type = STUN_TYPE.BASIC
				remaining_duration = 60
				speed = Vector2(0,0)
				
		#STUN_TYPE.DEFUALT_LAUNCH:
			#if not remaining_duration == 0:
				#remaining_duration-=1
				#host.velocity = speed
			#else: end_stun()
			#
		STUN_TYPE.DEFUALT_AIR:
			if not remaining_duration == 0:
				print("stun is air type")
				remaining_duration -= 1
			else: end_stun()

## ends the stun and clears info here
func end_stun():
	remaining_duration = 0
	speed = Vector2.ZERO
	is_stuned = false
	
## runs the frame countdown

func _process(_delta):
	if is_stuned: 
		continue_stun()
	
	

	
	
