## this script contorls the adding of frames in the scene tree this is mostly a just tool script 
@tool
class_name Attack extends Node2D

## tool buttions 
@export_category("tool buttons")
#@export_tool_button("add_end_frame_button") var add_end_frame = add_new_end_frame change these later
@export var add_end_frame_button: bool = false## tool buttions 
@export var fix_names_buttion: bool = false## tool buttions 
@export var reset_visable_disabled_buttion: bool = false## tool buttions 
@export var clear_frames_button1: bool = false## tool buttions 
@export var clear_frames_button2: bool = false## tool buttions 
@export_category("attack properties")
@export var is_combo_attack: bool = false:
	set(value):
		is_combo_attack = value
		notify_property_list_changed()
@export var is_speical_cancelable: bool = false:
	set(value):
		is_speical_cancelable = value
		notify_property_list_changed()
#@export var is_hit_grab: bool
#FIXME 1 frame is disaled on projectile start up witch shouldent happen but is minor for now

##stuff for combo attacks
@export_subgroup("combo attacks stuff")
enum attack_pad {LK=12,HK=16,EXK=13,LP=14,HP=18,EXP=17,LPK=11,HPK=19}
@export var combo_attacks_dictionary: Dictionary [attack_pad, Attack]
@export var start_frame_combo: int
@export var end_frame_combo: int
var can_combo: = false

@export_subgroup("speical cancel stuff")
@export var start_frame_speical_cancel: int
@export var end_frame_speical_cancel: int
var can_speical_cancel: = false

@export_subgroup("hit grab stuff")


@export_subgroup("tweens stuff \\ animation")
@export var kill_momnetum_of_tween: bool  = false
@export var animation_stuff: Array[AnimationResource]


## these propertys are here for easy refence for the child and parent nodes 
## for there respective puropus 
var attack_manager: AttackManager = self.get_parent()
var frames: Array[Frame] ## the list of frames as childern with duplicates for full attack length. 
var active_frame: int = 0 ## tracks the active frame
var has_hit: bool = false




# combo attack will come out the frame after the start frame at the earleist 
# and at the latest right after the end frame
func set_can_combo():
	if active_frame == start_frame_combo: 
		can_combo = true
	elif active_frame == end_frame_combo + 1 or active_frame == 0 : #corection term of +1
		can_combo = false
	

func set_can_speical_cancel():
	if active_frame == start_frame_speical_cancel: 
		can_speical_cancel = true
	elif active_frame == end_frame_speical_cancel + 1 or active_frame == 0 : #corection term of +1
		can_speical_cancel = false

func reset():
	active_frame = 0 ## tracks the active frame
	can_speical_cancel = false
	can_combo = false
	has_hit = false




func _validate_property(property: Dictionary) -> void:
	if property.name in ["start_frame_combo", "end_frame_combo","combo_attacks_dictionary"] and not is_combo_attack:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["start_frame_speical_cancel", "end_frame_speical_cancel"] and not is_speical_cancelable:
		property.usage = PROPERTY_USAGE_NO_EDITOR


##gets children to have a quic reffence 
func _ready():
	frames.clear()
	for frame in get_children():
		if frame is Frame:
			for i in frame.repeat_this_frame:
				frames.append(frame)
			frames.append(frame)
	for value in combo_attacks_dictionary.values():
		if value == null:
			push_error("a combo attack is defined but it doesnt have an attack assigned for " + self.name)

	
##adds a new frame as a child of this node of classs Frame
func add_new_end_frame(): 
	var new_frame: Frame = Frame.new()
	add_child(new_frame) 
	#the new frame having its probetys set
	new_frame.owner = get_tree().edited_scene_root
	print(get_children(true))
	print("added end frame")
	add_end_frame_button = false
	_ready()
	rename_frames()
	

## clears all frames (childeren)
func clear_all_frames():
	for child in get_children(true):
		if child is Frame:
			remove_child(child)
	clear_frames_button1 = false
	clear_frames_button2 = false
	

##sets diabled values of the boxes to true for all frames of all attacks
func reset_all_frames_boxes():
	for attacks in attack_manager.get_children():
		for frame in attacks.get_children():
			for shape in frame.box_shapes:
				shape.disabled = true


##renames all frame so that each has a number 
func rename_frames():
	var count: int = 1
	fix_names_buttion = false
	for frame in get_children():
		frame.name = "frame # " + str(count)
		count+=1
	
	count = 1
	for frame in get_children():
		move_child(frame, frame.name.to_int()-1)
		frame.name = "frame # " + str(count) + "-" +str(count+(frame.repeat_this_frame))
		count = count +1  + frame.repeat_this_frame

# main place to call functions here 
func _physics_process(_delta):
	if Engine.is_editor_hint():
		if add_end_frame_button: add_new_end_frame() 
		if clear_frames_button1 and clear_frames_button2: clear_all_frames()
		if fix_names_buttion: rename_frames()
		if reset_visable_disabled_buttion: 
			reset_all_frames_boxes()
			reset_visable_disabled_buttion = false
	else:
		if is_combo_attack:
			set_can_combo()
		if is_speical_cancelable:
			set_can_speical_cancel()
			
		
