## a testing class to have a constant active hit bock to be used to test things
class_name ActiveHitBox extends Area2D

@export var attack_data: HitBoxData
func _ready():
	area_entered.connect(damage)
	body_entered.connect(damage) # i dont think this is being use but check at the end 
	collision_mask = 2

# this will be called multiple times on a player if more than one hurtbox is hit becues there is no exeption check here
func damage(area):
	print("entred")
	if area is HurtBoxArea:
		area.health.change_health(attack_data.damage)
		if area.health.host.is_facing_right:
			area.stun_manager.start_stun_with_tween(attack_data,Vector2(1,1), false)
		elif area.health.host.is_facing_right == false:
			area.stun_manager.start_stun_with_tween(attack_data,Vector2(-1,1), false)
	print(area.health.current_health)
			
