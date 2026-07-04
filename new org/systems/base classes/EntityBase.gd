## a base class for anthing that will move like player, enemys, (npc, chects, etc could be interactable insteds)
class_name EntityBase extends CharacterBody2D
var is_facing_right: bool = true ## holds the direction the Entity is facing
var is_blocking: bool = false
var is_attacking: bool = false
var is_stuned: bool = false
var is_falling: bool = true
var is_dashing: bool = false
var is_jumping: bool = false
var is_crouching: bool = false
@export var is_dummy: bool = false
@export var stun_manager: StunManager
@export var attack_manager: AttackManager
@export var scale_component: Scale
@export var health_component: SimpleHealthBar
@export var stats: EntityStats
@export var primary_boxes_and_sprites: EntityPrimaryHurtBoxesAndSprites
@export var contol_node: BehaviourBase
@export var combo_tracker: ComboTracker
@export var hurt_box_layer: int = 2 ##eneimes hurt on 2 player hurts on 4 use 6 to hurt both
@export var hit_box_mask: int = 4 ##eneimes hit on 4 player hits on 2 use 6 to hit both



@export_enum("error:-1","LOW:1","ALL:2","OVERHEAD:3") var block_type: int = 3
enum BLOCK_TYPE {LOW=1, ALL=2, OVER=3} ## type of block
var tween: Tween = null


func _ready() -> void:
	HelperFuncs.check_if_null(stats, "stats", self)
	HelperFuncs.check_if_null(health_component, "health_component", self)
	HelperFuncs.check_if_null(stun_manager, "stun_manager", self)
	HelperFuncs.check_if_null(attack_manager, "attack_manager", self)
	HelperFuncs.check_if_null(scale_component, "scale_component", self)
	HelperFuncs.check_if_null(primary_boxes_and_sprites, "primary_boxes_and_sprites", self)
	stun_manager.stun_has_ended.connect(primary_hurt_box_manager)

func get_frames_remaining() -> int:
	# in hitstun or blockstun - read from stun manager
	if is_stuned:
		return stun_manager.remaining_duration
	# in attack recovery - read from attack manager
	if attack_manager.is_attack_safe_to_read():
		return attack_manager.get_frames_remaining()
	return 0

func _physics_process(_delta):
	if is_stuned == false and is_on_floor() and is_dummy:
		velocity.x = 0
	print(self.name + " velocity " + str(self.velocity))
	print(self.name + " block type  " + str(self.block_type))
	move_and_slide()

func primary_hurt_box_manager():
	if is_on_floor() and is_crouching:
		primary_boxes_and_sprites.disable_all_pimary_boxes_exluding(primary_boxes_and_sprites.crouching_hurt_box)
		primary_boxes_and_sprites.disable_all_pimary_sprites_excluding(primary_boxes_and_sprites.crouching_sprite)
	elif is_on_floor(): 
		primary_boxes_and_sprites.disable_all_pimary_boxes_exluding(primary_boxes_and_sprites.standing_hurt_box)
		primary_boxes_and_sprites.disable_all_pimary_sprites_excluding(primary_boxes_and_sprites.standing_sprite)
	elif not is_on_floor():
		primary_boxes_and_sprites.disable_all_pimary_boxes_exluding(primary_boxes_and_sprites.airborne_hurt_box)
