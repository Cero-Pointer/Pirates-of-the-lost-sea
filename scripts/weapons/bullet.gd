extends Area2D

# Speed of the bullet
@export var speed : int = 600
# Prevents bullet from hitting multiple enemies
var hit_only_once = true
# Direction of the bullet
var direction : Vector2

func _process(delta: float) -> void:
	# Moves the bullet to the given direction
	position += speed * direction * delta

# Frees the bullet after timer runs out
func _on_despawn_timeout() -> void:
	queue_free()

# If the bullet entered an enemy the enemy and bullet will be freed
func _on_body_entered(body: Node2D) -> void:
	if hit_only_once != false:
		hit_only_once = false
		if body.is_in_group("enemies"):
			if body.is_alive:
				body.die()
				hide()
				$CollisionShape2D.set_deferred("disabled", true)
				await $ShootSound.finished
				queue_free()
			
