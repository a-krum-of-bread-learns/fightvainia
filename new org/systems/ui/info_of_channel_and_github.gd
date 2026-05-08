extends CanvasLayer

func _ready() -> void:
	self.visible = false
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		self.visible = !self.visible
