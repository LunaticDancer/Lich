extends Area2D

@export var ability : PackedScene

func initiate(arg : PackedScene):
	ability = arg
	var opa = arg.instantiate()
	$Sprite2D.texture = opa.icon
	opa.queue_free()


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("Player"):
		get_tree().get_first_node_in_group("GameController").swap_ability(ability)
		queue_free()
