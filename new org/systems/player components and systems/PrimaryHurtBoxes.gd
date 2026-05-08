class_name PlayerPrimaryHurtBoxesAndSprites extends Node2D
#seting the reday name
#TODO conisder the reduncancey here if ther is any and 
#add sprite supeort via ai 
@export var standing_hurt_box_area: HurtBoxArea
@export var crouching_hurt_box_area: HurtBoxArea
@export var airborne_hurt_box_area: HurtBoxArea
@export var standing_sprite: Sprite2D
@export var crouching_sprite: Sprite2D
#@export var airborne_sprite: Sprite2D
#@export var standing_stuned_sprite: Sprite2D
#@export var crouching_stuned_sprite: Sprite2D
#@export var airborne_stuned_sprite: Sprite2D
@export var player: EntityBase
var standing_hurt_box: CollisionShape2D
var crouching_hurt_box: CollisionShape2D
var airborne_hurt_box: CollisionShape2D
var all_shapes: Array[CollisionShape2D]
var all_sprites: Array[Sprite2D]

func _ready():
	standing_hurt_box = standing_hurt_box_area.get_child(0)
	crouching_hurt_box = crouching_hurt_box_area.get_child(0)
	airborne_hurt_box = airborne_hurt_box_area.get_child(0)
	all_shapes.append(standing_hurt_box)
	all_shapes.append(crouching_hurt_box)
	all_shapes.append(airborne_hurt_box)
	standing_hurt_box_area.stun_manager = player.stun_manager
	standing_hurt_box_area.health = player.health_component
	crouching_hurt_box_area.stun_manager = player.stun_manager
	crouching_hurt_box_area.health = player.health_component
	airborne_hurt_box_area.stun_manager = player.stun_manager
	airborne_hurt_box_area.health = player.health_component
	
	all_sprites.append(standing_sprite)
	all_sprites.append(crouching_sprite)
	
	
func disable_all_pimary_boxes():
	for shape in all_shapes:
		shape.disabled = true
		shape.visible = false
		
	
func set_box(box: CollisionShape2D):
	disable_all_pimary_boxes()
	box.disabled = false
	box.visible = true
	
func disable_all_pimary_sprites():
	for sprite in all_sprites:
		sprite.visible = false
		
func set_sprite(sprite: Sprite2D):
	disable_all_pimary_sprites()
	sprite.visible = true
