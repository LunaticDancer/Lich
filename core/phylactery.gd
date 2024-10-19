extends StaticBody2D

var hp = 3
var invulnerable = false

func _ready():
	hp = 3

func heal():
	hp = min(3, hp+1)
	update_hp_display()

func receive_damage():
	if invulnerable:
		return
	
	hp-=1
	update_hp_display()
	if hp <= 0:
		get_tree().get_first_node_in_group("GameController").game_over()

func update_hp_display():
	if hp >= 1:
		$"HpDisplay/1".show()
	else:
		$"HpDisplay/1".hide()
		
	if hp >= 2:
		$"HpDisplay/2".show()
	else:
		$"HpDisplay/2".hide()
		
	if hp >= 3:
		$"HpDisplay/3".show()
	else:
		$"HpDisplay/3".hide()

func activate_shield():
	invulnerable = true
	$ShieldEffect.show()
	
func deactivate_shield():
	invulnerable = false
	$ShieldEffect.hide()
