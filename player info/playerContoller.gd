##this is the base calss for the players (playable characters)
##this should have the layers 1 walls, 2 players enabled
#movvnet in this class is to be speaifc to this class
class_name Player extends EntityBase
##hurt boxes that are always there for each state
@export_category("primary hurt boxes")
@export var colission_box: CollisionShape2D


@export_category("componets")
@export var scale_component: Scale##see Scale [Scale]
@export var input_component: InputManager##see InputManager [InputManager]
@export var PrimaryHurtBoxes_component: PrimaryHurtBoxes
#the is somthing varables
var is_crouching: bool = false ## tells if player is crouching


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
	if PrimaryHurtBoxes_component:
		PrimaryHurtBoxes_component.primary_hurt_box_manager()
	#not my function
	move_and_slide()
	print_rich("[color=blue][b]Hello[/b][/color] world!")
