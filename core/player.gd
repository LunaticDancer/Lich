extends CharacterBody2D

const SPEED = 400.0
const DASH_SPEED = 1600.0

var basicAttackPrefab = preload("res://core/player_swing.tscn")
var game_controller
var is_dashing = false
var is_healing = false

func _ready():
	get_tree().get_first_node_in_group("Camera").prepare_for_gameplay(self)
	game_controller = get_tree().get_first_node_in_group("GameController")

func _process(delta):
	$AnimatedSprite2D.scale = Vector2(1 if (get_local_mouse_position().x > 0) else -1, 1)

func _physics_process(delta):
	if is_healing:
		return
	
	var xdirection = Input.get_axis("left", "right")
	var ydirection = Input.get_axis("up", "down")
	var direction = Vector2(xdirection, ydirection).normalized()
	velocity = direction * (DASH_SPEED if is_dashing else SPEED)
	move_and_slide()

func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		attack()
	if event.is_action_pressed("dodge"):
		dash()
	if event.is_action_pressed("restore"):
		if game_controller.mana < 100:
			return
		$AnimatedSprite2D.play("healing")
		is_healing = true
		$GPUParticles2D.emitting = true
	if event.is_action_released("restore"):
		$AnimatedSprite2D.play("default")
		is_healing = false
		$GPUParticles2D.emitting = false

func attack():
	if is_healing:
		return
		
	var attack = basicAttackPrefab.instantiate()
	attack.global_position = global_position + get_local_mouse_position().normalized() * 8
	attack.set_direction( get_local_mouse_position().angle() )
	get_parent().add_child(attack)

func dash():
	if is_healing:
		return
	if game_controller.dashes < 1:
		return
	
	game_controller.spend_dash()
	is_dashing = true
	$DashTimeout.start()

func receive_damage(amount : int):
	game_controller.receive_mana_damage(amount)

func _on_dash_timeout_timeout():
	is_dashing = false

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "healing":
		$AnimatedSprite2D.play("default")
		is_healing = false
		game_controller.receive_mana_damage(100)
		get_tree().get_first_node_in_group("PlayerWeakpoint").heal()
		$GPUParticles2D.emitting = false
