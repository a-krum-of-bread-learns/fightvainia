extends Node2D
@export var heal_area: HealBoxArea
@export var player: EntityBase ## not this is for testing
# static variables might be useful 

func _ready() -> void:
	SAVE_MANAGER.debugging(true)
	heal_area.body_entered.connect(start_save)
	#SAVE_MANAGER.data_is_saving.connect()
	#SAVE_MANAGER.data_was_loaded.connect()
	

	
func start_save(body:CharacterBody2D):
	if not (body is EntityBase):
		return
	if not (body.control_node is InputManager):
		return
	#SAVE_MANAGER.set_data("secene number", 1)
	SAVE_MANAGER.set_data("player_global_position", body.global_position)
	await SAVE_MANAGER.save_data()
	
func start_load(body:CharacterBody2D):
	if not (body is EntityBase):
		return
	if not (body.control_node is InputManager):
		return
	#SAVE_MANAGER.set_data("secene number", 1)
	await SAVE_MANAGER.load_data()
	body.global_position = SAVE_MANAGER.get_data("player_global_position", Vector2(0,-10))
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		print("manual save triggered")
		start_save(player)

	if Input.is_action_just_pressed("load"):
		print("manual load triggered")
		start_load(player)



"""
how do i want to stucture saves 

first thing save_manger is a gloabl so any thing can access it indepenatly to save and load its own data meaning
a player can set and load its own posion 
a scene can save and load its own state (if walls are broken or not)
each peice of data can be updated using set data (note this doesnt cause a save )
a full save can be made using save_data witch saves all values in a file 
loads work similar to saves

to remove relaince on using defalts for the load value i could make a defualt save file that is blank
can have more than 1 save slot and can deleat slots too

a player would need to set its posion when a save is called unless its save by the check point using its check point to save the player posion
an key item (attacks) would save if its attached to a player 
a check point would triger a global save
an inventory would need to save all the things in the invtory n/a

an enemy or boss (if there is a spwan detection range) may need a is dead persitance key
a wall would need if it has been destoryed 
a cutsecen would need to know if it has been run

there can be more than 1 save file based on a nameing scememe 
layer 1 the save slots
layer 2 secne name


what triger saves: save/check point, save menu, auto saves, some cutsences 

how do we load the scene in a way properly or a hard load reset
1. we load the full sence 
2. we check the save file for imprtnt keys then update all those things to match that key
3. we finish loading and enable the player and stuff 

"""
