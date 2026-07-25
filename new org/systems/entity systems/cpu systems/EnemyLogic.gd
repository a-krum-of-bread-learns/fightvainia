## this node contols ennemy behaviour using chances. all settings are stored in the see [BossSettings]
class_name EnemyLogic extends BehaviourBase

@export_group("components")
@export var rays: Array[RayCast2D]
@export var ledge_ray: RayCast2D
@export var settings: EnemySettings

@export_group("timer")
@export var timer: FrameTimer
@export var humanize_time_in_frames: int = 0
@export var pause_time_in_frames: int = 0

@export_group("combos")
@export var close_bnb_combo: Array[Attack]
@export var close_bnb_low_combo: Array[Attack]
@export var close_pokes: Array[Attack]
@export var mid_pokes: Array[Attack]
@export var far_or_projectile_pokes: Array[Attack]
@export var anti_airs: Array[Attack]
#REFACTOR make a single source of truth for the states
enum PREFERRED_DISTANCE {CLOSE = 1, MID, FAR}
enum STATE {IDLE_WALK = -10, IDLE_PAUSE, CLOSE = 1, MID, FAR, VERY_FAR, BLOCK = 40}
var current_combo: Array[Attack]
var current_attack_index: int = 0
var target: EntityBase
var current_state: STATE = STATE.IDLE_PAUSE
var next_state: STATE = STATE.IDLE_PAUSE
var target_attack_manager: AttackManager
var target_current_attack: Attack


#TODO add jump change and jump attacks for some of this stuff
#TODO add functionality to check fastest attack
#TODO add functionality to check attack with special properties like armor and what frames
#FIXME end combo early when blocked to make it feel not super stupid
# --- setup ---

func _ready():
	self.name = "EnemyLogic"
	super._ready()
	
	var has_error: bool = false
	has_error = HelperFuncs.check_if_null(host, "host", self)
	if not has_error:
		has_error = HelperFuncs.check_if_null(host.primary_boxes_and_sprites, "primary_boxes_and_sprites", self) or has_error
		if not has_error:
			has_error = HelperFuncs.check_if_null(host.primary_boxes_and_sprites.standing_hurt_box_area, "standing_hurt_box_area", self) or has_error
			has_error = HelperFuncs.check_if_null(host.primary_boxes_and_sprites.crouching_hurt_box_area, "crouching_hurt_box_area", self) or has_error
			has_error = HelperFuncs.check_if_null(host.primary_boxes_and_sprites.airborne_hurt_box_area, "airborne_hurt_box_area", self) or has_error
	if has_error:
		return
		
	for ray: RayCast2D in rays:
		ray.collide_with_areas = true
		ray.collision_mask = 2
		ray.hit_from_inside = true
		ray.collide_with_bodies = false
		ray.add_exception(host.primary_boxes_and_sprites.standing_hurt_box_area)
		ray.add_exception(host.primary_boxes_and_sprites.crouching_hurt_box_area)
		ray.add_exception(host.primary_boxes_and_sprites.airborne_hurt_box_area)
		for child in host.attack_manager.get_children():
			if child is Attack:
				for frame: Frame in child.frames:
					var box = frame.get_hurtboxarea()
					if box: ray.add_exception(box)
					box = frame.get_hitboxarea()
					if box: ray.add_exception(box)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is EntityBase:
		target = body
		host.is_facing_right = target.global_position.x > host.global_position.x
		host.scale_component.set_scale(Scale.RIGHT if host.is_facing_right else Scale.LEFT)
		next_state = get_range_state()
		

func update_references() -> void:
	if target == null:
		return
	target_attack_manager = target.attack_manager
	target_current_attack = target_attack_manager.current_attack

# --- idle patrol ---

func start_wait_state():
	next_state = STATE.IDLE_WALK
	timer.start_frame_timer(settings.idle_pause_time)
	host.velocity.x = 0

func start_walk_state():
	host.is_facing_right = !host.is_facing_right
	next_state = STATE.IDLE_PAUSE
	timer.start_frame_timer(settings.idle_walk_time)
	host.velocity.x = settings.walk_speed if host.is_facing_right else -settings.walk_speed
	host.scale_component.set_scale(Scale.RIGHT if host.is_facing_right else Scale.LEFT)

# --- range and approach ---

func get_range_state() -> STATE:
	var delta: float = abs(host.global_position.x - target.global_position.x)
	var tolerance: float = 0.0 if HelperFuncs.roll_chance(settings.ignore_tolrance_chance) else settings.spacing_tolerance
	if delta <= settings.close_range_max_x + tolerance: return STATE.CLOSE
	elif delta <= settings.mid_range_max_x + tolerance: return STATE.MID
	elif delta <= settings.far_range_max_x + tolerance: return STATE.FAR
	elif delta <= settings.out_of_range_x + tolerance: return STATE.VERY_FAR
	else: 
		target = null
		return STATE.IDLE_PAUSE

func get_approach_velocity() -> float:
	if current_state == STATE.VERY_FAR:
		return settings.run_speed * HelperFuncs.facing_sign(host.is_facing_right)
	elif current_state <= settings.preferred_distance:
		return settings.walk_speed * -HelperFuncs.facing_sign(host.is_facing_right)
	else:
		return settings.walk_speed * HelperFuncs.facing_sign(host.is_facing_right)

