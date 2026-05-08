extends ActiveHitBox
@export var max_lifespan_in_frames: int
@export var is_facing_right: bool
@export var timer: FrameTimer
@export var disappear_on_hit: bool:
	set(value):
		disappear_on_hit = value
		notify_property_list_changed()
@export var hit_to_disappear: int
# animation stuff
@export var animation_stuff: Array[AnimationResource]
signal animate(is_facing_right: bool, animation_stuff: Array[AnimationResource])


func _validate_property(property: Dictionary) -> void:
	if property.name in ["hit_to_disappear"] and not disappear_on_hit:
		property.usage = PROPERTY_USAGE_NO_EDITOR

func _ready():
	super._ready()
	timer.start_frame_timer(max_lifespan_in_frames)
	animate.emit(is_facing_right,animation_stuff)

func lifespan_check():
	if timer.is_stoped():
		self.queue_free()

func _process(_delta):
	lifespan_check()
