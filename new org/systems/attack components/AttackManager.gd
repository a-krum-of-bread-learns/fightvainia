##the attack manager 
@tool
class_name AttackManager extends Node2D
#tool buttions
@export_category("buttons")
@export var add_attack_button: bool = false ## tool buttion
@export_group("danger zone")
@export var clear_button1: bool = false## tool buttion 3 for insurence if all are pressed all childeren will be deleted
@export var clear_button2: bool = false## tool buttion 3 for insurence 
@export var clear_button3: bool = false## tool buttion 3 for insurence 
 

@export_category("")
@export var animation_tool: AnimationTool
@export var host: EntityBase ## this is here to be an easy refence for child nodes
var hit_expetions: Array[EntityBase] ## prevents hitting the same thing twice with one attack 
var current_attack: Attack
signal has_hit_signal_attack_manger(data: HitBoxData)

func start_animation(is_facing_right: bool, animation_stuff: Array[AnimationResource]):
		animation_tool.animate(is_facing_right,animation_stuff)
		
## sets the hurtboxes to link with the health compnet and stun manager
func _ready():
	if (HelperFuncs.check_if_null(host, "AttackManager host", self)
	or HelperFuncs.check_if_null(animation_tool, "animation tool ", self)):
		return
	for child in get_children():
		if child is Attack:
			for frame: Frame in child.frames:
				var box = frame.get_hurtboxarea()
				if box:
					box.health = host.health_component
					box.stun_manager = host.stun_manager
					box.collision_layer = host.hurt_box_layer
					
				box = frame.get_hitboxarea()
				if box:
					box.collision_mask = host.hit_box_mask
					if not box.has_hit_signal.is_connected(_on_has_hit):
						box.has_hit_signal.connect(_on_has_hit)
					
					
				

## resets the attack prorpreties and clears [member hit_exeptions]
func reset_values(attack: Attack):
	hit_expetions.clear()
	attack.reset()

func is_attack_safe_to_read() -> bool:
	if host.is_attacking == false:
		return false
	return current_attack.active_frame < current_attack.frames.size()

func get_current_hitboxarea() -> HitBoxArea:
	if not is_attack_safe_to_read():
		return null
	return current_attack.frames[current_attack.active_frame].get_hitboxarea()

func get_current_hurtboxarea() -> HurtBoxArea:
	if not is_attack_safe_to_read():
		return null
	return current_attack.frames[current_attack.active_frame].get_hurtboxarea()

func get_next_hitboxarea() -> HitBoxArea:
	if not is_attack_safe_to_read():
		return null
	if current_attack.active_frame + 1 >= current_attack.frames.size():
		return null
	return current_attack.frames[current_attack.active_frame + 1].get_hitboxarea()

func get_next_hurtboxarea() -> HurtBoxArea:
	if not is_attack_safe_to_read():
		return null
	if current_attack.active_frame + 1 >= current_attack.frames.size():
		return null
	return current_attack.frames[current_attack.active_frame + 1].get_hurtboxarea()
	
func get_frames_remaining():
	if is_attack_safe_to_read():
		return current_attack.frames.size() - current_attack.active_frame
	else: return 0
	

	
## starts an attack and sets [member host.is_attacking]
func start_attack(an_attack: Attack):
	if host.is_stuned: return
	if an_attack == null:
		push_error("AttackManager: tried to start a null attack")
		return
	if current_attack: 
		current_attack.frames[current_attack.active_frame-1].set_frame_disabled(true)
		reset_values(current_attack)
	reset_values(an_attack)
	if host.is_attacking == false:
		host.is_attacking = true
		current_attack = an_attack
		print(current_attack.name)
	# if alrealy attaking and an attack is started cancel the previous attack by reseting it first
	elif host.is_attacking == true:
		host.is_attacking = true
		current_attack.reset()
		current_attack = an_attack
		an_attack.reset()
		
	if current_attack.animation_stuff:
		start_animation(host.is_facing_right,current_attack.animation_stuff)



#TODO add a check for that reenables the dealt damage boolen in the parent 
##checks is attacking varable so that it can stop or contine 
func continue_attack():
	if current_attack.frames.is_empty():
		push_error("AttackManager: attack has no frames in " + current_attack.name)
		return
	if current_attack == null:
		push_error("attack is null")
		return
	if host.is_stuned: 
		for frame: Frame in current_attack.frames:
			frame.set_frame_disabled(true)
			reset_values(current_attack)
			host.is_attacking = false
		return
	print(current_attack.active_frame + 1)
	
	if current_attack.active_frame+1 >= current_attack.frames.size():
		host.is_attacking = false 
		current_attack.frames[current_attack.active_frame-1].set_frame_disabled(true)
		reset_values(current_attack)
	else:
		if current_attack.active_frame != 0:
			current_attack.frames[current_attack.active_frame-1].set_frame_disabled(true)
		current_attack.frames[current_attack.active_frame].set_frame_disabled(false)
		current_attack.active_frame += 1
	
	if is_attack_safe_to_read():
		for node in current_attack.frames[current_attack.active_frame-1].get_children():
			if node is ProjectileArea:
				print("PROJECTILE FOUND ON FRAME: ", current_attack.active_frame-1)
				node.is_active = true
				current_attack.frames[current_attack.active_frame-1].set_frame_disabled(false)


func _on_has_hit(data: HitBoxData):
	has_hit_signal_attack_manger.emit(data)
	current_attack.has_hit = true
	start_animation(host.is_facing_right, current_attack.animation_stuff)
	OnHitAudioManager.play_hit_sound(current_attack.hit_sound)
	#TODO make attacks audio per hit box inculde below comment
	#OnHitAudioManager.play_hit_sound(data.hit_sound)

#------------------------------------------------
#tool coments section

##adds a new attack node of class Attack
func add_new_attack(): 
	var new_attack: Attack = Attack.new()
	add_child(new_attack) 
	#the new frame having its probetys set
	new_attack.owner = get_tree().edited_scene_root
	print(get_children(true))
	print("added attack")
	add_attack_button = false
	
## clears all children
func clear_all_attacks():
	for child in get_children(true):
		if child is Attack:
			remove_child(child)
	clear_button1 = false
	clear_button2 = false
	clear_button3 = false


# must be physics process im not sure why 
func _physics_process(_delta):	
	if Engine.is_editor_hint():
		if add_attack_button: add_new_attack()
		if clear_button1 and clear_button2 and clear_button3:
			clear_all_attacks()
	else:
		if host.is_attacking: 
			continue_attack()
			#print("remain " +str(get_frames_remaining()))
	
	
	
