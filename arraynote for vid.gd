# THE PROBLEM - both arrays point to the same memory
extends Node
var inputs_of_frame: Array[int] = [1, 10, 100]
var input_history: Array[Array] = []

func _ready():
	# like 2 frames
	input_history.append(inputs_of_frame)
	input_history.append(inputs_of_frame)  # same reference added twice

	print(input_history)  # [[1, 10, 100], [1, 10, 100]]
	# next frame
	inputs_of_frame.clear()
	inputs_of_frame.append(5)   # change one value in inner
	
	print(input_history)  # [[5], [5]] - BOTH changed
	Input.is_action_just_pressed("ui_up")
