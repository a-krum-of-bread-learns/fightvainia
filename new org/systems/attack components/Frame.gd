# this script contorls the adding of hurt_boxes and hurt boxes per frame is mostly a tool script 
## this is a holder and tool script no ipmortant function here other then forcing stucture via tool script 
@tool
class_name Frame extends Node2D
## buttions to do things
@export_category("buttions")
@export var add_hit_box_buttion: bool = false 
@export var add_projectile_box_buttion: bool = false 
@export var add_hurt_box_buttion: bool = false
@export var add_sprite_button: bool = false ## adds a Sprite2D to the frame
@export var fix_names_buttion: bool = false
@export var toggle_visable_buttion: bool = false
@export var clear_frame_button1: bool = false ## there are 2 for insurnce 
@export var clear_frame_button2: bool = false ## there are 2 for insurnce 
@export_category("frame info")
@export_range(0,300) var repeat_this_frame: int = 0
var box_shapes: Array[CollisionShape2D] ## 2 layers down in the forced structor are CollisionShape2D refrenced here
var spawners: Array[SpawnObject]
var sprites_array: Array[Sprite2D]
@onready var attack_manager: AttackManager = self.get_parent().get_parent()
#TODO add use default sprite support

func get_hitboxarea() -> HitBoxArea:
	for child in get_children():
		if child is HitBoxArea:
			return child
	return null

func get_hurtboxarea() -> HurtBoxArea:
	for child in get_children():
		if child is HurtBoxArea:
			return child
	return null
	
## sets this frames box_shapes diabled
func set_frame_disabled(value: bool):
	for shape in box_shapes:
		shape.disabled = value
		shape.visible = !value
	for sprite in sprites_array:
		sprite.visible = !value
	if value:
		for spawner in spawners:
			spawner.spawn(attack_manager.host.is_facing_right)


## grabs the CollisionShape2D for box_shapes
func _ready():
	for node in get_children():
		for shape in node.get_children():
			if shape is CollisionShape2D:
				shape.disabled=true
				if Engine.is_editor_hint():
					shape.visible = true
				else: shape.visible = false
				box_shapes.append(shape)
		if node is SpawnObject:
			spawners.append(node)
		if node is Sprite2D:
			if Engine.is_editor_hint():
				node.visible = true
			else: node.visible = false
			sprites_array.append(node)
	if box_shapes.is_empty() and sprites_array.is_empty():
		push_warning("Frame: " + name + " of attack " + get_parent().name + " has no boxes or sprites, is this intentional?")

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
	hit_box.collision_layer = 2
	hit_box.collision_mask = 2
	hit_box.owner = get_tree().edited_scene_root
	print(get_children(true))
	print("added hit_box")
	add_hit_box_buttion = false
	set_frame_disabled(true)
	rename_all_children()
	
func add_new_projectile_box(): 
	var projectile_box: ProjectileArea = ProjectileArea.new()
	var frame_timer: FrameTimer = FrameTimer.new()
	var animation_tool: AnimationTool = AnimationTool.new()
	add_child(projectile_box) 
	projectile_box.add_child(frame_timer)
	frame_timer.name = "frame timer"
	projectile_box.timer = frame_timer
	projectile_box.add_child(animation_tool)
	animation_tool.thing_to_animate = projectile_box
	animation_tool.name = "projectile animateor"
	projectile_box.collision_layer = 2
	projectile_box.collision_mask = 2
	projectile_box.owner = get_tree().edited_scene_root
	frame_timer.owner = get_tree().edited_scene_root
	animation_tool.owner = get_tree().edited_scene_root
	print(get_children(true))
	print("added projectile_box")
	add_projectile_box_buttion = false
	set_frame_disabled(true)
	rename_all_children()

##adds hurt box to secene tree
func add_new_hurt_box(): 
	var hurt_box: HurtBoxArea = HurtBoxArea.new()
	add_child(hurt_box) 
	hurt_box.collision_layer = 2
	hurt_box.collision_mask = 0
	hurt_box.owner = get_tree().edited_scene_root
	print(get_children(true))
	print("added end frame")
	add_hurt_box_buttion = false
	set_frame_disabled(true)
	rename_all_children()

## adds a Sprite2D to the scene tree hidden by default to match frame disabled state
func add_new_sprite():
	var sprite: Sprite2D = Sprite2D.new()
	add_child(sprite)
	sprite.owner = get_tree().edited_scene_root
	sprites_array.append(sprite)
	print(get_children(true))
	print("added sprite")
	add_sprite_button = false
	rename_all_children()


## removes all child frames HitBoxArea and HurtBoxArea
func clear_all_frames():
	for child in get_children(true):
		if child is HitBoxArea or child is HurtBoxArea:
			remove_child(child)
	clear_frame_button1 = false
	clear_frame_button2 = false

## renames all child frames HitBoxArea and HurtBoxArea 
## has nameing sceme to separte for a function used in code 
## 1xx is hit box 2xx is projectile box 3xx is hurt box 4xx is sprite
func rename_all_children():
	for child in get_children():
		if child is HitBoxArea:
			child.name = "hit_box # 100"
		if child is HurtBoxArea:
			child.name = "hurt_box # 300"
		if child is ProjectileArea:
			child.name = "Projectile # 200"
		if child is Sprite2D:
			child.name = "Sprite2D # 400"
	for child in get_children():
		move_child(child, child.name.to_int()%100-1)
	fix_names_buttion = false

## runs the buttions
func _physics_process(_delta):
	if Engine.is_editor_hint():
		if add_hit_box_buttion: add_new_hit_box()
		if add_projectile_box_buttion: add_new_projectile_box()
		if add_hurt_box_buttion: add_new_hurt_box()
		if add_sprite_button: add_new_sprite()
		if fix_names_buttion: rename_all_children()
		if clear_frame_button1 and clear_frame_button2: clear_all_frames()
		if toggle_visable_buttion: 
			toggle_this_frames_boxes()
			toggle_visable_buttion=false
	else: pass
