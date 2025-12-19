##has all of the imparant data for an attack usaly for a spasific hit box not a full attack
class_name HitBoxData extends Resource

@export_enum("error:-1","BASIC:0", "DEFUALT_KNOCK_DOWN", "DEFUALT_LAUNCH", "DEFUALT_AIR", "ANIMATION/GRAB") var stun_type: int = -1
@export_enum("error:-1","Low:1","MID:2","OVERHEAD:3") var hit_type: int = -1
enum HIT_TYPE {LOW=1, MID=2, OVER=3}
@export var block_stun_duration: int = -1
@export var block_back_distance: int = -1
@export var hit_stun_duration: int = -1
@export var hit_back_distance_vector: Vector2 = Vector2(-1,-1)
@export var hit_stop_frames: int = 0
@export var damage: int = -1 # chip is a percent of regular
@export var stun_away: bool = true # may be removed my not have any use
@export var air_stun_overide: bool = false
