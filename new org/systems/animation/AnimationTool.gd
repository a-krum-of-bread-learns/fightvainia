class_name AnimationTool extends Node
@export var thing_to_animate: Node2D
var test_proptery: Array[AnimationResource]
var tween: Tween = null


#TODO add a loop functionality 
#TODO change the hard oded sting values of veloscity and psoiton to a variable if posible 

## rset of tweens 
func tween_kill():
	if tween:
		tween.kill() # Abort the previous animation if ther was any .
	tween = create_tween()

##looping thight the animation resources and making them tween difrent small difrences for projectile and entitys
func animate(is_facing_right: bool, animation_stuff: Array[AnimationResource], loops_times:int = 1):
	#print(is_facing_right)
	#print(animation_stuff)
	tween_kill()
	#print(tween)
	if loops_times < 1:
		push_error("loop times is not set corectly should be greater than or equal to 1")
	
	
	
	for times in loops_times:
		if thing_to_animate is EntityBase:
			thing_to_animate.velocity = Vector2.ZERO
			for part in animation_stuff:
				tween.tween_property(thing_to_animate,"velocity:x",
					part.get_velocty_x(is_facing_right),
					part.get_time()).set_custom_interpolator(part.smoothing_curve_x.sample_baked)
				tween.parallel().tween_property(thing_to_animate,"velocity:y",
					part.get_velocty_y(),
					part.get_time()).set_custom_interpolator(part.smoothing_curve_y.sample_baked)
				tween.tween_property(thing_to_animate,"velocity", Vector2.ZERO, 0) # for har turns
				
		#TODO this needs a loot of work to work corectly? 
		elif thing_to_animate is ProjectileArea:
			var direction_corection: int = int(is_facing_right)*2-1 # only for the global case is it neeeded
			
			if (thing_to_animate as ProjectileArea).attached_to_entity:
				for part in animation_stuff:
					tween.tween_property(thing_to_animate,"position:x",
						part.displacement.x,
						part.get_time()).set_custom_interpolator(part.smoothing_curve_x.sample_baked).as_relative()
					tween.parallel().tween_property(thing_to_animate,"position:y",
						part.displacement.y,
						part.get_time()).set_custom_interpolator(part.smoothing_curve_y.sample_baked).as_relative()
						# reset is done by the projectile
			else:
				for part in animation_stuff:
					tween.tween_property(thing_to_animate,"global_position:x",
						part.displacement.x*direction_corection,
						part.get_time()).set_custom_interpolator(part.smoothing_curve_x.sample_baked).as_relative()
					tween.parallel().tween_property(thing_to_animate,"global_position:y",
						part.displacement.y,
						part.get_time()).set_custom_interpolator(part.smoothing_curve_y.sample_baked).as_relative()
						# reset is done by the projectile
		else:
			for part in animation_stuff:
				tween.tween_property(thing_to_animate,"global_position:x",
					part.displacement.x,
					part.get_time()).set_custom_interpolator(part.smoothing_curve_x.sample_baked).as_relative()
				tween.parallel().tween_property(thing_to_animate,"global_position:y",
					part.displacement.y,
					part.get_time()).set_custom_interpolator(part.smoothing_curve_y.sample_baked).as_relative()
					# reset is done by the projectile

	
	
