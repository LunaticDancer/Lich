extends Node2D

var direction;

func set_direction(dir : float):
	direction = dir
	$Area2D.global_rotation = dir
	$SwingHolder.global_rotation = dir

func _on_timer_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body is Enemy:
		body.receive_damage(1)
