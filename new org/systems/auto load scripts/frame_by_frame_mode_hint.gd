extends CanvasLayer

func _ready() -> void:
	self.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _process(_delta: float) -> void:
	self.visible = FrameByFrameMode.frame_by_frame_mode_endabled
		
