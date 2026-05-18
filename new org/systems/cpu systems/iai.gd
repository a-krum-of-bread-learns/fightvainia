## Enemy AI with idle patrol and chase behaviour
## Enemies should be contained in boxes like in Guacamelee
## Does not use MoveList by design
class_name EnemyBase extends EntityBase

enum IdleState { WALKING, PAUSING }

@export_group("components")
@export var rays: Array[RayCast2D]
@export var attack_manager: AttackManager
@export var scale_component: Scale
@export var timer: FrameTimer

@export_group("attack settings")
@export_range(1, 9223372036854775807) var minimum_time_before_attacks_in_frames: int = 60
@export var combo_1_attacks: Array[Attack]

@export_group("idle patrol settings")
@export var walk_velocity_x: float = 100
@export_range(1, 9223372036854775807) var walk_time: int = 200
@export_range(1, 9223372036854775807) var pause_time: int = 30

@export_group("chase settings")
@export var chase_velocity_x: float = 300
@export var chase_range: float = 2000

var idle_state: IdleState = IdleState.WALKING
var current_attack_index: int = 0
var thing_to_chase: EntityBase
var is_chasing: bool = false


func _ready() -> void:
	for ray in rays:
		ray.hit_from_inside = true
	_start_walking()


# --- idle patrol ---

func _start_walking() -> void:
	idle_state = IdleState.WALKING
	timer.start_frame_timer(walk_time)
	if is_facing_right: velocity.x = walk_velocity_x 
	else:velocity.x = -walk_velocity_x
	_update_scale()

func _start_pausing() -> void:
	idle_state = IdleState.PAUSING
	timer.start_frame_timer(pause_time)
	velocity.x = 0

func _flip_direction() -> void:
	is_facing_right = !is_facing_right
	_update_scale()

func _update_scale() -> void:
	scale_component.set_scale(Vector2(1, 1) if is_facing_right else Vector2(-1, 1))

func idle_behaviour() -> void:
	if not timer.is_stoped():
		return
	match idle_state:
		IdleState.WALKING:
			_start_pausing()
		IdleState.PAUSING:
			_flip_direction()
			_start_walking()


# --- chase ---

func chase_behaviour() -> void:
	for ray in rays:
		if ray.is_colliding() and ray.get_collider() is HurtBoxArea:
			thing_to_chase = (ray.get_collider() as HurtBoxArea).health.host
			is_chasing = true

	if not thing_to_chase or not is_chasing:
		return

	var delta: Vector2 = self.global_position - thing_to_chase.global_position
	if abs(delta.x) >= chase_range:
		is_chasing = false
		return

	is_facing_right = delta.x < 0
	_update_scale()
	velocity.x = chase_velocity_x * -sign(delta.x)


# --- attacks ---

func when_to_attack(combo_attacks: Array):
	if attack_manager.is_attacking == false:
		current_attack_index = 0
		for ray in rays:
			if ray.is_colliding() and timer.is_stoped(): 
				timer.start_frame_timer(minimum_time_before_attacks_in_frames)
			elif ray.is_colliding():
				attack_manager.start_attack(combo_attacks[current_attack_index])
	else: 
		if combo_attacks[current_attack_index].has_hit and combo_attacks[current_attack_index].can_combo:
			current_attack_index += 1
			attack_manager.start_attack(combo_attacks[current_attack_index])
			



func _physics_process(_delta: float) -> void:
	chase_behaviour()
	when_to_attack(combo_1_attacks)
	if not attack_manager.is_attacking and not is_chasing:
		idle_behaviour()
	move_and_slide()
