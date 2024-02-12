extends Enemy

var target : Node2D
var speed = 100

func _ready():
	target = get_tree().get_first_node_in_group("PlayerWeakpoint")

func _process(delta):
	linear_velocity = (target.global_position - global_position).normalized() * (speed if hp > 0 else 0)
	$AnimatedSprite2D.scale = Vector2(1 if linear_velocity.x < 0 else -1 , 1)

func _on_animated_sprite_2d_animation_finished():
	if renderer.animation == "death":
		queue_free()

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("PlayerParriedAttack"):
		receive_damage(2)
	if body.is_in_group("Player"):
		body.receive_damage(5)
		renderer.play("death")
	if body.is_in_group("PlayerWeakpoint"):
		body.receive_damage()
		renderer.play("death")
