## this can hit a hurt box and is where the most happens for damage
@tool
class_name HitBoxArea extends ActiveHitBox
@export_category("buttions")
@export var add_hit_box_buttion: bool = false
@export var fix_color_buttion: bool = false
#TODO consider removing this refrence and doing it difrently?
@onready var attack_manager: AttackManager = get_parent().get_parent().get_parent()## easy refence of the attack manager

# TODO consider puting a signal here for the damage function to tell projectiles to stop when enity is hit sometimes

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
	if attack_data.hit_stun_duration == -1 and not attack_data.stun_type in [1,2,3]:
		push_error("hit stun duration not assigned in " + get_parent().name + " of attack " + get_parent().get_parent().name)
	if attack_data.hit_back_distance_vector == Vector2(-1,-1) and not attack_data.stun_type in [1,2,3]:
		push_error("hit back distance vector not assigned in " + get_parent().name + " of attack " + get_parent().get_parent().name)
	if attack_data.hit_stop_frames == 0:
		push_warning("hit stop frames set to 0 in " + get_parent().name + " of attack " + get_parent().get_parent().name)
	if attack_data.damage == -1:
		push_error("damage not assigned in " + get_parent().name + " of attack " + get_parent().get_parent().name)
	super._ready()


# detecting a player we colided with 
## esantaly the fucntion to deal damage if target is valid  blocking logic contained here
func damage(area):
	if area is HurtBoxArea:
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
			block_check2(attacked_entity, area)
			attack_manager.current_attack.has_hit = true
			OnHitAudioManager.play_hit_sound(attack_manager.current_attack.hit_sound)
			
			
## true means blocked
func high_low_block_check(attacked_entity: EntityBase)-> bool:
	if attack_manager.host.is_on_floor() == true: ## this if statment forces all attacks in the air to be over head regardless of type set even if its a grab right now but grab is not implemted
		if attack_data.hit_type == attacked_entity.block_type:
			return true
		elif attack_data.hit_type != attacked_entity.block_type:
			if attack_data.hit_type == attack_data.HIT_TYPE.MID:
				return true
			else:# block failed can also be used for grab with an if or not needed
				return false # error or grab
	elif attack_manager.host.is_on_floor() == false:
		#FIXME air peojectiles would be considered overhead witch may be bad 
		if attacked_entity.block_type == attack_data.HIT_TYPE.OVER:
			return true
		else: 
			return false
		
		
	# error
	push_error("block has done somthing that has borken it")
	return false
#TODO decide on air block
func block_check2(attacked_entity: EntityBase, area: HurtBoxArea):
	var position_check: float = self.global_position.x # if self .get parent then it would be based off of the player posion not the fire ball directon regarding the pro8jectile case 
	#var is facing right
	var attack_from_right: bool = position_check > attacked_entity.global_position.x
	var high_low_check: bool = high_low_block_check(attacked_entity)
	var is_blocking: bool = attacked_entity.is_blocking
	var bit_index = (int(is_blocking) <<3 ) |(int(high_low_check) << 2) | (int(attacked_entity.is_facing_right) << 1) | int(attack_from_right)
	var block_check_look_up: Array[bool] = [
		false, false, false, false,false, false, false, false,# not blocking
		false, false, false, false,# blocking but highlow fails
		true,  false, false, true] # if accteced entity is facing right and attack_from_right are the same
	
	var vector_direction: Vector2
	if attack_from_right: vector_direction = Vector2.UP+Vector2.LEFT
	elif attack_from_right==false: vector_direction = Vector2.UP+Vector2.RIGHT
	else: push_error("blocking is broken")
	#print("bit index for blocking: "+str(bit_index))
	if block_check_look_up[bit_index] == true:
		pass
		#print("blocked is "+str(true))
	else:
		area.health.change_health(attack_data.damage)
	
	area.stun_manager.start_stun_with_tween(attack_data,vector_direction, block_check_look_up[bit_index])
	print(area.health.current_health)
	



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
		
