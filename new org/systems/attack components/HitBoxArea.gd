## Extends [ActiveHitBox] with block check system
##
## Errors on [method _ready] if [member attack_data] or any required field is unassigned.[br]
## On [HurtBoxArea] overlap, [method damage] checks [member AttackManager.hit_expetions] to
## prevent hitting the same entity twice per attack, then resolves block/hit via
## [method block_check2] before applying damage and stun.[br]
## Emits [signal has_hit_signal] on a confirmed hit, re-emitted by [AttackManager] as
## [signal AttackManager.has_hit_signal_attack_manger].

@tool
class_name HitBoxArea extends ActiveHitBox
@export_category("buttions")
@export var add_hit_box_buttion: bool = false
@export var fix_color_buttion: bool = false
#TODO consider removing this refrence and doing it difrently?
@onready var attack_manager: AttackManager = get_parent().get_parent().get_parent()## easy refence of the attack manager
# TODO consider puting a signal here for the damage function to tell projectiles to stop when enity is hit sometimes
signal has_hit_signal(entity: EntityBase, is_blocked: bool)
## conects singals and is just to warn the hit box has no info and where 
#region game code
func _ready():
	HelperFuncs.check_if_null(attack_data,"attack_data", self)
	attack_data.validate_data(self)
	super._ready()
	self.collision_mask = attack_manager.host.hit_box_mask
	

## orginal damage is overwritten with better logic [br]
## esantaly the fucntion to deal damage if target is valid  blocking logic contained here

func damage(area):
	if area is HurtBoxArea:
		#this code is if their is no enity 
		if area.health == null or area.stun_manager == null:
			# grapple point / simple hurtbox with no entity behind it - just signal the hit
			has_hit_signal.emit(null, false)
			return
		var attacked_entity: EntityBase = area.health.host 
		#put here for renable if wanted
		print(attack_manager.hit_expetions)
		#prevents hiting self even if i hit somthing else
		if attack_manager.hit_expetions.is_empty():
			attack_manager.hit_expetions.append(attack_manager.host)
		# prevents self damage and hitting again
		if (get_parent().get_children().has(area) == false 
		and attack_manager.hit_expetions.has(attacked_entity) == false): 
			attack_manager.hit_expetions.append(attacked_entity)
			#stun and damage calls are inside
			var is_blocked: bool = block_check2(attacked_entity, area)
			has_hit_signal.emit(attacked_entity,is_blocked)
			
			
			
## true means blocked
func high_low_block_check(attacked_entity: EntityBase)-> bool: #TODO for projectile high low check try overwtitng and deciden between new logic and defult logic
	if attack_manager.host.is_on_floor() == false:
		#FIXME air peojectiles would be considered overhead witch may be bad 
		return attacked_entity.block_type == attack_data.HIT_TYPE.OVER
	if attacked_entity.block_type == attacked_entity.BLOCK_TYPE.ALL:
		return true
	elif attack_data.hit_type == attacked_entity.block_type:
		return true
	return attack_data.hit_type == attack_data.HIT_TYPE.MID
	

#TODO decide on air block
## true means blocked
func block_check2(attacked_entity: EntityBase, area: HurtBoxArea) -> bool:
	# self.global_position rather than get_parent() so projectiles are checked from
	# their own position, not the entity that fired them
	var attack_from_right: bool = self.global_position.x > attacked_entity.global_position.x
	var high_low_check: bool = high_low_block_check(attacked_entity)

	# bit 3: is_blocking | bit 2: high_low_check passed | bit 1: attacked is_facing_right | bit 0: attack_from_right
	# only indices 12 (1100) and 15 (1111) result in a successful block —
	# blocking, high/low correct, and facing matches attack direction
	var bit_index: int = (
		(int(attacked_entity.is_blocking) << 3)
		| (int(high_low_check) << 2)
		| (int(attacked_entity.is_facing_right) << 1)
		| int(attack_from_right)
	)
	var block_check_look_up: Array[bool] = [
		false, false, false, false, false, false, false, false, # not blocking
		false, false, false, false,                             # blocking but high/low fails
		true,  false, false, true                               # blocked corect now direction matters
	]
	var blocked: bool = block_check_look_up[bit_index]
	print("bit index for blocking: " + str(bit_index))

	var vector_direction: Vector2 = (
		Vector2.UP + Vector2.LEFT if attack_from_right
		else Vector2.UP + Vector2.RIGHT
	)

	if not blocked:
		if attacked_entity.combo_tracker == null or attacked_entity.combo_tracker.damage_allowed():
			area.health.reduce_health(attack_data.damage)

	area.stun_manager.start_stun_with_tween(attack_data, vector_direction, blocked)
	print(area.health.current_health)
	return blocked
#endregion game code

#region @tool code
## is used to fix color if i change the defualt later
func fix_color():
	for child in get_children():
		if child is CollisionShape2D:
			child.debug_color= Color8(255,0,0,175)
	fix_color_buttion = false


##adds a new hit_box colsion shape 2d
func add_new_hit_box(): 
	var hit_box: CollisionShape2D = CollisionShape2D.new()
	hit_box.shape = RectangleShape2D.new()
	add_child(hit_box) 
	hit_box.owner = get_tree().edited_scene_root
	hit_box.name = "hit_box"
	hit_box.debug_color= Color8(255,0,0,175)
	print("added hit_box")
	add_hit_box_buttion = false
#endregion

#runs the tools needed for the script using buttion
## just buttion checks for the tool script
func _physics_process(_delta):
	if Engine.is_editor_hint():
		if add_hit_box_buttion: add_new_hit_box()
		if fix_color_buttion: fix_color()
	else:
		pass
		
