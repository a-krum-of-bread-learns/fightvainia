# this script contorls the adding of hurt_boxes and hurt boxes per frame is mostly a tool script 
#TODO stop processing for this holder node
## this is a holder and tool script no ipmortant function here other then forcing stucture via tool script 
@tool
class_name Frame extends Node2D
## buttions to do things
@export_category("buttions")
@export var add_hit_box_buttion: bool = false 
@export var add_hurt_box_buttion: bool = false
@export var toggle_visable_buttion: bool = false
@export var fix_names_buttion: bool = false
@export var clear_frame_button1: bool = false ## there are 2 for insurnce 
@export var clear_frame_button2: bool = false ## there are 2 for insurnce 
var box_shapes: Array[CollisionShape2D] ## 2 layers down in the forced structor are CollisionShape2D refrenced here


## sets this frames box_shapes diabled
func set_frame_disabled(value: bool):
	for shape in box_shapes:
		shape.disabled = value


## grabs the CollisionShape2D for box_shapes
func _ready():
	for boxes in get_children():
		for shape in boxes.get_children():
			if shape is CollisionShape2D:
				shape.disabled=true
				box_shapes.append(shape)

## setts all CollisionShape2D to be the same disabled state as the first on in the list to make it easier to show a spasific box
func toggle_this_frames_boxes():
	var shape_disbaled_1: bool = box_shapes[0].disabled
	for shape in box_shapes:
		if shape.disabled == shape_disbaled_1:
			shape.disabled = not shape.disabled
		else: shape.disabled = true

##adds hit box to secene tree
func add_new_hit_box(): 
	var hit_box: HitBoxArea = HitBoxArea.new()
	add_child(hit_box) 
	hit_box.collision_layer = 0
	hit_box.collision_mask = 2
	#the new frame having its probetys set
	hit_box.owner = get_tree().edited_scene_root
	print(get_children(true))
	print("added hit_box")
	add_hit_box_buttion = false
	set_frame_disabled(true)

##adds hurt box to secene tree
func add_new_hurt_box(): 
	var hurt_box: HurtBoxArea = HurtBoxArea.new()
	add_child(hurt_box) 
	hurt_box.collision_layer = 2
	hurt_box.collision_mask = 0
	#the new frame having its probetys set
	hurt_box.owner = get_tree().edited_scene_root
	print(get_children(true))
	print("added end frame")
	add_hurt_box_buttion = false
	set_frame_disabled(true)
## removes all child frames HitBoxArea and HurtBoxArea
func clear_all_frames():
	for child in get_children(true):
		if child is HitBoxArea or child is HurtBoxArea:
			remove_child(child)
	clear_frame_button1 = false
	clear_frame_button2 = false
## renames all child frames HitBoxArea and HurtBoxArea 
## has nameing sceme to separte for a function used in code 
## 1xx is hit box 2xx is projectile box 3xx is hurt box
func rename_all_boxes():
	for child in get_children():
		if child is HitBoxArea:
			child.name = "hit_box # 100"
		if child is HurtBoxArea:
			child.name = "hurt_box # 300"
		if child is ProjectileArea:
			child.name = "Projectile # 200"
	for child in get_children():
		move_child(child, child.name.to_int()%100-1)
	fix_names_buttion = false
	

## runs the buttions
func _physics_process(_delta):
	if Engine.is_editor_hint():
		if add_hit_box_buttion: add_new_hit_box()
		if add_hurt_box_buttion: add_new_hurt_box()
		if fix_names_buttion: rename_all_boxes()
		if clear_frame_button1 and clear_frame_button2: clear_all_frames()
		if toggle_visable_buttion: 
			toggle_this_frames_boxes()
			toggle_visable_buttion=false
	else: pass
