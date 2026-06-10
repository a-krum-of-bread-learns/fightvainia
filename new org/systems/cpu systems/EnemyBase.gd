class_name EnemyBase extends EntityBase

@export_group("components")
@export var rays: Array[RayCast2D]
@export var primary_hurt_boxes_component: EntityPrimaryHurtBoxesAndSprites
@export_group("attack settings")
@export_range(1, 9223372036854775807) var minimum_time_before_attacks_in_frames: int = 60
@export var combo_0_attacks: Array[Attack]
var current_attack_index: int = 0
