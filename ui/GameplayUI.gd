extends Control

func update_dashes(amount : float):
	$Dashes/Left.hide()
	$Dashes/Right.hide()
	if(amount >= 1):
		$Dashes/Left.show()
	if(amount >= 2):
		$Dashes/Right.show()

func update_mana(amount : float):
	$Mana/Fill.material.set_shader_parameter("fill", amount)
	$Mana/Surface.position = Vector2(0, lerpf(120, -8, amount))
	$Mana/Surface.scale = Vector2.ONE * sqrt(sin(amount * PI))
