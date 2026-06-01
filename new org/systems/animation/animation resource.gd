## the smothing curces should be treadis difrently for the entitys when thery 
##have their velocity changed and for the projectiles when they have their 
##posion changed
## this resurces holds the smothing of the animations and helper funtions
## you need to manualy set the dispacment for the x and y seprately then you can
## chose to smoothing using teh curves taht the highet of the cuve reperestes 
## the % of total dipalcment vs the width witch is % of total frames 
class_name AnimationResource extends Resource
@export var smoothing_curve_x: Curve = null ## y compnent of Curve is % postion of the animation and the x is the % total frames
@export var smoothing_curve_y: Curve = null ## y compnent of Curve is % postion of the animation and the x is the % total frames
@export var time_in_frames: int = 30
@export var displacement: Vector2 
var corection_x: float
var corection_y: float

func get_corection(smoothing_curve: Curve, corection: float) -> float:
	if smoothing_curve == null:
		print("called")
		corection = 1
	else:
		var sum: float = 0
		for point in float(time_in_frames):
			sum += smoothing_curve.sample(point/time_in_frames)
		if time_in_frames%2 == 1:
			corection = sum/(time_in_frames)
		else: corection = sum/(time_in_frames)
		print("corection " +str(corection))
		if corection == 0:
			push_error("anmation curve area is equal to zero adjust it")
	return corection
		
		
func get_time()-> float:
	return time_in_frames/60.0
	
func get_velocty_x(is_facing_right: bool) -> float:
	if smoothing_curve_x == null:
		push_error("AnimationResource: smoothing_curve_x not assigned")
		return 0.0
	if get_time() == 0:
		push_error("AnimationResource: time_in_frames is 0, will cause division by zero")
		return 0.0
	
	if displacement.x/get_time()/get_corection(smoothing_curve_x,corection_x) == INF or displacement.x/get_time()/get_corection(smoothing_curve_x,corection_x) == NAN:
		push_error("NAN or infity velocity edit the curves")
		return 0.0
		
	if is_facing_right:
		return displacement.x/get_time()/get_corection(smoothing_curve_x,corection_x)     				#buggy line
	elif is_facing_right == false:
		return (displacement.x*-1)/get_time()/get_corection(smoothing_curve_x,corection_x)
	else:
		push_error("tweens are not working find the error")
		return 0


func get_velocty_y() -> float:
	if smoothing_curve_y == null:
		push_error("AnimationResource: smoothing_curve_y not assigned")
		return 0.0
		
	if displacement.y/get_time()/get_corection(smoothing_curve_y,corection_y) == INF or displacement.y/get_time()/get_corection(smoothing_curve_y,corection_y) == NAN:
		push_error("NAN or infity velocity edit the curves")
		return 0.0
	return displacement.y/get_time()/get_corection(smoothing_curve_y,corection_y)    
