## shows stuns but viusal
class_name BaseSpriteManager extends Sprite2D
@export var stun_manager: StunManager

func _ready():
	stun_manager.stun_has_started.connect(_on_stun_started)
	stun_manager.stun_has_ended.connect(_on_stun_ended)

func _on_stun_started(stun_type: int):
	match stun_type:
		StunManager.STUN_TYPE.BLOCK:
			self.modulate = Color(1, 1, 0, 1)
		_:
			self.modulate = Color(1, 0, 0, 1)

func _on_stun_ended():
		self.modulate = Color(1, 1, 1, 1)
