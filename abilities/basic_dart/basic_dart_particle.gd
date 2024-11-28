extends Node2D

@export var speed = 40
@export var disappear_speed = 1
var progress = 0
var direction = Vector2.ZERO

func _ready():
	$AnimatedSprite2D.frame = randi_range(0, 4)
	direction = Vector2.from_angle(randf_range(0, 360)).normalized()

func _process(delta):
	global_position += direction * speed * delta
	progress += disappear_speed * delta
	$AnimatedSprite2D.material.set_shader_parameter("intensity", progress)
	if(progress > 1):
		queue_free()
	
