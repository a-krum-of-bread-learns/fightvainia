##the attack manager 
@tool
class_name AttackManger extends Node2D
#tool buttions
@export_category("buttons")
@export var add_attack_button: bool = false ## tool buttion
@export var clear_button1: bool = false## tool buttion 3 for insurence 
@export var clear_button2: bool = false## tool buttion 3 for insurence 
@export var clear_button3: bool = false## tool buttion 3 for insurence 
# varas that mater ualdy from the player 
@export_category("")
@export var health: Health ## this is here to be an easy refence for child nodes see [Health]
@export var stun_manager: StunManager ## this is here to be an easy refence for child nodes see [StunManager]
@export var host: EntityBase ## this is here to be an easy refence for child nodes
var tween: Tween 
var hit_expetions: Array[EntityBase] ## prevents hitting the same thing twice with one attack 
var current_attack: Attack
var is_attacking: = false

## sets the hurtboxes to link with the health compnet 
func _ready():
	for child in get_children():
		if child is Attack:
			for frame in child.frames:
				if frame is Frame:
					for box in frame.get_children():
						if box is HurtBoxArea:
							box.health = health
							box.stun_manager = stun_manager

## starts an attack and sets [member is_attacking]
func start_attack(an_attack: Attack):
	if is_attacking == false:
		is_attacking = true
		current_attack=an_attack
		an_attack.active_frame = 0
		print(current_attack.name)
	elif is_attacking == true:
		is_attacking = true
		current_attack.active_frame = 0
		current_attack = an_attack
		an_attack.active_frame = 0
	animate()
	
func animate(): #TODO this needs to bee checked  as it dosent stop inputs yet 
	#or actual use dispacemtnt like intedned
	if current_attack.attack_animation.is_empty() == false:
		print(current_attack.attack_animation[0].displacement)
		print(current_attack.attack_animation[0].time_in_frames)
	else: 
		push_warning("attack has no animation")
		return
	
	if host.tween:
		host.tween.kill() # Abort the previous animation.
	host.tween = create_tween()
		
	for part in current_attack.attack_animation:
		host.tween.tween_property(host,"velocity", part.get_velocty(host.is_facing_right), 0)
		host.tween.tween_property(host,"velocity", part.get_velocty(host.is_facing_right), part.get_time())
		print("time: " + str(part.get_time()))
	
	#TODO add tween to kill moemntum using if stament
	#host.tween.tween_property(host,"velocity", Vector2.ZERO, 0) #to kill
	host.tween.tween_property(host,"velocity", 
	current_attack.attack_animation[-1].get_velocty(host.is_facing_right), 0)# to keep


# add a check for a child that reenables the dealt damage boolen in the parent 
##checks is attacking varable so that it can stop or contine 
func continue_attack():
	if not current_attack == null:
		# end of the attck on last frame
		if current_attack.active_frame == current_attack.frames.size():
			is_attacking = false 
			hit_expetions.clear()
			current_attack.frames[current_attack.active_frame-1].set_frame_disabled(true)
			current_attack.active_frame = 0
		else:
			
			#to diable previous frame
			if current_attack.active_frame!=0:
				current_attack.frames[current_attack.active_frame-1].set_frame_disabled(true)
			current_attack.frames[current_attack.active_frame].set_frame_disabled(false)
			current_attack.active_frame += 1
			
		for node in current_attack.frames[current_attack.active_frame-1].get_children():
			if node is ProjectileArea:
				node.is_active = true
				current_attack.frames[current_attack.active_frame-1].set_frame_disabled(false)
		print(current_attack.active_frame)



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

## rus the buttons 
# must be physics process im not sure why 
func _physics_process(_delta):	
	if Engine.is_editor_hint():
		if add_attack_button: add_new_attack()
		if clear_button1 and clear_button2 and clear_button3:
			clear_all_attacks()
	else:
		if is_attacking: continue_attack()
	#print("speed: " + str(host.velocity))
	
