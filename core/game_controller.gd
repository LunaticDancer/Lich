extends Node2D

enum MENU_STATE {MAIN, GAMEPLAY, PAUSE, PICKUP, DEATH}

@export var play_area_scene : PackedScene

var hand_cursor = load("res://core/sprites/Cursor2.png")
var cross_cursor = load("res://core/sprites/Cursor1.png")

var play_area
var current_state = MENU_STATE.MAIN

# player resources
var dashes := 2.0
var mana := 0.0
var mana_display := 0.0
var score := 0
var ability : Ability
var considered_ability : PackedScene
var is_ability_sustained : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	# DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	Input.set_custom_mouse_cursor(hand_cursor, Input.CURSOR_ARROW, Vector2(63,63))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_dash_regen(delta)
	handle_ability_sustain(delta)
	handle_mana_display()

func _unhandled_input(event):
	if current_state == MENU_STATE.DEATH:
		$UI/DeathScreen.hide()
		_on_to_menu_pressed()
		
	if current_state == MENU_STATE.GAMEPLAY:
		if event.is_action_pressed("pause"):
			pause()
			return
		if event.is_action_pressed("ability"):
			if ability == null:
				return
			if mana < ability.activation_cost:
				return
			ability.on_activated()
			receive_mana_damage(ability.activation_cost)
			is_ability_sustained = true;
		if event.is_action_released("ability"):
			if ability == null:
				return
			ability.on_deactivated()
			is_ability_sustained = false;
		
	if current_state == MENU_STATE.PAUSE:
		if event.is_action_pressed("pause"):
			_on_resume_pressed()
			return

func pause():
	Input.set_custom_mouse_cursor(hand_cursor, Input.CURSOR_ARROW, Vector2(63,63))
	get_tree().paused = true
	current_state = MENU_STATE.PAUSE
	$UI/PauseMenu.show()

func handle_dash_regen(delta):
	dashes = min(dashes + delta, 2)
	$UI/GameplayUI.update_dashes(dashes)

func handle_mana_display():
	if mana > mana_display:
		mana_display = mana
	else:
		mana_display = lerpf(mana_display, mana, 0.04)
	$UI/GameplayUI.update_mana(mana_display/100.0)

func handle_ability_sustain(delta):
	if ability == null:
		return
	if is_ability_sustained == false:
		return
	
	var frame_cost = ability.sustain_cost * delta
	if mana > frame_cost:
		mana -= frame_cost
		ability.on_sustained(delta)
	else:
		ability.on_deactivated()
		is_ability_sustained = false;

func spend_dash():
	dashes -= 1
	$UI/GameplayUI.update_dashes(dashes)

func _on_play_pressed():
	current_state = MENU_STATE.GAMEPLAY
	$UI/MainMenu.hide()
	$UI/GameplayUI.show()
	ability = null
	$UI/GameplayUI/SpellSlot/AbilityIcon.texture = null
	$UI/GameplayUI/ScoreDisplay.text = "Score: " + str(0)
	play_area = play_area_scene.instantiate()
	Input.set_custom_mouse_cursor(cross_cursor, Input.CURSOR_ARROW, Vector2(63,63))
	init_player_resources()
	add_child(play_area)

func init_player_resources():
	dashes = 2
	mana = 0
	mana_display = 0
	score = 0
	ability = null
	is_ability_sustained = false
	$UI/GameplayUI.update_dashes(dashes)
	$UI/GameplayUI.update_mana(mana/100.0)

func enemy_killed(score_value : int):
	score += score_value
	$UI/GameplayUI/ScoreDisplay.text = "Score: " + str(score)
	dashes = min(dashes + 1, 2)
	$UI/GameplayUI.update_dashes(dashes)
	$UI/GameplayUI.update_mana(mana/100.0)

func on_ability_pickup(new_ability : PackedScene):
	Input.set_custom_mouse_cursor(hand_cursor, Input.CURSOR_ARROW, Vector2(63,63))
	current_state = MENU_STATE.PICKUP
	get_tree().paused = true
	considered_ability = new_ability
	var ability_instance = new_ability.instantiate()
	$UI/AbilityPickUpScreen.show()
	$UI/AbilityPickUpScreen/VBoxContainer/AbilityName.text = ability_instance.ability_name
	$UI/AbilityPickUpScreen/VBoxContainer/HBoxContainer2/AbilityIcon.texture = ability_instance.icon
	$UI/AbilityPickUpScreen/VBoxContainer/HBoxContainer2/Description.text = ability_instance.ability_description

func swap_ability(new_ability : PackedScene):
	for child in $UI/GameplayUI/SpellSlot/AbilityHolder.get_children():
		child.queue_free()
	var ability_instance = new_ability.instantiate()
	$UI/GameplayUI/SpellSlot/AbilityHolder.add_child(ability_instance)
	ability = ability_instance
	$UI/GameplayUI/SpellSlot/AbilityIcon.texture = ability.icon


func receive_mana_damage(amount : int):
	mana = max(0, mana - amount)

func gain_mana(amount: int):
	mana = min(mana + amount, 100)

func game_over():
	current_state = MENU_STATE.DEATH
	$UI/DeathScreen.show()
	$UI/GameplayUI.hide()
	get_tree().paused = true
	Input.set_custom_mouse_cursor(hand_cursor, Input.CURSOR_ARROW, Vector2(63,63))
	pass

func _on_quit_pressed():
	get_tree().quit()

func _on_resume_pressed():
	current_state = MENU_STATE.GAMEPLAY
	Input.set_custom_mouse_cursor(cross_cursor, Input.CURSOR_ARROW, Vector2(63,63))
	get_tree().paused = false
	$UI/PauseMenu.hide()

func _on_reset_pressed():
	play_area.queue_free()
	get_tree().paused = false
	$UI/PauseMenu.hide()
	_on_play_pressed()

func _on_to_menu_pressed():
	$Camera.inGameplay = false
	play_area.queue_free()
	current_state = MENU_STATE.MAIN
	get_tree().paused = false
	$UI/AbilityPickUpScreen.hide()
	$UI/GameplayUI.hide()
	$UI/PauseMenu.hide()
	$UI/MainMenu.show()

func _on_take_ability_pressed():
	Input.set_custom_mouse_cursor(cross_cursor, Input.CURSOR_ARROW, Vector2(63,63))
	current_state = MENU_STATE.GAMEPLAY
	swap_ability(considered_ability)
	get_tree().paused = false
	$UI/AbilityPickUpScreen.hide()

func _on_discard_ability_pressed():
	Input.set_custom_mouse_cursor(cross_cursor, Input.CURSOR_ARROW, Vector2(63,63))
	current_state = MENU_STATE.GAMEPLAY
	get_tree().paused = false
	$UI/AbilityPickUpScreen.hide()
