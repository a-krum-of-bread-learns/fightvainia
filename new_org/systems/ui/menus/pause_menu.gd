extends MenuBase


func _on_settings_pressed() -> void:
	MenuControllerRoot.open_menu(MenuControllerRoot.settings_menu)


func _on_back_pressed() -> void:
	MenuControllerRoot.back_1_menu()
	pass # Replace with function body.
