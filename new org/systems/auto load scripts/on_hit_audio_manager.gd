extends Node
#TODO make sure audo has a range
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func play_hit_sound(hit_sound: AudioStream):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = hit_sound
	player.bus = "SFX"
	player.play()
	player.finished.connect(player.queue_free)
	# alterante sound on hit mute and unmute 
	#AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), !AudioServer.is_bus_mute(AudioServer.get_bus_index("SFX")))
