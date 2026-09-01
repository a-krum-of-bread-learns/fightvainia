## sets the auto loads
@tool
extends EditorPlugin
const FRAME_BY_FRAME_MODE = "FrameByFrameMode"
const ON_HIT_AUDIO_MANAGER = "OnHitAudioManager"
const HIT_STOP_AND_SHAKE = "HitStopAndShake"
var main_path: String = "res://fightvania/new_org/systems/game_systems_and_auto_loads/"

func _enable_plugin():
	pass
	add_autoload_singleton(FRAME_BY_FRAME_MODE, main_path+"frame_by_frame_mode.gd")
	add_autoload_singleton(ON_HIT_AUDIO_MANAGER, main_path+"on_hit_audio_manager.gd")
	add_autoload_singleton(HIT_STOP_AND_SHAKE, main_path+"hit stop and shake.gd")

func _disable_plugin():
	pass
	remove_autoload_singleton(FRAME_BY_FRAME_MODE)
	remove_autoload_singleton(ON_HIT_AUDIO_MANAGER)
	remove_autoload_singleton(HIT_STOP_AND_SHAKE)
