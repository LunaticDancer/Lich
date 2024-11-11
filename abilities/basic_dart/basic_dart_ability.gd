extends Ability

var player
var projectile = preload("res://abilities/basic_dart/basic_dart_projectile.tscn")

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func on_activated():
	var instance = projectile.instantiate()
	instance.global_position = player.global_position + player.get_local_mouse_position().normalized() * 8
	instance.set_direction(player.get_local_mouse_position().normalized())
	player.add_sibling(instance)
