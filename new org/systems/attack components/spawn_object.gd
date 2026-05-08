## SpawnObject
## A general purpose spawner that manages a pool of spawned objects.
## Supports both player input triggered spawning and turret style repeated spawning
## when driven by an external timer or signal.
##
## Usage:
## - Assign [thing_to_spawn] in the inspector
## - Connect an external signal or call [spawn] directly
## - Set [max_alowed_to_exist] to control how many can exist at once
## - Enable [overwrite_on_max] to replace the oldest object when the cap is reached if this is desired
##
## Note: Spawned objects are responsible for their own despawning via queue_free()
class_name SpawnObject extends Node2D
@export var thing_to_spawn: PackedScene
@export var max_alowed_to_exist: int = 5
@export var overwrite_on_max: bool = false
@export var position_offset: Vector2 = Vector2.ZERO
var spawned_objects: Array

func spawn(is_facing_right: bool): #conect to signal
	if thing_to_spawn == null:
		push_error("SpawnObject: thing_to_spawn is not assigned on " + name)
		return
	  # clean up any that already queue_freed themselves
	spawned_objects = spawned_objects.filter(func(obj): return is_instance_valid(obj))
	if spawned_objects.size() >= max_alowed_to_exist: 
		if overwrite_on_max:
			spawned_objects[0].queue_free()
			spawned_objects.remove_at(0)
		else: return
	var spawned = thing_to_spawn.instantiate()
	spawned_objects.append(spawned)
	self.add_child(spawned)
	(spawned as Node2D).top_level = true
	(spawned as Node2D).global_position = self.global_position + Vector2(position_offset.x*(int(is_facing_right)*2-1), position_offset.y)
	
