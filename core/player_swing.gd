extends Node2D

var direction;
var active_frames = 2;

func set_direction(dir : float):
	direction = dir
	$Area2D.global_rotation = dir
	$SwingHolder.global_rotation = dir

func _physics_process(delta):
	active_frames -= 1
	if(active_frames == 0):
		$Area2D.hide()

func _on_area_2d_body_entered(body):
	if body is Enemy:
		body.receive_damage(1)
		body.bleed(Vector2(cos(direction), sin(direction)))

func _on_animated_sprite_2d_animation_finished():
	queue_free()