func approch_behaviour() -> void:
	host.is_facing_right = target.global_position.x > host.global_position.x 
	if host.is_stuned or host.is_attacking:
		if host.is_crouching or host.is_on_floor():
			host.velocity.x = 0
		return
	if not timer.is_stoped():
		return
	timer.start_frame_timer(humanize_time_in_frames)
	host.scale_component.set_scale(Scale.RIGHT if host.is_facing_right else Scale.LEFT)
	if HelperFuncs.roll_chance(settings.pause_chance):
		timer.start_frame_timer(pause_time_in_frames)
		host.is_crouching = true
		host.velocity.x = 0
		return
	host.is_crouching = false
	host.velocity.x = get_approach_velocity()

func check_next_for_hitboxarea() -> bool:
	for ray in rays:
		if ray.is_colliding() and ray.get_collider() is ProjectileArea:
			return true
	return target_attack_manager.get_next_hitboxarea() != null

# --- state management ---

func manage_state() -> void:
	if host.is_attacking and host.is_stuned == false:
		if current_combo:
			start_and_continue_combo(current_combo)
		return

	if target == null:
		match next_state:
			STATE.IDLE_WALK when timer.is_stoped() :
				start_walk_state()
			STATE.IDLE_PAUSE when timer.is_stoped() or ledge_ray.is_colliding() == false:
				start_wait_state()
		return

	next_state = get_range_state()
	if check_next_for_hitboxarea():
		next_state = STATE.BLOCK

	match current_state:
		STATE.CLOSE when HelperFuncs.roll_chance(settings.attack_chance):
			if host.is_crouching and not close_bnb_low_combo.is_empty():
				start_and_continue_combo(close_bnb_low_combo)
			elif not close_bnb_combo.is_empty():
				start_and_continue_combo(close_bnb_combo)
		STATE.CLOSE when HelperFuncs.roll_chance(settings.anti_air_chance):
			anti_air_logic()
		STATE.MID when HelperFuncs.roll_chance(settings.poke_chance):
			if not mid_pokes.is_empty():
				host.attack_manager.start_attack(mid_pokes[randi() % mid_pokes.size()])
		STATE.FAR when HelperFuncs.roll_chance(settings.poke_chance):
			if not far_or_projectile_pokes.is_empty():
				host.attack_manager.start_attack(far_or_projectile_pokes[randi() % far_or_projectile_pokes.size()])
		STATE.BLOCK:
			self_block_logic()

# --- combat ---

func self_block_logic() -> void:
	if host.is_attacking:
		host.is_blocking = false
		return
	if host.is_stuned and host.stun_manager.current_type == host.stun_manager.STUN_TYPE.BLOCK:
		host.is_blocking = true
	elif host.is_stuned:
		host.is_blocking = false
	elif (HelperFuncs.roll_chance(settings.block_chance)
		or HelperFuncs.roll_chance(settings.block_chance) and check_next_for_hitboxarea()):
		host.is_blocking = true
	else:
		host.is_blocking = false
	if HelperFuncs.roll_chance(settings.corect_block_type_chance):
		var hitbox: HitBoxArea = target_attack_manager.get_current_hitboxarea()
		if hitbox:
			host.block_type = hitbox.attack_data.hit_type
			if hitbox.attack_data.hit_type == HitBoxData.HIT_TYPE.LOW:
				host.is_crouching = true
			elif hitbox.attack_data.hit_type == HitBoxData.HIT_TYPE.OVER:
				host.is_crouching = false

func start_and_continue_combo(combo_attacks: Array[Attack]) -> void:
	if combo_attacks.is_empty():
		return
	if HelperFuncs.roll_chance(settings.calc_drop_chance()):
		current_attack_index = 0
		current_combo = []
		return
	if host.is_attacking == false:
		current_combo = combo_attacks
		current_attack_index = 0
		host.attack_manager.start_attack(combo_attacks[current_attack_index])
	else:
		if current_attack_index >= combo_attacks.size():
			current_attack_index = 0
			return
		if (combo_attacks[current_attack_index].has_hit
		and (combo_attacks[current_attack_index].can_combo
			or combo_attacks[current_attack_index].can_speical_cancel
			or host.attack_manager.get_frames_remaining() == 1)):
			current_attack_index += 1
			if combo_attacks.size() == current_attack_index:
				current_attack_index = 0
				return
			host.attack_manager.start_attack(combo_attacks[current_attack_index])

func anti_air_logic() -> void:
	if anti_airs.is_empty():
		return
	if (current_state == STATE.CLOSE
	and not target.is_on_floor()
	and not host.is_attacking):
		var vertical_delta: float = target.global_position.y - host.global_position.y
		if (vertical_delta <= settings.anti_air_delta_min_y
		and vertical_delta >= settings.anti_air_delta_max_y
		and target.velocity.y > 0):
			host.attack_manager.start_attack(anti_airs[randi() % anti_airs.size()])

# --- physics ---

func _physics_process(_delta: float) -> void:
	#print("current "+str(current_state))
	#print("next "+str(next_state))
	if settings.self_enabled == false:
		return
	update_references()
	manage_state()
	if target == null:
		return
	approch_behaviour()
	host.primary_hurt_box_manager()
	
	current_state = next_state
