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
@export_range(-10000,1000) var damage: int = -1
@export var stun_away: bool = true
@export var air_stun_overide: bool = false
@export var hit_sound: AudioStream

func _validate_property(property: Dictionary) -> void:
	if (property.name in ["hit_stun_duration", "hit_back_distance_vector"] 
	and stun_type in 
	[StunManager.STUN_TYPE.DEFUALT_LAUNCH,
	StunManager.STUN_TYPE.DEFUALT_AIR,
	StunManager.STUN_TYPE.DEFUALT_KNOCK_DOWN]):
		property.usage = PROPERTY_USAGE_NO_EDITOR



func validate_data(owner) -> void:
	var context: String = str(owner.scene_file_path) + " | " + str(get_path())
	var required_fields := {
		"stun_type": stun_type == -1,
		"hit_type": hit_type == -1,
		"block_stun_duration": block_stun_duration == -1,
		"block_back_distance": block_back_distance == -1,
		"damage": damage == -1,
	}
	for field_name in required_fields:
		if required_fields[field_name]:
			push_error(field_name + " not assigned | " + context)
	if hit_stun_duration == -1 and not stun_type in [1,2,3]:
		push_error("hit_stun_duration not assigned | " + context)
	if (hit_back_distance_vector == Vector2(-1,-1)
	 and not stun_type in
	[StunManager.STUN_TYPE.DEFUALT_KNOCK_DOWN,
	StunManager.STUN_TYPE.DEFUALT_ON_FLOOR,
	StunManager.STUN_TYPE.DEFUALT_WAKEUP]):
		push_error("hit_back_distance_vector not assigned | " + context)
	if hit_stop_frames == 0:
		push_warning("hit_stop_frames is 0 | " + context)
