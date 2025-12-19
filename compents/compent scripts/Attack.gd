## this script contorls the adding of frames in the scene tree this is mostly a just tool script 
@tool
class_name Attack extends Node2D
#this is kidna broken but not realy
#@export_tool_button("add_framesss") var frameadd = add_new_end_frame
## tool buttions 
@export_category("tool buttons")
@export var add_end_frame_button: bool = false## tool buttions 
@export var fix_names_buttion: bool = false## tool buttions 
@export var reset_visable_disabled_buttion: bool = false## tool buttions 
@export var clear_frames_button1: bool = false## tool buttions 
@export var clear_frames_button2: bool = false## tool buttions 


##stuff for combo attacks
@export_category("combo attacks stuff")
enum attack_pad {LK=12,HK=16,EXK=13,LP=14,HP=18,EXP=17,LPK=11,HPK=19}
@export var combo_attacks_dictionary: Dictionary [attack_pad, Attack]
@export var is_combo_attack: bool = false
@export var start_frame: int
@export var end_frame: int
var can_combo: = false
@export_category("tweens")
@export var attack_animation: Array[AttackAnimationPart]

## these propertys are here for easy refence for the child and parent nodes 
## for there respective puropus 


var frames: Array[Frame] ## the list of frames as childern
var active_frame: int = 0 ## tracks the active frame

# combo attack will come out the frame after the start frame at the earleist 
# and at the latest right after the end frame
func set_can_combo():
	if active_frame == start_frame: 
		can_combo = true
	elif active_frame == end_frame + 1 or active_frame == 0 : #corection term of +1
		can_combo = false










##gets children to have a quic reffence 
func _ready():
	frames.clear()
	for frame in get_children():
		if frame is Frame:
			frames.append(frame)

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

## clears all frames (childeren)
func clear_all_frames():
	for child in get_children(true):
		if child is Frame:
			remove_child(child)
	clear_frames_button1 = false
	clear_frames_button2 = false
#TODO  make this line and others like it more readable get_parent().get_children():
##sets diabled values of the boxes to true for all frames
func reset_all_frames_boxes():
	for attacks in get_parent().get_children():
		for frame in attacks.get_children():
			for shape in frame.box_shapes:
				shape.disabled = true


##renames all frame so that each has a number 
func rename_all_frames():
	for frame in frames:
		var count: int = 1
		frame.name = "frame # " + str(count)
		count+=1
		
	for frame in frames:
		move_child(frame, frame.name.to_int()-1)
		
	fix_names_buttion = false
	
# main place to call functions here 
func _physics_process(_delta):
	if Engine.is_editor_hint():
		if add_end_frame_button: add_new_end_frame() 
		if clear_frames_button1 and clear_frames_button2: clear_all_frames()
		if fix_names_buttion: rename_all_frames()
		if reset_visable_disabled_buttion: 
			reset_all_frames_boxes()
			reset_visable_disabled_buttion = false
	else:
		if is_combo_attack:
			set_can_combo()
		pass
