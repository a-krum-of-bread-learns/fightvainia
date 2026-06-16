## a base class for anthing that will move like player, enemys, (npc, chects, etc could be interactable insteds)
#TODO MAJOR DECOUPLE put all conditons in this enity base and change the values only with the relevent componet 
class_name EntityBase extends CharacterBody2D
@export var is_facing_right: bool = true ## holds the direction the Entity is facing
@export var is_blocking: bool = false
@export var stun_manager: StunManager
@export var attack_manager: AttackManager
@export var scale_component: Scale
@export var health_component: Health
@export var stats: EntityStats

@export_enum("error:-1","LOW:1","ALL:2","OVERHEAD:3") var block_type: int = 3
enum BLOCK_TYPE {LOW=1, ALL=2, OVER=3} ## type of block
var tween: Tween = null
var is_actionable = true

func _ready() -> void:
	HelperFuncs.check_if_null(stats, "stats", self)
	HelperFuncs.check_if_null(health_component, "health_component", self)
	HelperFuncs.check_if_null(stun_manager, "stun_manager", self)
	HelperFuncs.check_if_null(attack_manager, "attack_manager", self)
	HelperFuncs.check_if_null(scale_component, "scale_component", self)


func get_frames_remaining() -> int:
	# in hitstun or blockstun - read from stun manager
	if stun_manager.is_stuned:
		return stun_manager.remaining_duration
	# in attack recovery - read from attack manager
	if attack_manager.is_attack_safe_to_read():
		return attack_manager.get_frames_remaining()
	return 0

func _physics_process(_delta):
	if stun_manager.is_stuned == false and is_on_floor():
		velocity.x = 0
	print(self.name + " velocity " + str(self.velocity))
	print(self.name + " block type  " + str(self.block_type))
	move_and_slide()
