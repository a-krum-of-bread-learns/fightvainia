class_name attack_managermini extends Node2D
@export var test_attack: attackmini
var hit_expetions: Array[CharacterBody2D] ## prevents hitting the same thing twice with one attack 
var is_attacking = false # note this is moved to entity base in real code
var current_attack: attackmini
signal has_hit_attack_manager_mini

## remits the signal from hitbox
func _on_has_hit(player,is_attack_blocked):
	current_attack.has_hit = true
	has_hit_attack_manager_mini.emit(player,is_attack_blocked)
	print(player.name)
	
#note  this is probly bad code design 
func _ready() -> void:
	for attack in get_children():
		for frame in attack.get_children():
			for area in frame.get_children():
				if area is hitboxmini:
					if not area.has_hit_hitbox_mini.is_connected(_on_has_hit):
						area.has_hit_hitbox_mini.connect(_on_has_hit)
				# part of the hit exeption code
				if area is hurtboxmini:
					area.player = get_parent()

func start_attack(attack: attackmini):
	if current_attack: 
		current_attack.frames[current_attack.active_frame-1].set_frame_disabled(true)
		reset_values(current_attack)
	reset_values(attack)
	is_attacking = true
	current_attack = attack
		
#region main code
func continue_attack():
	print("active frame: " + str(current_attack.active_frame))
	var current_frame: framemini = current_attack.frames[current_attack.active_frame]
	var previous_frame: framemini = null
	
	if current_attack.active_frame != 0:
		previous_frame = current_attack.frames[current_attack.active_frame - 1]
		previous_frame.set_frame_disabled(true)
		
	if current_attack.active_frame + 1 >= current_attack.frames.size():
		is_attacking = false
		reset_values(current_attack)
	else:
		current_frame.set_frame_disabled(false)
		current_attack.active_frame += 1
#endregion main code end
		
		
	if current_attack.has_hit and current_attack.can_forced_follow_up:
		print("start a follow up using start attack")
		
	if current_attack.is_multi_hit:
		hit_expetions.clear()
	
## resets the attack prorpreties and clears [member hit_exeptions]
func reset_values(attack: attackmini):
	hit_expetions.clear()
	attack.reset()

	
func _physics_process(_delta):
	# this would be a diffrent class calling this input
	if Input.is_action_pressed("LP"):
		start_attack(test_attack)

	if is_attacking: 
		continue_attack()
