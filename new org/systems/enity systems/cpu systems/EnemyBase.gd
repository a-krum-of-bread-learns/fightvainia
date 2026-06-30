class_name EnemyBase extends EntityBase
@export_group("components")
@export var rays: Array[RayCast2D]
@export var settings: BossSettings

@export_group("timer")
@export var timer: FrameTimer
@export var humanize_time_in_frames: int = 0
@export var pause_time_in_frames: int = 0

@export_group("combos")
@export var close_bnb_combo: Array[Attack]
@export var close_bnb_low_combo: Array[Attack]
@export var close_pokes: Array[Attack]
@export var mid_pokes: Array[Attack]
@export var far_or_projectile_pokes: Array[Attack]
@export var anti_airs: Array[Attack]
var current_combo: Array[Attack]
var current_attack_index: int = 0
