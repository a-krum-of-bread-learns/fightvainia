class_name attackmini extends Node2D

var can_forced_follow_up: bool
@export var has_forced_follow_up: bool
@export var forced_follow_up_start: int
@export var forced_follow_up_end: int
@export var follow_up: attackmini
#region without follow ups
@export var is_multi_hit: bool
var attack_manager: attack_managermini = self.get_parent()
var frames: Array[framemini] ## the list of frames as childern with duplicates for full attack length. 
var active_frame: int = 0 ## tracks the active frame
var has_hit: bool = false

func _ready() -> void:
	frames.clear()
	for frame in get_children():
		if frame is framemini:
			for i in frame.repeat_this_frame:
				frames.append(frame)
			frames.append(frame)
		pass


func reset():
	active_frame = 0
	can_forced_follow_up = false
	has_hit = false
#endregion without follow ups

func _physics_process(_delta: float) -> void:
	if has_forced_follow_up: set_can_forced_follow_up()
	
func set_can_forced_follow_up():
	if active_frame >= forced_follow_up_start and  active_frame <= forced_follow_up_end:
		can_forced_follow_up = true 
	
