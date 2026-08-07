## A resource that holds player information regarding movement, and the info in [EntityStats].
##the defualts are bellow
class_name PlayerStats extends EntityStats
@export var prejump_frames: int = 4
@export var jump_velocityY: float =-350
@export var move_speed: float = 100
@export var dash_speed: int = 300
@export var air_acceleration: int = 10
@export var max_dash_duration_frames: int = 20
@export var run_speed: int = 0 ## unused in first game 
@export var c_timer_length: int = 6
@export var max_air_dash_count: int = 1
@export var max_air_jump_count: int = 0
