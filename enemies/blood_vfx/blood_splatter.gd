extends AnimatedSprite2D

var is_disappearing = false
var progress = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(9)
	frame = randi_range(0, 3)

func _process(delta):
	if is_disappearing:
		progress += delta / 2
		if progress > 1:
			queue_free()
		material.set_shader_parameter("intensity", progress)

func _on_timer_timeout():
	is_disappearing = true
