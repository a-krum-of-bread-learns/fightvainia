## holds stun information and moves the entity as well 
class_name StunManager extends BehaviourBase
enum STUN_TYPE {BASIC, DEFUALT_KNOCK_DOWN, DEFUALT_LAUNCH, DEFUALT_AIR, BLOCK = 40} ## type of stun
@export var player_animation_tool: AnimationTool
@export var sprite: Sprite2D
var remaining_duration: int ## frames remaining
var speed: Vector2 ## the speed per frame
var is_stuned: bool = false
var current_type: int ## type need to be tracked
var defualt_air_stun: Vector2 =Vector2(400,-2400)
var defualt_knockdown_stun: Vector2 = Vector2(0,1600)
var defualt_launch_stun: Vector2 =Vector2(200,-2400) 

#TODO use the new animation tool for the stun manager if it makes sensef other wize keep as is
#TODO make a way to have the huratble player stop when on ground so it stops sliding 
#TODO have an option for aninmation type stun
#TODO make the viusals for stuns of type like fire and electricty or ice here
# FIXME error for hit type overides blocking = grab?

func get_time(time_in_frames: int)-> float:
	return time_in_frames/60.0
	
func get_velocty(displacement: Vector2,stun_dir: Vector2, time_in_frames: int) -> Vector2:
	return Vector2(displacement*stun_dir)/(get_time(time_in_frames))

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
	host.tween.finished.connect(end_stun)
	match current_type:
		STUN_TYPE.BLOCK: # block based on attack data
			host.tween.tween_property(host,"velocity",Vector2(attack_data.block_back_distance*stun_dir.x,0),0)# reset line 
			host.tween.tween_property(host,"velocity",
			get_velocty(Vector2(attack_data.block_back_distance,0),stun_dir,attack_data.block_stun_duration),
			get_time(attack_data.block_stun_duration)) # actual interpoation 
			host.tween.tween_property(host,"velocity",Vector2(0,0),0)
	#basic
		STUN_TYPE.BASIC: # custom stun based on attack data
			host.tween.tween_property(host,"velocity",attack_data.hit_back_distance_vector*stun_dir,0)
			host.tween.tween_property(host,"velocity",
			get_velocty(attack_data.hit_back_distance_vector,stun_dir,attack_data.hit_stun_duration),
			get_time(attack_data.hit_stun_duration))
			host.tween.tween_property(host,"velocity",Vector2(0,0),0)

		STUN_TYPE.DEFUALT_KNOCK_DOWN:
			host.tween.tween_property(host,"velocity",defualt_knockdown_stun,0)
			host.tween.tween_property(host,"velocity",defualt_knockdown_stun,get_time(99))
			
		STUN_TYPE.DEFUALT_AIR:
			host.velocity = Vector2(defualt_air_stun.x*stun_dir.x,defualt_air_stun.y)
			remaining_duration = 30
		
		STUN_TYPE.DEFUALT_LAUNCH:
			host.velocity = Vector2(defualt_launch_stun.x*stun_dir.x,defualt_launch_stun.y)
			remaining_duration = 45



## contiues stun for the duration proied or other condtion based on type
func continue_stun():
	match current_type:
		STUN_TYPE.DEFUALT_KNOCK_DOWN: 
			if host.is_on_floor() and remaining_duration >= 0:
				remaining_duration -= 1
				host.velocity = defualt_knockdown_stun
			else: end_stun()
			
		STUN_TYPE.DEFUALT_AIR, STUN_TYPE.DEFUALT_LAUNCH:
			if remaining_duration >= 0:
				print("stun is air type")
				remaining_duration -= 1
			elif host.is_on_floor(): 
				current_type = STUN_TYPE.DEFUALT_KNOCK_DOWN
				host.velocity = Vector2.ZERO
				remaining_duration = 45
			else: 
				end_stun()
			


## ends the stun and clears info here
func end_stun():
	is_stuned = false
	remaining_duration = 0


func set_stun_color():
	if is_stuned:
		sprite.modulate.b=0
	else:
		sprite.modulate.b=255

func _process(_delta):
	if is_stuned: 
		continue_stun()
	set_stun_color()
