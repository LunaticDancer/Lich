extends RigidBody2D
class_name Enemy

@export var renderer : AnimatedSprite2D
@export var hp = 1
@export var points_value = 100
@export var blood_drop : PackedScene
@export var blood_per_hit = 3
var invulnerable = false

func bleed(direction):
	for n in blood_per_hit:
		var drop = blood_drop.instantiate()
		drop.init(randf_range(0.02,0.2), direction, -24)
		drop.global_position = global_position
		add_sibling(drop)

func receive_damage(amount : int):
	if invulnerable:
		return
	
	hp -= amount
	if hp <= 0:
		get_tree().get_first_node_in_group("GameController").enemy_killed(points_value)
		renderer.play("death")
