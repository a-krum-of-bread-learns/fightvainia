## a base class for anything that will move like player or enemys and will fight.
##
## All entities have the same few key nodes and a few optional ones, the key ones being
## [StunManager], [AttackManager], [Scale], [SimpleHealthBar], [EntityStats], [EntityPrimaryHurtBoxesAndSprites]
## and [member control_node], which depends on what the entity will be. If it's a player it will use [InputManager],
## if it's an enemy it will use [EnemyLogic]. The optional nodes are [SimpleDamageNumberEffect], [ComboTracker],
## and [SelfComboTracker] — see the corresponding class to know when to use them.[br]
## To start making a player: add the key nodes mentioned above, then add [MoveList] and [InputManager].[br]
## To start making an enemy: add the key nodes mentioned above, then add [EnemyLogic] and fill out its [BossSettings].[br]
## For both, set [member hurt_box_layer] and [member hit_box_mask].
class_name EntityBase extends CharacterBody2D
var is_facing_right: bool = true ## holds the direction the Entity is facing
var is_blocking: bool = false
var is_attacking: bool = false
var is_stuned: bool = false
var is_falling: bool = true
var is_dashing: bool = false
var is_jumping: bool = false
var is_crouching: bool = false
@export var stun_manager: StunManager
@export var attack_manager: AttackManager
@export var scale_component: Scale
@export var health_component: SimpleHealthBar
@export var stats: EntityStats
@export var primary_boxes_and_sprites: EntityPrimaryHurtBoxesAndSprites
@export var simple_damage_effect: SimpleDamageNumberEffect
@export var control_node: BehaviourBase ## if enemy use [EnemyLogic] if player use [InputManager]
@export var combo_tracker: SelfComboTracker
@export var on_screen_combo_tracker: ComboTracker
#@export_enum("player_layers:1", "enemy_layers:2") var layers = 2# this didnt work well
@export_enum("player:4" , "enemy:2") var hurt_box_layer: int = 2 ##eneimes hurt on 2 player hurts on 4 use 6 to hurt both
@export_enum("player:2" , "enemy:4") var hit_box_mask: int = 4 ##eneimes hit on 4 player hits on 2 use 6 to hit both
signal set_enabled(value: bool)


@export_enum("error:-1","LOW:1","ALL:2","OVERHEAD:3") var block_type: int = 3
enum BLOCK_TYPE {LOW=1, ALL=2, OVER=3} ## type of block
var tween: Tween = null


func _ready() -> void:
	EnemyLogic
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
	print(self.name + " velocity " + str(self.velocity))
	print(self.name + " posion " + str(self.global_position))
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
		
		
func cutsecene_start():
	is_falling = false
	velocity = Vector2.ZERO
	
func cutsecene_end():
	is_falling = true
