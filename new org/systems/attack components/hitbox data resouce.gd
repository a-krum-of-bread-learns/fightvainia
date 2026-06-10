##has all of the imparant data for an attack usaly for a spasific hit box not a full attack
@tool
class_name HitBoxData extends Resource
@export_enum("error:-1","BASIC:0", "DEFUALT_KNOCK_DOWN", "DEFUALT_LAUNCH", "DEFUALT_AIR", "ANIMATION/GRAB") var stun_type: int = -1:
	set(value):
		stun_type = value
		notify_property_list_changed()
@export_enum("error:-1","Low:1","MID:2","OVERHEAD:3") var hit_type: int = -1
enum HIT_TYPE {LOW=1, MID=2, OVER=3}
@export_range(-1, 300) var block_stun_duration: int = -1
@export_range(-1, 300) var block_back_distance: float = -1
@export_range(-1, 300) var hit_stun_duration: int = -1
@export var hit_back_distance_vector: Vector2 = Vector2(-1,-1)
@export_range(0,100) var hit_stop_frames: int = 0
@export_range(-1,1000) var damage: int = -1
@export var stun_away: bool = true
@export var air_stun_overide: bool = false

func _validate_property(property: Dictionary) -> void:
	if property.name in ["hit_stun_duration", "hit_back_distance_vector"] and stun_type in [1, 2, 3]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
