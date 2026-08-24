## Base class for all hit-dealing areas — [HitBoxArea] extends this, and [ProjectileArea]
## extends [HitBoxArea]. Holds the [member attack_data] used to deal damage and stun.
##
## Always active Deals damage on every [HurtBoxArea] overlap and can hit the same
## target multiple times at once (e.g. standing + crouching hurtboxes), since there's 
## no exception check like [member AttackManager.hit_expetions] provides.[br]
## Useful on its own for quick testing without setting up a full [Attack].
class_name ActiveHitBox extends Area2D

@export var attack_data: HitBoxData
func _ready():
	area_entered.connect(damage)
	#body_entered.connect(damage) # i dont think this is being use but check at the end 
	collision_mask = 2
	collision_layer = 2

# this will be called multiple times on a player if more than one hurtbox is hit becues there is no exeption check here
func damage(area):
	print("entred")
	if area is HurtBoxArea:
		area.health.reduce_health(attack_data.damage)
		if area.health.host.is_facing_right:
			area.stun_manager.start_stun_with_tween(attack_data,Vector2(1,1), false)
		elif area.health.host.is_facing_right == false:
			area.stun_manager.start_stun_with_tween(attack_data,Vector2(-1,1), false)
	print(area.health.current_health)
			
