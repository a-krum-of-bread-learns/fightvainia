## sets the auto loads
@tool
extends EditorPlugin
const FRAME_BY_FRAME_MODE = "FrameByFrameMode"
const ON_HIT_AUDIO_MANAGER = "OnHitAudioManager"
const HIT_STOP_AND_SHAKE = "HitStopAndShake"

func _enable_plugin():
	# The autoload can be a scene or script file.
	add_autoload_singleton(FRAME_BY_FRAME_MODE, "res://addons/fightvainia auto load loader/new org/systems/auto load scripts/frame by frame mode.gd")
	add_autoload_singleton(ON_HIT_AUDIO_MANAGER,"res://addons/fightvainia auto load loader/new org/systems/auto load scripts/on_hit_audio_manager.gd")
	add_autoload_singleton(HIT_STOP_AND_SHAKE,"res://addons/fightvainia auto load loader/new org/systems/auto load scripts/hit stop and shake.gd")

func _disable_plugin():
	remove_autoload_singleton(FRAME_BY_FRAME_MODE)
	remove_autoload_singleton(ON_HIT_AUDIO_MANAGER)
	remove_autoload_singleton(HIT_STOP_AND_SHAKE)
