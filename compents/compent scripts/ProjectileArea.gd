class_name ProjectileArea extends HitBoxArea
@export var speed_facing_right: Vector2  
@export var active_frames: int 
@export var timer: FrameTimer
@export var attached_to_entity: bool
@onready var previous_facing_right: bool = attack_manager.host.is_facing_right
var current_direction: Vector2
var is_active: bool = false
var boxes: Array[CollisionShape2D]


func _ready():
	for child in get_children():
		if child is CollisionShape2D: boxes.append(child)
	super._ready()
	if attached_to_entity: top_level = false
	else: top_level = true


func move(delta):
	if attached_to_entity:
		if previous_facing_right != attack_manager.host.is_facing_right:
			self.scale *=- 1
			self.position.x *=-1 
	self.global_position += current_direction * delta 

func reset_postion_detached():
	self.global_position = attack_manager.global_position 
	if attached_to_entity or attack_manager.host.is_facing_right: 
		self.scale = Vector2.ONE
	elif not attack_manager.host.is_facing_right: 
		self.scale = Vector2(-1,1)
		
func _process(delta):
	if is_active:
		move(delta)
		for box in boxes:
			box.disabled = false
		#timer ends
		if timer.is_stoped(): 
			is_active = false
			current_direction = Vector2.ZERO
			for box in boxes:
				box.disabled = true
				
	elif not is_active: 
		
		reset_postion_detached()
		
		timer.start_frame_timer(active_frames)
		for box in boxes:
			box.disabled = true
		if attack_manager.host.is_facing_right: 
			current_direction = speed_facing_right
		elif attack_manager.host.is_facing_right == false: 
			current_direction = Vector2(-1,1)*speed_facing_right
			
	previous_facing_right = attack_manager.host.is_facing_right
	
