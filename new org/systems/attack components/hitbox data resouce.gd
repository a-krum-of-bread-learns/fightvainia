##has all of the imparant data for an attack usaly for a spasific hit box not a full attack
@tool
class_name HitBoxData extends Resource
#FIXME make single source of trouth for this and stunn manger
@export var stun_type: StunManager.HIT_BOX_STUN_TYPE:
	set(value):
		stun_type = value
		notify_property_list_changed()
#FIXME make single source of trouth for this and blocking and hit type
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
@export var hit_sound: AudioStream

func _validate_property(property: Dictionary) -> void:
	if property.name in ["hit_stun_duration", "hit_back_distance_vector"] and stun_type in [1, 4]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
