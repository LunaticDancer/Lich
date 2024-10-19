extends Node
class_name Ability

@export var icon : Texture2D
@export var ability_name : String
@export var ability_description : String

@export var activation_cost : float
@export var sustain_cost : float

func on_activated():
	pass

func on_sustained(delta):
	pass

func on_deactivated():
	pass
