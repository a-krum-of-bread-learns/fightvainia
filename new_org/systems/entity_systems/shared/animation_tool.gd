## This is a helper node to animate a node's position or velocity so that it can move.
##
## This node creates a tween based on an array of [AnimationResource] provided to it by other nodes.
## The tween is created by tweening the x component then the y component, done with .parallel. The option for is_relative is available.
## When the thing to animate is an entity, it uses velocity to prevent clipping through walls, otherwise it uses position.
## When animating a projectile, checks if that projectile is attached — if attached, tweens local position (relative,
## following the entity); if detached, tweens global_position with direction_correction applied so
## displacement.x flips correctly based on which way the entity is facing. Both cases reset done by the projectile itself.
## all other nodes are just animated by global_position
class_name AnimationTool extends Node
@export var thing_to_animate: Node2D
var tween: Tween = null

func _tween_part(
		target: Object, 
		part: AnimationResource, 
		property_x: String, 
		property_y: String,
		value_x: float, 
		value_y: float, 
		is_relative: bool
	) -> void:
	var tween_x: PropertyTweener = tween.tween_property(target, property_x, value_x, part.get_time()) \
		.set_custom_interpolator(part.smoothing_curve_x.sample_baked)
	var tween_y: PropertyTweener = tween.parallel().tween_property(target, property_y, value_y, part.get_time()) \
		.set_custom_interpolator(part.smoothing_curve_y.sample_baked)
	if is_relative:
		tween_x.as_relative()
		tween_y.as_relative()



func animate(is_facing_right: bool, 
		animation_stuff: Array[AnimationResource], 
		kill_momentum_start: bool, 
		kill_momentum_end: bool,
		loops_times: int = 1,
	) -> void:
	
	if animation_stuff.is_empty():
		return
	if loops_times < 1:
		push_error("loop times is not set correctly, should be greater than or equal to 1")
		return

	if tween:
		tween.kill()
	tween = create_tween()

	for i in loops_times:
		if thing_to_animate is EntityBase:
			if kill_momentum_start:
				thing_to_animate.velocity = Vector2.ZERO
			for part in animation_stuff:
				_tween_part(thing_to_animate, part, "velocity:x", "velocity:y",
					part.get_velocty_x(is_facing_right), part.get_velocty_y(), false)
			if kill_momentum_end:
				tween.tween_property(thing_to_animate, "velocity", Vector2.ZERO, 0)

		elif thing_to_animate is ProjectileArea:
			var direction_correction: int = int(is_facing_right) * 2 - 1
			var attached: bool = (thing_to_animate as ProjectileArea).attached_to_entity
			var property_root: String = "position" if attached else "global_position"
			for part in animation_stuff:
				var x_value: float = part.displacement.x if attached else part.displacement.x * direction_correction
				_tween_part(thing_to_animate, part, property_root + ":x", property_root + ":y",
					x_value, part.displacement.y, true)
				# reset is done by the projectile

		else:
			for part in animation_stuff:
				_tween_part(thing_to_animate, part, "global_position:x", "global_position:y",
					part.displacement.x, part.displacement.y, true)
