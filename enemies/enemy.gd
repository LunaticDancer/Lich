extends RigidBody2D
class_name Enemy

@export var renderer : AnimatedSprite2D
@export var hp = 1
@export var points_value = 100
var invulnerable = false

func receive_damage(amount : int):
	if invulnerable:
		return
	
	hp -= amount
	get_tree().get_first_node_in_group("GameController").enemy_killed(points_value)
	renderer.play("death")
