extends Camera2D

var inGameplay = false
var player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if inGameplay:
		move(delta)
	

func prepare_for_gameplay(p_player : Node2D):
	player = p_player
	inGameplay = true

func move(delta):
	global_position = lerp(global_position, lerp(player.global_position, get_global_mouse_position(), 0.25), 0.15)
