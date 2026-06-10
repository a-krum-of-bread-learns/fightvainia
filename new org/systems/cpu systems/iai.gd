## Enemy AI with idle patrol and chase behaviour
## Enemies should be contained in boxes like in Guacamelee
## Does not use MoveList by design
class_name WolfCPU extends EnemyBase

enum STATE { WALKING, PAUSING, CHASING }
@export var timer: FrameTimer

@export_group("settings")
@export var walk_velocity_x: float = 100
@export_range(1, 9223372036854775807) var walk_time: int = 200
@export_range(1, 9223372036854775807) var pause_time: int = 30
@export var chase_velocity_x: float = 300
@export var chase_range: float = 2000
@export var attack_range: float = 100


var next_state: STATE =STATE.WALKING
var is_chasing: bool = false
var current_target: EntityBase

func _ready() -> void:
	for ray in rays:
		ray.hit_from_inside = true
	start_wait_state()
	
func start_wait_state():
	next_state = STATE.WALKING
	timer.start_frame_timer(pause_time)
	velocity.x = 0


func start_walk_state():
	is_facing_right = !is_facing_right
	next_state = STATE.PAUSING
	timer.start_frame_timer(walk_time)
	
	velocity.x = walk_velocity_x if is_facing_right else -walk_velocity_x
	scale_component.set_scale(Scale.RIGHT if is_facing_right else Scale.LEFT)


func behaviour() -> void:
	match next_state:
		STATE.WALKING when timer.is_stoped():
			start_walk_state()
		STATE.PAUSING when timer.is_stoped():
			start_wait_state()
		STATE.CHASING:
			chase_state()
		_: pass

func check_chase():
	for ray in rays:
		if ray.is_colliding() and ray.get_collider() is HurtBoxArea:
			current_target = (ray.get_collider() as HurtBoxArea).health.host
			is_chasing = true
			next_state = STATE.CHASING

# --- chase ---
func chase_state() -> void:
	var delta: Vector2 = self.global_position - current_target.global_position
	is_facing_right = delta.x < 0
	scale_component.set_scale(Scale.RIGHT if is_facing_right else Scale.LEFT)
	velocity.x = chase_velocity_x * -sign(delta.x)
	if attack_range >= abs(delta.x): 
		start_attack_check(combo_0_attacks)

	if abs(delta.x) >= chase_range:
		is_chasing = false
		current_target = null
		next_state = STATE.PAUSING
		return


# --- attacks ---

func start_attack_check(combo_attacks: Array):
	if attack_manager.is_attacking == false:
		current_attack_index = 0
		for ray in rays:
			if ray.is_colliding() and timer.is_stoped(): 
				timer.start_frame_timer(minimum_time_before_attacks_in_frames)
				velocity.x = 0
			elif ray.is_colliding():
				velocity.x = 0
				attack_manager.start_attack(combo_attacks[current_attack_index])
	else: 
		if combo_attacks[current_attack_index].has_hit and combo_attacks[current_attack_index].can_combo:
			current_attack_index += 1
			attack_manager.start_attack(combo_attacks[current_attack_index])
			

func _physics_process(_delta: float) -> void:
	check_chase()
	behaviour()
	move_and_slide()
