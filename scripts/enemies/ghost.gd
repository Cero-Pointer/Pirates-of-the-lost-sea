extends Enemy
# The scene used for the enemy's projectile.
var projectile_scene = preload("res://scenes/enemies/weapons/ghost_projectile.tscn")

# Speed of the projectile when fired.
var shot_speed = 50

# Indicates whether the target is within the shooting range.
var is_target_in_range = false

# Reference to the Game node, used to add projectiles to the game world.
@onready var game: Node2D = get_tree().root.get_node("Game")

# Determines if the enemy is currently allowed to shoot.
var can_shot = true

# Called every physics frame. Handles shooting logic when the target is in range.
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if is_target_in_range:
		shoot_at_target(target.position)

# Shoots a projectile toward the target's position.
func shoot_at_target(player_position):
	if can_shot and is_alive:
		$ShotTimer.start()  # Start the shot cooldown timer.
		can_shot = false  # Prevent shooting until the timer allows it.
		var dir = (player_position - position).normalized()  # Calculate direction to the target.
		var projectile = projectile_scene.instantiate()  # Instantiate a new projectile.
		game.add_child(projectile)  # Add the projectile to the game.
		projectile.position = position  # Set the projectile's starting position.
		projectile.direction = dir  # Set the projectile's travel direction.


# Triggered when a body enters the shooting area.
# If the body is the player, mark the target as in range.
func _on_shot_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_target_in_range = true


# Triggered when a body exits the shooting area.
# If the body is the player, mark the target as out of range.
func _on_shot_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_target_in_range = false


# Called when the shot timer times out.
# Allows the enemy to shoot again.
func _on_shot_timer_timeout() -> void:
	can_shot = true
