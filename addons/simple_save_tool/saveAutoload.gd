@tool
extends EditorPlugin


func _enable_plugin() -> void:
	add_autoload_singleton("SAVE_MANAGER", "res://addons/simple_save_tool/tool/saveManager.gd")
	pass


func _disable_plugin() -> void:
	remove_autoload_singleton("SAVE_MANAGER")
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
