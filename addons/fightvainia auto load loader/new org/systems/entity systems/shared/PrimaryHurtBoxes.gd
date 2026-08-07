class_name EntityPrimaryHurtBoxesAndSprites extends Node2D

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
@export var host: EntityBase
var standing_hurt_box: CollisionShape2D
var crouching_hurt_box: CollisionShape2D
var airborne_hurt_box: CollisionShape2D
#var otg_hurt_box: CollisionShape2D
var all_shapes: Array[CollisionShape2D]
var all_sprites: Array[Sprite2D]

func _ready():
	HelperFuncs.check_if_null(host,"host",self)
	standing_hurt_box = standing_hurt_box_area.get_child(0)
	crouching_hurt_box = crouching_hurt_box_area.get_child(0)
	airborne_hurt_box = airborne_hurt_box_area.get_child(0)
	all_shapes.append(standing_hurt_box)
	all_shapes.append(crouching_hurt_box)
	all_shapes.append(airborne_hurt_box)
	standing_hurt_box_area.stun_manager = host.stun_manager
	standing_hurt_box_area.health = host.health_component
	crouching_hurt_box_area.stun_manager = host.stun_manager
	crouching_hurt_box_area.health = host.health_component
	airborne_hurt_box_area.stun_manager = host.stun_manager
	airborne_hurt_box_area.health = host.health_component
	
	
	standing_hurt_box_area.collision_layer = host.hurt_box_layer
	crouching_hurt_box_area.collision_layer = host.hurt_box_layer
	airborne_hurt_box_area.collision_layer = host.hurt_box_layer
	
	
	all_sprites.append(standing_sprite)
	all_sprites.append(crouching_sprite)
	
func disable_all_pimary_boxes_exluding(box: CollisionShape2D = null):
	for shape in all_shapes:
		if shape != box:
			shape.disabled = true
			shape.visible = false
		else:
			box.disabled = false
		if box != null:
			box.visible = true
	
func disable_all_pimary_sprites_excluding(sprite: Sprite2D = null):
	for s in all_sprites:
		if s != sprite:
			s.visible = false
		else:
			sprite.visible = true
	
