class_name CutsceneArea extends Area2D
#TODO disable a few otehr improtn nodes for the player
#TODO make an auto load scene witch seems to be posible cool
#TODO make into 2 parts
#TODO make diolog have a typewriter effect feture creep
var text_is_writing : bool
#TODO make a dialouge resource that takes strings and textures dor linerar flow of text 
@export var text: Array[String] =[
	"set of text 1 this fjfuiodsfniudnasfkndiuasbfyudba",
	"set of text 2 vkiomfdvjofdvdfnvdnsuicn",
	"set of text 3 asytvdatydvashbctasvcibysdvbtzuicybdsbyc"
	]
@export_group("not implemted yet")
@export var player_end_position: Vector2
@export var there_is_a_scene_change: bool
#TODO decide on how you want to disable the cutscenes quefree or disabling

signal cutscene_starting
signal cutscene_ending 

func _ready() -> void:
	body_entered.connect(start_cutscene)
	collision_mask = 2 # detect player body make sure body is corectly set



##starts cutscene is expexting enity base with colison layer 2 meaning a player
func start_cutscene(body):
	MenuControllerRoot.dialogue_menu.start_dialogue(text)
	MenuControllerRoot.open_menu(MenuControllerRoot.dialogue_menu)
	cutscene_starting.emit()
	(body as EntityBase).cutsecene_start()
	await MenuControllerRoot.dialogue_menu.dialogue_end
	end_cutscene(body)
		
func end_cutscene(body: EntityBase):
	body.cutsecene_end()
	cutscene_ending.emit()
	
		
		
		
		
