tweens have a smothing type 
curves can be renders and so can lines with addons or path nodes

without reset line and with bounce transion
0-15: 32, 9.988402
16 transiton to next animation part :85.33334, 9.988402
45 end: (182.0007, -41.67827)


with line and with bounce 
at 15 player postion (125.3333, 6.597311)
at 45 player postion (125.3333, -90.06937)


linaer with reset 
at 15 player postion (132.0, 9.9946)
at 45 player postion (132.0, -90.0692)



ineed to maek this its own node 

take in displacmets, time, curve 

caluated the time velocity and velocity croection term to make it change the postion overall

vellsocty is inivity now

need to do this part from scratch but with a clearer path


a node with the abitly to take in [[AnimationResource]] data and loops though it using tweens





script code stuff

```
@export var animation_stuff: Array[AnimationResource]
signal animate(is_facing_right: bool, animation_stuff: Array[AnimationResource])
func start_animation():
		animate.emit(true,animation_stuff)
```
