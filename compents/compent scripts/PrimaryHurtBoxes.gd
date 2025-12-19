class_name PrimaryHurtBoxes extends BehaviourBase
#seting the reday name
#TODO conisder the reduncancey here
@export var standing_hurt_box_area: HurtBoxArea
@export var crouching_hurt_box_area: HurtBoxArea
@export var airborne_hurt_box_area: HurtBoxArea
var standing_hurt_box: CollisionShape2D
var crouching_hurt_box: CollisionShape2D
var airborne_hurt_box: CollisionShape2D
var all_shapes: Array[CollisionShape2D]

func _ready():
	self.name = "primary hurt boxes"
	super._ready()
	standing_hurt_box = standing_hurt_box_area.get_child(0)
	crouching_hurt_box = crouching_hurt_box_area.get_child(0)
	airborne_hurt_box = airborne_hurt_box_area.get_child(0)
	all_shapes.append(standing_hurt_box)
	all_shapes.append(crouching_hurt_box)
	all_shapes.append(airborne_hurt_box)

func set_box(box: CollisionShape2D):
	for shape in all_shapes:
		shape.disabled = true
		shape.visible = false
	box.disabled = false
	box.visible = true
	

func primary_hurt_box_manager():
	if host.is_on_floor() and Input.is_action_pressed("down"):
		set_box(crouching_hurt_box)
	elif host.is_on_floor(): 
		set_box(standing_hurt_box)
	elif not host.is_on_floor():
		set_box(airborne_hurt_box)
	
	
