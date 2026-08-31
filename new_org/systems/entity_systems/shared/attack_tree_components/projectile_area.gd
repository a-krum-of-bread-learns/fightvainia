## Extends [HitBoxArea] for hitboxes that persist beyond their spawning [Frame] — projectiles.
##
## Recommended to add via [Frame]'s add-projectile tool button rather than manually, since
## it wires up the required children automatically.[br]
## [member attached_to_entity] controls lifecycle: true means it behaves like a normal
## attached hitbox, following [Frame]/[Attack] timing and the entity's transform. False
## means it detaches on activation ([member top_level] is set true) and manages its own
## enable/disable state via [member is_active] until [member max_lifespan_in_frames] expires
## or it's manually reset.[br]
## [b]Known issue:[/b] a detached projectile's boxes can be disabled for one frame by its
## parent [Frame] advancing past it, before this class's own logic re-enables them.
@tool
class_name ProjectileArea extends HitBoxArea
@export var timer: FrameTimer
@export var attached_to_entity: bool
@export var max_lifespan_in_frames: int
@export var respawns: bool = false
@onready var previous_facing_right: bool = attack_manager.host.is_facing_right
var animation_tool: AnimationTool
var stay_on_right: bool #TODO use this to make a fix for the side swap porblem 
var is_active_previous: bool
var is_active: bool = false
var boxes: Array[CollisionShape2D]
@export var add_sprite_button: bool = false ## adds a Sprite2D to the frame
var sprites_array: Array[Sprite2D]
# animation stuff
@export var animation_stuff: Array[AnimationResource]




func _ready():
	for child in get_children():
		if child is CollisionShape2D: boxes.append(child)
		if child is AnimationTool: animation_tool = child
	super._ready()
	if attached_to_entity: top_level = false
	else: top_level = true
	for node in get_children():
		if node is Sprite2D:
			if Engine.is_editor_hint():
				node.visible = true
			else: node.visible = false
			sprites_array.append(node)
	if animation_stuff.is_empty():
		push_warning("ProjectileArea: animation_stuff is empty on " +str(get_parent().name) + " in " +str(get_parent().get_parent().name) + ", projectile will not move")
	if timer == null:
		push_error("ProjectileArea: timer not assigned on " + str(get_parent().name) + " in " +str(get_parent().get_parent().name))
	
	if max_lifespan_in_frames == 0: 
		if get_parent() is Frame: max_lifespan_in_frames=(get_parent() as Frame).repeat_this_frame+1
	
	

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
			box.visible = true
		for sprite in sprites_array:
			sprite.visible = true
	elif is_active == false:
		for box in boxes:
			box.disabled = true
			box.visible = false
		for sprite in sprites_array:
			sprite.visible = false
	

func lifespan_check():
	if is_active == true and is_active_changed():
		timer.start_frame_timer(max_lifespan_in_frames)
		animation_tool.animate(attack_manager.host.is_facing_right,animation_stuff,false,false,false,false)
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
	
	
func _physics_process(_delta):
	if Engine.is_editor_hint(): 
		if add_sprite_button: add_new_sprite()
	else:
		lifespan_check()
		enable_disable_boxes()
		is_active_changed()
		

	
		
		
		
