class_name hitboxmini extends Area2D
signal has_hit_hitbox_mini
@export var damage_value: int = 0
@onready var attack_manager: attack_managermini = get_parent().get_parent().get_parent()
@onready var self_player: CharacterBody2D = get_parent().get_parent().get_parent().get_parent()

func _ready() -> void: 
	area_entered.connect(damage)
	collision_mask = 8

func damage(area):
	if area is not hurtboxmini:
		return
	#self hit protection 
	if attack_manager.hit_expetions.is_empty():
		attack_manager.hit_expetions.append(self_player)
	#check if hit already if not add it 
	if area.player not in attack_manager.hit_expetions:
		var is_blocked = block_check_will_get_its_own_video_some_day()
		attack_manager.hit_expetions.append(area.player)
		has_hit_hitbox_mini.emit(area.player, is_blocked)
		if is_blocked == false:
			print("deal damage start stuns based on hit using some attack data")
		else: 
			print("start stuns and do things based on block")
		
		
		









func block_check_will_get_its_own_video_some_day():
	return false
