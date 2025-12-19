## this can hit a hurt box and is where the most happens for damage
@tool
class_name HitBoxArea extends ActiveHitBox
@export_category("buttions")
@export var add_hit_box_buttion: bool = false
@export var fix_color_buttion: bool = false
#TODO consider removing this?
@onready var attack_manager: AttackManger =get_parent().get_parent().get_parent()## easy refence of the attack manager


#changed from colison shape to an area so now area need to have dirent thid coded
## conects singals and is just to warn the hit box has no info and where 
func _ready():
	if attack_data.stun_type == -1:
		push_error("stun type not assigned in " + get_parent().name + " of attack " + get_parent().get_parent().name)
	if attack_data.hit_type == -1:
		push_error("hit type not assigned in " + get_parent().name + " of attack " + get_parent().get_parent().name)
	if attack_data.block_stun_duration == -1:
		push_error("block stun duration not assigned in " + get_parent().name + " of attack " + get_parent().get_parent().name)
	if attack_data.block_back_distance == -1:
		push_error("block back distance not assigned in " + get_parent().name + " of attack " + get_parent().get_parent().name)
	if attack_data.hit_stun_duration == -1:
		push_error("hit stun duration not assigned in " + get_parent().name + " of attack " + get_parent().get_parent().name)
	if attack_data.hit_back_distance_vector == Vector2(-1,-1):
		push_error("hit back distance vector not assigned in " + get_parent().name + " of attack " + get_parent().get_parent().name)
	if attack_data.hit_stop_frames == 0:
		push_error("hit stop frames not assigned in " + get_parent().name + " of attack " + get_parent().get_parent().name)
	if attack_data.damage == -1:
		push_error("damage not assigned in " + get_parent().name + " of attack " + get_parent().get_parent().name)
	area_entered.connect(damage)
	body_entered.connect(damage)


# detecting a player we colided with 
## esantaly the fucntion to deal damage if target is valid  blocking logic contained here
func damage(area):
	if area is HurtBoxArea:
		var area_host: EntityBase = area.health.host # TODO rename for claity that this is the entity that is attacked
		var attacker: EntityBase = attack_manager.host
		#put here for renable if wanted
		print(attack_manager.hit_expetions)
		#prevents hiting self even if i hit somthing else
		if attack_manager.hit_expetions.is_empty():
			attack_manager.hit_expetions.append(attack_manager.host)
		# prevents self damage and hitting again
		if (get_parent().get_children().has(area) == false 
		and attack_manager.hit_expetions.has(area_host) == false): 
			attack_manager.hit_expetions.append(area_host)
			#stun and damage calls are inside
			
			block_check(area_host, area)
			
			
## true means blocked
func high_low_block_check(area_host: EntityBase)-> bool:
	if attack_data.hit_type == area_host.block_type:
		return true
	elif attack_data.hit_type != area_host.block_type:
		if attack_data.hit_type == attack_data.HIT_TYPE.MID:
			return true
		else: return false
	# error
	push_error("block has done somthing that has borken it")
	return false

#TODO block check should return a true or false not decide the attack and knockback
func block_check(area_host: EntityBase, area: HurtBoxArea):
	var position_check = self.global_position.x
	var attack_from_right = position_check > area_host.global_position.x
	if area_host.is_blocking and high_low_block_check(area_host):
		# attack from right side of area and blocking from right
		if attack_from_right and area_host.is_facing_right == true:
			print("was blocked")
			area.stun_manager.start_stun_with_tween(attack_data,Vector2(-1,1), true)

		# attack from left side of area and blocking from left
		elif not attack_from_right and area_host.is_facing_right == false:
			print("was blocked")
			area.stun_manager.start_stun_with_tween(attack_data,Vector2(1,1), true)
				
		else:
			# attack from left side of area and blocking from right
			if not attack_from_right:
				area.health.change_health(attack_data.damage)
				area.stun_manager.start_stun_with_tween(attack_data,Vector2(1,1), false)
				print(area.health.current_health)

			# attack from right side of area and blocking from left
			elif attack_from_right:
				area.health.change_health(attack_data.damage)
				area.stun_manager.start_stun_with_tween(attack_data,Vector2(-1,1), false)
				print(area.health.current_health)
	else:
		if attack_from_right:
			area.health.change_health(attack_data.damage)
			area.stun_manager.start_stun_with_tween(attack_data,Vector2(-1,1), false)
			print(area.health.current_health)

		elif not attack_from_right:
			area.health.change_health(attack_data.damage)
			area.stun_manager.start_stun_with_tween(attack_data,Vector2(1,1), false)
			print(area.health.current_health)

# change helth apply knockback on hit / on block







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

#runs the tools needed for the script using buttion
## just buttion checks for the tool script
func _physics_process(_delta):
	if Engine.is_editor_hint():
		if add_hit_box_buttion: add_new_hit_box()
		if fix_color_buttion: fix_color()
	else:
		pass
		
