extends Projectile

@export var particle_spawn_cooldown = 0.004
var particle = preload("res://abilities/basic_dart/basic_dart_particle.tscn")
var particle_timer = 0

func _process(delta):
	super(delta)
	particle_timer += delta
	while (particle_timer > particle_spawn_cooldown):
		particle_timer -= particle_timer
		var instance = particle.instantiate()
		instance.global_position = global_position
		add_sibling(instance)

func destroy():
	super()
	$DeathTimer.start()
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.visible = false

func _on_death_timer_timeout():
	queue_free()
