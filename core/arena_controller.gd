extends Node2D

@export var enemies : Array[PackedScene]
var spawn_range

func _ready():
	var screenResolution = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height"))
	spawn_range = sqrt( (screenResolution.x * screenResolution.x) + (screenResolution.y * screenResolution.y) ) / 2
	print_debug(spawn_range)

func _on_spawn_timer_timeout():
	spawn_random()
	$SpawnTimer.start(randf_range(1.4,2.1))

func spawn_random():
	var dir = randf() * 360
	var spawn_position = Vector2(cos(dir) * spawn_range, sin(dir) * spawn_range)
	var enemy = enemies.pick_random().instantiate()
	enemy.global_position = $Lich.global_position + spawn_position
	add_child(enemy)
