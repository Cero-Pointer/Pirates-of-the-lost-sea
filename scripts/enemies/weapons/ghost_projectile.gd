extends Area2D
@onready var player = get_node("/root/Game/world/Enviroment/Player")
# Speed of the bullet
@export var speed : int = 300
# Prevents bullet from hitting multiple enemies
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
	if body.is_in_group("player"):
		player.get_damage(20)
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		await $ShootSound.finished
		queue_free()
