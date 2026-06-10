##this is the base calss for the players (playable characters)
##this should have the layers 1 walls, 2 players enabled
#movvnet in this class is to be speaifc to this class
class_name Player extends EntityBase
@export_category("componets")
@export var colission_box: CollisionShape2D
@export var input_component: InputManager##see InputManager [InputManager]
@export var PrimaryHurtBoxes_component: EntityPrimaryHurtBoxesAndSprites

#the is somthing varables
var is_crouching: bool 
func _ready() -> void:
	super._ready()
	if colission_box == null:
		push_error("colission_box not set on "+str(self.name))
	if scale_component == null:
		push_error("scale_component not set on "+str(self.name))
	if input_component == null:
		push_error("input_component not set on "+str(self.name))
	if PrimaryHurtBoxes_component == null:
		push_error("PrimaryHurtBoxes_component not set on "+str(self.name))
	
func primary_hurt_box_manager():
	if is_on_floor() and Input.is_action_pressed("down"):
		PrimaryHurtBoxes_component.disable_all_pimary_boxes_exluding(PrimaryHurtBoxes_component.crouching_hurt_box)
		PrimaryHurtBoxes_component.disable_all_pimary_sprites_excluding(PrimaryHurtBoxes_component.crouching_sprite)
	elif is_on_floor(): 
		PrimaryHurtBoxes_component.disable_all_pimary_boxes_exluding(PrimaryHurtBoxes_component.standing_hurt_box)
		PrimaryHurtBoxes_component.disable_all_pimary_sprites_excluding(PrimaryHurtBoxes_component.standing_sprite)
	elif not is_on_floor():
		PrimaryHurtBoxes_component.disable_all_pimary_boxes_exluding(PrimaryHurtBoxes_component.airborne_hurt_box)

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
	#print("player velcoity "+str(velocity))
	#print("player scale " + str(scale))



	
	
