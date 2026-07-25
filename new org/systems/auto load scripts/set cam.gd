## Registers this camera with the [HitStop] autoload so hit stop effects
## (screen shake, freeze frames) can reference it.
extends Camera2D
func _ready(): HitStop.set_cam(self)
