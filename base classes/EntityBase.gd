## a base class for anthing that will move like player, enemys, (npc, chects, etc could be interactable insteds)
class_name EntityBase extends CharacterBody2D
var is_attacking: bool = false 
@export var is_facing_right: bool = true ## holds the direction the Entity is facing
@export var is_blocking: bool = false
@export var stun_manager: StunManager
@export_enum("error:-1","LOW:1","OVERHEAD:3") var block_type: int = 2
enum BLOCK_TYPE {LOW=1, OVER=3} ## type of block
var tween: Tween = null
var is_actionable


func _physics_process(_delta):
	if stun_manager.is_stuned == false and is_on_floor():
		velocity.x = 0
	
	move_and_slide()
