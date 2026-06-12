class_name BossSettings extends Resource
@export_group("settings")
@export_subgroup("main settings")
@export var self_enabled: bool = true
@export var spacing_tolerance: float = 5.0
@export var walk_speed: float = 50.0
@export var run_speed: float = 200.0
@export var close_range_max_x: float = 100
@export var mid_range_max_x: float = 200
@export var far_range_max_x: float = 300
@export var anti_air_delta_min_y: float = -25
@export var anti_air_delta_max_y: float = -80
@export_subgroup("chance settings")
@export_range(0,1,.01) var attack_chance: float = .02 # at 0.02 its roughly 1 attack a second
@export_range(0,100,1) var hits_until_10_percent_drop_chance: int = 1 
@export_range(0,1,.01) var block_chance: float = .25
@export_range(0,1,.01) var corect_block_type_chance: float = .25
@export_range(0,1,.01) var wiff_chance: float = 1
@export_range(0,1,.01) var anti_air_chance: float = .33
@export_range(0,1,.01) var poke_chance: =.02
@export_range(0,1,.01) var ignore_tolrance_chance: =.07
@export_range(0,1,.01) var pause_chance: = .33

func calc_drop_chance():
	if hits_until_10_percent_drop_chance == 0:
		return 0
	return 1-pow(.9,1./hits_until_10_percent_drop_chance)
	
	
