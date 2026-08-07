## Manages the lifecycle of an entity's attacks: starting, advancing frame by frame,
## and ending them. 
##
## The attack manager is in 2 parts, the @tool section is for creation of attacks
## and the game code section is for when the game is running. [br]
## Manages the lifecycle of an entity's attacks: starting, advancing frame by frame,
## and ending them. Requires a forced child structure of [Attack] nodes, each containing
## [Frame] nodes, each containing [HitBoxArea], [HurtBoxArea], [ProjectileArea],
## and/or [Sprite2D]. Each area contains a [CollisionShape2D], and a [ProjectileArea]
## may also contain a [Sprite2D].[br]here is an example 
## [codeblock]
## AttackManager
## └── Attack
##     └── Frame
##         ├── HitBoxArea
##         │   └── CollisionShape2D
##         ├── HurtBoxArea
##         │   └── CollisionShape2D
##         ├── ProjectileArea
##         │   ├── CollisionShape2D
##         │   └── Sprite2D (optional)
##         └── Sprite2D (optional)
## [/codeblock][br]
## Reads [member host]'s collision layer/mask settings and applies them to every
## hitbox/hurtbox found under this node on [method _ready]. Also links each hurtbox's
## [member HurtBoxArea.health] and [member HurtBoxArea.stun_manager] to [member host]'s
## own components, so individual [Attack] scenes never need those references set manually.[br][br]
## Calling [method start_attack] while [member host.is_attacking] is already true cancels
## the current attack, disabling its active frame and resetting both attacks via
## [method reset_values]. Combo/special cancel conditions (see [member Attack.can_combo],
## [member Attack.can_speical_cancel]) are checked by the calling node such as [InputManager]
## and [EnemyLogic], not this class.[br][br]
## When a [HitBoxArea] under this manager successfully hits something, it emits its own
## has_hit_signal, which this class listens for via [method _on_has_hit] and re-emits as
## [signal has_hit_signal_attack_manger] so other systems (UI, audio, combo tracking) can
## react without needing a direct reference to the [HitBoxArea] itself.
@tool
class_name AttackManager extends Node2D
#tool buttions
@export_category("buttons")
@export var add_attack_button: bool = false ## tool buttion
@export_group("danger zone")
@export var clear_button1: bool = false## tool buttion 3 for insurence if all are pressed all childeren will be deleted
@export var clear_button2: bool = false## tool buttion 3 for insurence 
@export var clear_button3: bool = false## tool buttion 3 for insurence 
 

@export_category("dont touch")
@export_group("dont touch")
@export var animation_tool: AnimationTool
@export var host: EntityBase ## this is here to be an easy refence for child nodes
var hit_expetions: Array[EntityBase] ## prevents hitting the same thing twice with one attack 
var current_attack: Attack

## Emitted when this manager's [HitBoxArea] hits an entity, passed along via
## [method _on_has_hit] so other systems can react without a direct [HitBoxArea] reference.
signal has_hit_signal_attack_manger(entity: EntityBase, blocked: bool)


func start_animation(is_facing_right: bool, animation_stuff: Array[AnimationResource]):
		animation_tool.animate(is_facing_right,animation_stuff,current_attack.kill_momnetum_of_tween_start, current_attack.kill_momnetum_of_tween_end)
		
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
					
#region game code
#region getter functions 
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

#endregion


## resets the attack prorpreties and clears [member hit_exeptions]
func reset_values(attack: Attack):
	hit_expetions.clear()
	attack.reset()
	
## starts an attack and sets [member host.is_attacking]
func start_attack(an_attack: Attack):
	if host.is_stuned: return
	if host.is_jumping: host.is_jumping = false
	if an_attack == null:
		push_error("AttackManager: tried to start a null attack")
		return
	if current_attack: 
		current_attack.frames[current_attack.active_frame-1].set_frame_disabled(true)
		reset_values(current_attack)
	reset_values(an_attack)
	host.is_attacking = true
	current_attack = an_attack
		
	if current_attack.animation_stuff:
		start_animation(host.is_facing_right,current_attack.animation_stuff)



#TODO add a check for that reenables the dealt damage boolen in the parent 
## contiues procesing thogh each frame of the current attack activating and disableing them
func continue_attack():
	if current_attack == null:
		push_error("attack is null")
		return
	if current_attack.frames.is_empty():
		push_error("AttackManager: attack has no frames in " + current_attack.name)
		return
	#print(current_attack.active_frame)
	if host.is_stuned:
		for frame: Frame in current_attack.frames:
			frame.set_frame_disabled(true)
			reset_values(current_attack)
			host.is_attacking = false
		return

	var previous_frame: Frame = current_attack.frames[current_attack.active_frame - 1] if current_attack.active_frame != 0 else null
	var current_frame: Frame = current_attack.frames[current_attack.active_frame]

	if current_attack.active_frame + 1 >= current_attack.frames.size():
		host.is_attacking = false
		if previous_frame:
			previous_frame.set_frame_disabled(true)
		reset_values(current_attack)
	else:
		if previous_frame:
			previous_frame.set_frame_disabled(true)
			#REFACTOR fix is if for the propblem that when attack mvoves to the next frame node the prodectile is disbaled for 1 frame
			var previous_frame_projectilearea = previous_frame.get_projectileboxarea()
			if previous_frame_projectilearea is ProjectileArea:
				previous_frame_projectilearea.enable_disable_boxes()
		current_frame.set_frame_disabled(false)
		current_attack.active_frame += 1
		
	if current_attack.has_hit and current_attack.has_forced_follow_up and current_attack.can_follow_up:
		if not HelperFuncs.check_if_null(current_attack.follow_up, "follow_up", self):
			start_attack(current_attack.follow_up)
	
	if is_attack_safe_to_read():
		for node in current_attack.frames[current_attack.active_frame-1].get_children():
			if node is ProjectileArea:
				print("PROJECTILE FOUND ON FRAME: ", current_attack.active_frame-1)
				node.is_active = true
				current_attack.frames[current_attack.active_frame-1].set_frame_disabled(false)

## doesnt re-emit if their is no enity 
func _on_has_hit(entity: EntityBase, is_blocked: bool):
	current_attack.has_hit = true
	OnHitAudioManager.play_hit_sound(current_attack.hit_sound)
	start_animation(host.is_facing_right, current_attack.animation_stuff)
	if entity == null:
		return
	has_hit_signal_attack_manger.emit(entity,is_blocked)
	
	#TODO make attacks audio per hit box inculde below comment
	#OnHitAudioManager.play_hit_sound(data.hit_sound)
#endregion

#region @tool code
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
#endregion


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
	
	
	
