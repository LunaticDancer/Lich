extends Area2D
class_name Projectile

const KILL_DISTANCE = 5000.0;

@export var direction := Vector2.RIGHT
@export var speed := 5.0
@export var damage = 1
@export var is_aimed_at_player := true
var is_alive := true
var player

func _ready():
	area_shape_entered.connect(_on_area_shape_entered)
	body_shape_entered.connect(_on_body_shape_entered)
	player = get_tree().get_first_node_in_group("Player")

func set_direction(p_dir : Vector2):
	direction = p_dir

func move(delta):
	if is_alive == false:
		return
	global_position += direction * speed * delta

func _process(delta):
	move(delta)
	if global_position.distance_to(player.global_position) > KILL_DISTANCE:
		destroy()

func destroy():
	is_alive = false

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if is_alive == false:
		return
	
	if body.is_in_group("PlayerBasicAttack"):
		is_aimed_at_player = false
		direction = Vector2(cos(body.direction), sin(body.direction))
		add_to_group("PlayerParriedAttack")
	
	if is_aimed_at_player:
		if body.is_in_group("Player"):
			body.receive_damage(5)
			destroy()
		if body.is_in_group("PlayerWeakpoint"):
			body.receive_damage()
			destroy()
	
	else:
		if body is Enemy:
			body.receive_damage(damage)
			body.bleed(direction)
			destroy()

func _on_area_shape_entered(area_rid, body, area_shape_index, local_shape_index):
	if is_alive == false:
		return
	
	if body.is_in_group("PlayerBasicAttack"):
		is_aimed_at_player = false
		direction = Vector2(cos(body.get_parent().direction), sin(body.get_parent().direction))
		add_to_group("PlayerParriedAttack")
	
	if is_aimed_at_player:
		if body.is_in_group("Player"):
			body.receive_damage(5)
			destroy()
		if body.is_in_group("PlayerWeakpoint"):
			body.receive_damage()
			destroy()
	
	else:
		if body is Enemy:
			body.receive_damage(damage)
			body.bleed(direction)
			destroy()
