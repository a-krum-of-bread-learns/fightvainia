class_name hurtboxmini extends Area2D
@export var player: CharacterBody2D

func _ready() -> void:
	collision_layer = 8
