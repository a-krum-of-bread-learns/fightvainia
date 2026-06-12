class_name BossLogic extends EnemyBase
enum STATE {IDLE =0,CLOSE =1, MID, FAR, VERY_FAR, BLOCK = 40}

@export var settings: BossSettings
@export_group("combos")
@export var close_bnb_combo: Array[Attack]
@export var close_bnb_low_combo: Array[Attack]
@export var close_pokes: Array[Attack]
@export var mid_pokes: Array[Attack]
@export var far_or_projectile_pokes: Array[Attack]
@export var anti_airs: Array[Attack]
var current_combo: Array[Attack]

@export_group("timer")
@export var timer: FrameTimer
@export var humanize_time: int = 0
@export var pause_time: int = 0

var target: Player
var current_state: STATE = STATE.IDLE
var next_state: STATE = STATE.IDLE
var target_attack_manager: AttackManager
var target_current_attack: Attack
var crouching: bool

#TODO add functionality to check fastest attack
#TODO add functionality to check attack with speical propetys like armor and what frames 

func _ready() -> void:
	for ray in rays:
		ray.collide_with_areas = true
		ray.collision_mask = 2
		ray.hit_from_inside = true
		ray.collide_with_bodies = false
		ray.add_exception(primary_hurt_boxes_component.standing_hurt_box_area)
		ray.add_exception(primary_hurt_boxes_component.crouching_hurt_box_area)
		ray.add_exception(primary_hurt_boxes_component.airborne_hurt_box_area)
		for child in attack_manager.get_children():
			if child is Attack:
				for frame: Frame in child.frames:
					var box = frame.get_hurtboxarea()
					if box: ray.add_exception(box)
					box = frame.get_hitboxarea()
					if box: ray.add_exception(box)

func update_references() -> void:
	if target == null:
		return
	target_attack_manager = target.input_component.attack_manager
	target_current_attack = target_attack_manager.current_attack

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body

func check_next_for_hitboxarea() -> bool:
	for ray in rays:
		if ray.is_colliding() and ray.get_collider() is ProjectileArea:
			return true
	return target_attack_manager.get_next_hitboxarea() != null

func approch_behaviour() -> void:
	is_facing_right = (target.global_position.x - self.global_position.x) > 0
	if stun_manager.is_stuned or attack_manager.is_attacking:
		if is_on_floor() or crouching:
			velocity.x = 0
		return
	if timer.is_stoped():
		timer.start_frame_timer(humanize_time)
		scale_component.set_scale(Scale.RIGHT if is_facing_right else Scale.LEFT)
		velocity.x  = settings.walk_speed * HelperFuncs.facing_sign(is_facing_right)
		if current_state == STATE.VERY_FAR:
			velocity.x  = settings.run_speed * HelperFuncs.facing_sign(is_facing_right)
			crouching = false
		elif HelperFuncs.roll_chance(settings.pause_chance):
			timer.start_frame_timer(pause_time)
			crouching = true
			velocity.x  = 0
			return
		elif current_state == STATE.CLOSE:
			velocity.x  = settings.walk_speed * -HelperFuncs.facing_sign(is_facing_right)
			crouching = false
		else: crouching = false
			

func get_range_state() -> STATE:
	var delta: float = abs(self.global_position.x - target.global_position.x)
	if HelperFuncs.roll_chance(settings.ignore_tolrance_chance):
		if delta <= settings.close_range_max_x:
			return STATE.CLOSE
		elif delta <= settings.mid_range_max_x:
			return STATE.MID
		elif delta <= settings.far_range_max_x:
			return STATE.FAR
		else:
			return STATE.VERY_FAR
	if delta <= settings.close_range_max_x + settings.spacing_tolerance:
		return STATE.CLOSE
	elif delta <= settings.mid_range_max_x + settings.spacing_tolerance:
		return STATE.MID
	elif delta <= settings.far_range_max_x + settings.spacing_tolerance:
		return STATE.FAR
	else:
		return STATE.VERY_FAR

