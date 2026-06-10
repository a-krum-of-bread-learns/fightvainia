## this is the hurt box that is used to ideteify when an [EntityBase] is hurt
@tool
class_name HurtBoxArea extends Area2D
@export_category("buttions")
##tool script buttion adds a cosion shape for this area hurtbox
@export var add_hurt_box_buttion: bool = false
##tool script buttion that is used to reset the debug color to a
## default in the [method fix_color] fuction if the value is changed
@export var fix_color_buttion: bool = false
@export_category("component refrence")
@export var health: Health ##see Health [Health]
@export var stun_manager: StunManager ##see StunManager [StunManager]

func _ready() -> void:
	collision_layer = 2



##tool script adds a new [HurtBoxArea] colsion shape 2d
func add_new_hurt_box(): 
	var hurt_box: CollisionShape2D = CollisionShape2D.new()
	hurt_box.shape = RectangleShape2D.new()
	add_child(hurt_box) 
	hurt_box.owner = get_tree().edited_scene_root
	hurt_box.name = "hurt_box"
	hurt_box.debug_color= Color8(0,0,255,175)
	print("added hurt_box")
	add_hurt_box_buttion = false
	
##tool script fixes [member CollisionShape2D.debug_color] to defult 
func fix_color():
	for child in get_children():
		if child is CollisionShape2D:
			child.debug_color= Color8(0,0,255,175)
	fix_color_buttion =false

##_physics_process is _physics_process (2)
## just buttion checks for the tool script
func _physics_process(_delta):
	if Engine.is_editor_hint():
		if add_hurt_box_buttion: add_new_hurt_box()
		if fix_color_buttion: fix_color()
	else:
		pass
