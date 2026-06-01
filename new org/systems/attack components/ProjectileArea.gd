@tool
class_name ProjectileArea extends HitBoxArea
@export var timer: FrameTimer
@export var attached_to_entity: bool
@export var max_lifespan_in_frames: int
@export var respawns: bool = false
@onready var previous_facing_right: bool = attack_manager.host.is_facing_right
var stay_on_right: bool #TODO use this to make a fix for the side swap porblem 
var is_active_previous: bool
var is_active: bool = false
var boxes: Array[CollisionShape2D]
#FIXME 1 frame is disaled on projectile start up witch shouldent happen 
@export var add_sprite_button: bool = false ## adds a Sprite2D to the frame
var sprites_array: Array[Sprite2D]
# animation stuff
@export var animation_stuff: Array[AnimationResource]
signal start_animation(is_facing_right: bool, animation_stuff: Array[AnimationResource])



func _ready():
	for child in get_children():
		if child is CollisionShape2D: boxes.append(child)
	super._ready()
	if attached_to_entity: top_level = false
	else: top_level = true
	if start_animation.has_connections() == false:
		push_error("signal animate not conected to an animation too for " +str(get_parent().name) + " in " +str(get_parent().get_parent().name))
	for node in get_children():
		if node is Sprite2D:
			if Engine.is_editor_hint():
				node.visible = true
			else: node.visible = false
			sprites_array.append(node)
	if animation_stuff.is_empty():
		push_error("ProjectileArea: animation_stuff is empty on " +str(get_parent().name) + " in " +str(get_parent().get_parent().name) + ", projectile will not move")
	if timer == null:
		push_error("ProjectileArea: timer not assigned on " + str(get_parent().name) + " in " +str(get_parent().get_parent().name))


func reset_postion_detached():
	self.global_position = attack_manager.global_position 
	if attached_to_entity or attack_manager.host.is_facing_right: 
		self.scale = Vector2.ONE
	elif not attack_manager.host.is_facing_right: 
		self.scale = Vector2(-1,1)
	
#FIXME when attached to entiy projectile flips when it may not make sense depending on how move is imagened 
func enable_disable_boxes():
	if is_active == true:
		for box in boxes:
			box.disabled = false
		for sprite in sprites_array:
			sprite.visible = true
	elif is_active == false:
		for box in boxes:
			box.disabled = true
		for sprite in sprites_array:
			sprite.visible = false
	

func lifespan_check():
	if is_active == true and is_active_changed():
		timer.start_frame_timer(max_lifespan_in_frames)
		start_animation.emit(attack_manager.host.is_facing_right,animation_stuff)
	elif timer.is_stoped():
		reset_postion_detached()
		timer.reset()
		is_active = false
	

func is_active_changed()->bool:
	if is_active == is_active_previous:
		is_active_previous = is_active
		return false
	else: 
		is_active_previous = is_active
		return true
## adds a Sprite2D to the scene tree hidden by default to match frame disabled state

func add_new_sprite():
	var sprite: Sprite2D = Sprite2D.new()
	add_child(sprite)
	sprite.owner = get_tree().edited_scene_root
	sprites_array.append(sprite)
	print(get_children(true))
	print("added sprite")
	add_sprite_button = false
	
	
func _process(_delta):
	if Engine.is_editor_hint(): 
		if add_sprite_button: add_new_sprite()
	else:
		lifespan_check()
		enable_disable_boxes()
		is_active_changed()
		

	
		
		
		
