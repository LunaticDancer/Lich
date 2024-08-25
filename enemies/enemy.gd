extends RigidBody2D
class_name Enemy

@export var renderer : AnimatedSprite2D
@export var hp = 1
@export var points_value = 100
var blood_drop = preload("res://enemies/blood_vfx/blood_drop.tscn")
@export var blood_per_hit = 3
var ability_pick_up_scene = preload("res://abilities/ability_pick_up.tscn")
@export var ability_pool : Array[PackedScene]
@export var ability_drop_chance = 0		# percent
var invulnerable = false

func bleed(direction):
	for n in blood_per_hit:
		var drop = blood_drop.instantiate()
		drop.init(randf_range(0.02,0.2), direction, -24)
		drop.global_position = global_position
		add_sibling(drop)

func handle_ability_drop():
	if randf_range(1, 100) <= ability_drop_chance:
		var drop = ability_pick_up_scene.instantiate()
		drop.initiate(ability_pool.pick_random())
		drop.global_position = global_position
		add_sibling(drop)

func receive_damage(amount : int):
	if invulnerable:
		return
	
	hp -= amount
	if hp <= 0:
		handle_ability_drop()
		get_tree().get_first_node_in_group("GameController").enemy_killed(points_value)
		renderer.play("death")
