##this is the base calss for the players (playable characters)
##this should have the layers 1 walls, 2 players enabled
#movvnet in this class is to be speaifc to this class
class_name Player extends EntityBase
@export_category("componets")
@export var colission_box: CollisionShape2D
@export var scale_component: Scale##see Scale [Scale]
@export var input_component: InputManager##see InputManager [InputManager]
@export var PrimaryHurtBoxes_component: PlayerPrimaryHurtBoxesAndSprites

#the is somthing varables
var is_crouching: bool 

func primary_hurt_box_manager():
	if is_on_floor() and Input.is_action_pressed("down"):
		PrimaryHurtBoxes_component.set_box(PrimaryHurtBoxes_component.crouching_hurt_box)
		PrimaryHurtBoxes_component.set_sprite(PrimaryHurtBoxes_component.crouching_sprite)
	elif is_on_floor(): 
		PrimaryHurtBoxes_component.set_box(PrimaryHurtBoxes_component.standing_hurt_box)
		PrimaryHurtBoxes_component.set_sprite(PrimaryHurtBoxes_component.standing_sprite)
	elif not is_on_floor():
		PrimaryHurtBoxes_component.set_box(PrimaryHurtBoxes_component.airborne_hurt_box)

## sets the variables that are used else where in code
func set_important_vars():
	is_crouching = Input.is_action_pressed("down") and is_on_floor()
	#print("crouching " + str(is_crouching))
	
## its _process what else to say (1) 
## this calls most of the fucinss that are needed to be used every frame
func _physics_process(_delta):
	if input_component == null:
		print(is_on_floor())
	set_important_vars()
	#not my function
	move_and_slide()
	#print("player postion "+str(global_position))
	#dsssssprint("player velcoity "+str(velocity))
	#print("player scale " + str(scale))



	
	
