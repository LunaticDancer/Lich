extends Control

func update_dashes(amount : float):
	$Dashes/Left.material.set_shader_parameter("intensity", 1-amount)
	$Dashes/Right.material.set_shader_parameter("intensity", 1-(amount-1))

func update_mana(amount : float):
	$Mana/Fill.material.set_shader_parameter("fill", amount)
	$Mana/Surface.position = Vector2(0, lerpf(120, -8, amount))
	$Mana/Surface.scale = Vector2.ONE * sqrt(sin(amount * PI))
