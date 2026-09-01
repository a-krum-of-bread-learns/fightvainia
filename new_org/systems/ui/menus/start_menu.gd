##start menu
extends MenuBase
#var test_scene: PackedScene

func _ready():
	defult_focus.grab_focus()
	#test_scene = preload("res://testings/testing.tscn") # to be changed

func _on_exit_game_pressed() -> void:
	get_tree().quit()
	pass 

func _on_new_game_pressed() -> void:
	#test_scene.instantiate()
	#get_tree().change_scene_to_packed(test_scene)
	MenuControllerRoot.back_1_menu()
	MenuControllerRoot.curret_game_state = MenuControllerRoot.GameState.GAME_PLAY
	
	#if there is a game ask conformation 
		#get_tree().paused = false

func _on_settings_pressed() -> void:
	MenuControllerRoot.open_menu(MenuControllerRoot.settings_menu)
