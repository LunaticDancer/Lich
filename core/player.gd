extends CharacterBody2D

const SPEED = 400.0
const DASH_SPEED = 1200.0

@export var basicAttackPrefab : PackedScene
var game_controller
var is_dashing = false

func _ready():
	get_tree().get_first_node_in_group("Camera").prepare_for_gameplay(self)
	game_controller = get_tree().get_first_node_in_group("GameController")

func _process(delta):
	$AnimatedSprite2D.scale = Vector2(1 if (get_local_mouse_position().x > 0) else -1, 1)

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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

func attack():
	var attack = basicAttackPrefab.instantiate()
	attack.global_position = global_position + get_local_mouse_position().normalized() * 8
	attack.set_direction( get_local_mouse_position().angle() )
	get_parent().add_child(attack)

func dash():
	if game_controller.dashes < 1:
		return
	
	game_controller.spend_dash()
	is_dashing = true
	$DashTimeout.start()

func receive_damage(amount : int):
	game_controller.receive_mana_damage(amount)

func _on_dash_timeout_timeout():
	is_dashing = false