func manage_state() -> void:
	if self.attack_manager.is_attacking and stun_manager.is_stuned == false:
		if current_combo:
			start_and_continue_combo(current_combo)
		return
	next_state = get_range_state()
	if check_next_for_hitboxarea():
		next_state = STATE.BLOCK
	match current_state:
		STATE.CLOSE when HelperFuncs.roll_chance(settings.attack_chance):
			if crouching: start_and_continue_combo(close_bnb_low_combo) 
			else: start_and_continue_combo(close_bnb_combo)
		STATE.CLOSE when HelperFuncs.roll_chance(settings.anti_air_chance):
			anti_air_logic()
		STATE.MID when HelperFuncs.roll_chance(settings.poke_chance):
			attack_manager.start_attack(mid_pokes[randi() % mid_pokes.size()])
		STATE.FAR: pass # walk towards
		STATE.BLOCK: self_block_logic()

func primary_hurt_box_manager() -> void:
	if is_on_floor() and crouching:
		primary_hurt_boxes_component.disable_all_pimary_boxes_exluding(primary_hurt_boxes_component.crouching_hurt_box)
		primary_hurt_boxes_component.disable_all_pimary_sprites_excluding(primary_hurt_boxes_component.crouching_sprite)
	elif is_on_floor():
		primary_hurt_boxes_component.disable_all_pimary_boxes_exluding(primary_hurt_boxes_component.standing_hurt_box)
		primary_hurt_boxes_component.disable_all_pimary_sprites_excluding(primary_hurt_boxes_component.standing_sprite)
	elif not is_on_floor():
		primary_hurt_boxes_component.disable_all_pimary_boxes_exluding(primary_hurt_boxes_component.airborne_hurt_box)

func self_block_logic() -> void:
	if attack_manager.is_attacking:
		is_blocking = false
		return
	if stun_manager.is_stuned and stun_manager.current_type == stun_manager.STUN_TYPE.BLOCK:
		is_blocking = true
	elif stun_manager.is_stuned:
		is_blocking = false
	elif (HelperFuncs.roll_chance(settings.block_chance)
		or HelperFuncs.roll_chance(settings.block_chance) and check_next_for_hitboxarea()):
		is_blocking = true
	else:
		is_blocking = false
	if HelperFuncs.roll_chance(settings.corect_block_type_chance):
		var hitbox: HitBoxArea = target_attack_manager.get_current_hitboxarea()
		if hitbox:
			block_type = hitbox.attack_data.hit_type
			if hitbox.attack_data.hit_type == HitBoxData.HIT_TYPE.LOW:
				crouching = true
			elif hitbox.attack_data.hit_type == HitBoxData.HIT_TYPE.OVER: 
				crouching = false

func start_and_continue_combo(combo_attacks: Array[Attack]) -> void:
	if HelperFuncs.roll_chance(settings.calc_drop_chance()):
		current_attack_index = 0 
		current_combo = []
		return
	if attack_manager.is_attacking == false:
		current_combo = combo_attacks
		current_attack_index = 0
		attack_manager.start_attack(combo_attacks[current_attack_index])
	else:
		if (combo_attacks[current_attack_index].has_hit
		and (combo_attacks[current_attack_index].can_combo or combo_attacks[current_attack_index].can_speical_cancel)):
			current_attack_index += 1
			if combo_attacks.size() == current_attack_index:
				current_attack_index = 0
				return
			attack_manager.start_attack(combo_attacks[current_attack_index])

func anti_air_logic() -> void:
	if (current_state == STATE.CLOSE
	and not target.is_on_floor()
	and not attack_manager.is_attacking):
		var vertical_delta: float = target.global_position.y - self.global_position.y
		print(vertical_delta)
		if (vertical_delta <= settings.anti_air_delta_min_y
		and vertical_delta >= settings.anti_air_delta_max_y
		and target.velocity.y > 0):
			attack_manager.start_attack(anti_airs[randi() % anti_airs.size()])

func _physics_process(_delta: float) -> void:
	move_and_slide()
	if timer.is_stoped():
		print("timer expired, is_attacking: " + str(attack_manager.is_attacking))
	print("boss state " + str(current_state))
	print("boss next state " + str(next_state))
	print("cpu velocity: " + str(velocity))
	if settings.self_enabled == false:
		return
	if target == null:
		current_state = STATE.IDLE
		next_state = STATE.IDLE
		return
	update_references()
	approch_behaviour()
	manage_state()
	primary_hurt_box_manager()
	current_state = next_state
	
