extends Projectile

func destroy():
	super()
	$DeathTimer.start()

func _on_death_timer_timeout():
	queue_free()
