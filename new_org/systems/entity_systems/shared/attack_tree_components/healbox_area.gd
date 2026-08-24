@tool
class_name HealBoxArea extends Area2D

@export_category("buttions")
@export var add_heal_box_buttion: bool = false
@export var fix_color_buttion: bool = false
@export_category("heal data")
@export var heal_data: HealBoxData

func _ready():
	HelperFuncs.check_if_null(heal_data,"heal data", self)
	heal_data.validate_data(self)
	area_entered.connect(heal)
	#TODO decide if i need to use body instead of areas for heals spesificly 
	#body_entered.connect(damage)  
	collision_mask = 7
	collision_layer = 7
	
	#self.collision_mask

func heal(area):
	if area is HurtBoxArea:
		#this code is if their is no enity 
		if area.health == null or area.stun_manager == null:
			# grapple point / simple hurtbox with no entity behind it - just signal the 
			pass
		else:
			var entity_health:SimpleHealthBar= area.health
			entity_health.increse_health(heal_data.heal_amount)
			print(entity_health.current_health)


#region @tool code
## is used to fix color if i change the defualt later
func fix_color():
	for child in get_children():
		if child is CollisionShape2D:
			child.debug_color= Color8(0,255,0,175)
	fix_color_buttion = false


##adds a new heal_box colsion shape 2d
func add_new_heal_box(): 
	var heal_box: CollisionShape2D = CollisionShape2D.new()
	heal_box.shape = RectangleShape2D.new()
	add_child(heal_box) 
	heal_box.owner = get_tree().edited_scene_root
	heal_box.name = "heal_box"
	heal_box.debug_color= Color8(0,255,0,175)
	print("added heal_box")
	add_heal_box_buttion = false
#endregion

#runs the tools needed for the script using buttion
## just buttion checks for the tool script
func _physics_process(_delta):
	if Engine.is_editor_hint():
		if add_heal_box_buttion: add_new_heal_box()
		if fix_color_buttion: fix_color()
	else:
		pass
