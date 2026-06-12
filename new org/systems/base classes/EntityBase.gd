## a base class for anthing that will move like player, enemys, (npc, chects, etc could be interactable insteds)
#TODO MAJOR DECOUPLE put all conditons in this enity base and change the values only with the relevent componet 
class_name EntityBase extends CharacterBody2D
@export var is_facing_right: bool = true ## holds the direction the Entity is facing
@export var is_blocking: bool = false
@export var stun_manager: StunManager
@export var health_component: Health
@export var stats: EntityStats

@export_enum("error:-1","LOW:1","OVERHEAD:3") var block_type: int = 2
enum BLOCK_TYPE {LOW=1, OVER=3} ## type of block
var tween: Tween = null
var is_actionable = true


func _physics_process(_delta):
	if stun_manager.is_stuned == false and is_on_floor():
		velocity.x = 0
	#print(self.name + " velocity " + str(self.velocity))
	move_and_slide()
