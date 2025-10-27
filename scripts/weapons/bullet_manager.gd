extends Node2D

@export var bullet_scene : PackedScene

# Creates the bullet and sets the position and direction for it
func _on_player_shoot(pos, dir) -> void:
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.position = pos
	bullet.direction = dir.normalized()
