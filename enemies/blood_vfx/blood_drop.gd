extends Node2D

@export var splatter : PackedScene
var lifespan = 2
var base_speed = 500
var direction = Vector2.RIGHT
var max_height = -24
var timer = 0

func init(p_lifespan, p_direction, p_height):
	lifespan = p_lifespan
	max_height = p_height
	direction = p_direction * 3
	# random point in a unit circle for direction variance
	var angle = randf()
	var circle_point = Vector2(sin(angle), cos(angle)) * randf_range(0.3, 1.5)
	direction += circle_point

func _process(delta):
	position += direction * base_speed * delta
	timer += delta
	if timer > lifespan:
		land()
	var progress = sin(lerpf(0, PI / 2, timer/lifespan))
	$Droplet.position.y = lerpf(max_height, 0, progress)

func land():
	var obj = splatter.instantiate()
	obj.global_position = global_position
	add_sibling(obj)
	queue_free()
