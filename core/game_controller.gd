extends Node2D

@export var play_area_scene : PackedScene

var hand_cursor = load("res://core/sprites/Cursor2.png")
var cross_cursor = load("res://core/sprites/Cursor1.png")

var play_area

# player resources
var dashes = 2.0
var mana = 0.0
var score = 0
var ability

# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	Input.set_custom_mouse_cursor(hand_cursor, Input.CURSOR_ARROW, Vector2(63,63))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_dash_regen(delta)

func handle_dash_regen(delta):
	dashes = min(dashes + delta, 2)
	$UI/GameplayUI.update_dashes(dashes)

func spend_dash():
	dashes -= 1
	$UI/GameplayUI.update_dashes(dashes)

func _on_play_pressed():
	$UI/MainMenu.hide()
	$UI/GameplayUI.show()
	play_area = play_area_scene.instantiate()
	Input.set_custom_mouse_cursor(cross_cursor, Input.CURSOR_ARROW, Vector2(63,63))
	init_player_resources()
	add_child(play_area)

func init_player_resources():
	dashes = 2
	mana = 0
	score = 0
	ability = null
	$UI/GameplayUI.update_dashes(dashes)
	$UI/GameplayUI.update_mana(mana/100.0)

func enemy_killed(score_value : int):
	score += score_value
	mana = min(mana + 10, 100)
	dashes = min(dashes + 1, 2)
	$UI/GameplayUI.update_dashes(dashes)
	$UI/GameplayUI.update_mana(mana/100.0)

func receive_mana_damage(amount : int):
	mana = max(0, mana - amount)
	$UI/GameplayUI.update_mana(mana/100.0)

func game_over():
	Input.set_custom_mouse_cursor(hand_cursor, Input.CURSOR_ARROW, Vector2(63,63))
	pass

func _on_quit_pressed():
	get_tree().quit()
