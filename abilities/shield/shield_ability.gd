extends Ability

var phylactery

func _ready():
	phylactery = get_tree().get_first_node_in_group("PlayerWeakpoint")

func on_activated():
	phylactery.activate_shield()

func on_deactivated():
	phylactery.deactivate_shield()
