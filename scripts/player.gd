extends CharacterBody2D

# Will be emit if the player shoots
signal shoot
signal die_signal
signal reloading

@onready var sprite = $AnimatedSprite2D
@onready var hit_area = $HitArea/CollisionShape2D

@export var weapon_list: Array[Weapon_info] = []

# Current level of the player
var current_level = 0
# Max health of the player
@export var max_health = 100
# Speed of the player
@export var base_speed = 200
# Current Speed of the player
var current_speed = 0
# Speed gain from level up
var level_up_speed = 0
# Hit radius of the player
@export var hit_area_radius = 200
# Sword Attack Speed of the player in seconds
@export var sword_attack_speed = 3
# Gun Attack Speed of the player in seconds
@export var gun_attack_speed = 2
# Can the player shoot?
var can_shoot = true
# Can the player attack with the sword?
var can_swing = true
# All enemies in the hit range of the player
var enemy_list : Array
# Is an enemy currently dealing damage?
var enemy_in_damage_area = false
# Is the player alive?
var is_alive = true
# Has the player a speed buff?
var has_speed_buff = false
# Is the player invulnerable?
var is_player_invulnerable = false


func _ready() -> void:
	$HealthBar.max_value = max_health + SaveManager.store_hp_buff
	$HealthBar.value = max_health + SaveManager.store_hp_buff
	var collision_shape = $HitArea/CollisionShape2D
	var circle_shape = collision_shape.shape as CircleShape2D
	circle_shape.radius = hit_area_radius + SaveManager.store_sword_attack_range
	if sword_attack_speed > 0:
		$SwordTimer.wait_time = sword_attack_speed + SaveManager.store_sword_attack_speed
	if SaveManager.store_sword_unlocked:
		$ReloadBar.show()
	else:
		$ReloadBar.hide()


func _process(delta):
	if is_alive:
		#Update the speed of the player
		if !has_speed_buff:
			current_speed = base_speed + level_up_speed
		# Input processing
		var direction: Vector2 = Input.get_vector("Left","Right","Up","Down")
		velocity.x = move_toward(velocity.x, current_speed * direction.x, current_speed)
		velocity.y = move_toward(velocity.y, current_speed * direction.y, current_speed)
		if !direction == Vector2.ZERO:
			if !$WalkingSound.playing:
				$WalkingSound.pitch_scale = randf_range(0.9, 1.2)
				$WalkingSound.play()
		elif $WalkingSound.playing:
			$WalkingSound.stop()
		move_and_slide()
		# Sprite movement
		if velocity.x != 0 || velocity.y != 0:
			sprite.animation = "moving"
			sprite.flip_v = false
			sprite.flip_h = velocity.x < 0
		else:	
			sprite.animation = "idle"
		calculate_health_points()
		# Update the hit radius of the player
		if SaveManager.store_sword_unlocked:
			check_enemy_list()
			if !$Sword/AnimatedSprite2D.is_playing():
				$Sword.hide()
			else:
				$Sword.show()
		else:
			$Sword.hide()
		if Input.is_action_just_pressed("Shoot") and can_shoot:
			var mouse_position = get_global_mouse_position()
			var dir = (mouse_position - position).normalized()
			can_shoot = false
			shoot.emit(position, dir)
			$GunTimer.start()
		if can_swing:
			$ReloadBar.value = 100 
		else:
			$ReloadBar.value = (1 - $SwordTimer.time_left / $SwordTimer.wait_time) * 100
		if can_shoot:
			reloading.emit(false)
		else:
			reloading.emit(true)
		if gun_attack_speed > 0:
			$GunTimer.wait_time = gun_attack_speed
		if enemy_in_damage_area:
			get_damage(0.5)
	else:
		$HealthBar.hide()
		$ReloadBar.hide()
		$Sword.hide()

 
# Health Points function
# Hides the healthbar if it is above or equal to 100
# Calls the play_death_animation() function if the health is equal or below 0
func calculate_health_points():
	if $HealthBar.value >= $HealthBar.max_value and not is_player_invulnerable:
		$HealthBar.visible = false
	elif $HealthBar.value < $HealthBar.max_value or is_player_invulnerable:
		$HealthBar.visible = true
	if $HealthBar.value <= 0:
		play_death_animation()


func play_death_animation():
	$DieSound.play()
	is_alive = false
	die_signal.emit()
	sprite.animation = "death"


# This function frees the player from the game
func free_player():
	queue_free()
	get_tree().change_scene_to_file("res://scenes/menu/game_over.tscn")

"""
This function checks the array with the possible enemies in range
Shoots a bullet to the closest enemy if the ShotTimer has run out and if
an enemy is in range
"""
func check_enemy_list():
	if not enemy_list.is_empty() and can_swing:
		var target = calculate_closest_enemy()
		if target != null:
			if target.is_in_group("enemies"):
				if target.is_alive:
					target.die()
					$Sword/AnimatedSprite2D.play()
					$Sword/SwingSound.play()
					can_swing = false
					$SwordTimer.start()
			else:
				pass


# Gets the enemy with the shortest distance to the player
func calculate_closest_enemy():
	var nearest_enemy = null
	var nearest_distance = INF
	for enemy in enemy_list:
		var distance = position.distance_to(enemy.position)
		if distance < nearest_distance:
			nearest_enemy = enemy
			nearest_distance = distance
	return nearest_enemy


# Heals the player
# Checks if value + the amount is above the max value. If this is the case set
# the value to max
# Otherwise the healthbar will be incremented by the amount
func heal_player(amount):
	if $HealthBar.value + amount > $HealthBar.max_value:
		$HealthBar.value = $HealthBar.max_value
	else:
		$HealthBar.value += amount


# Function to deal the player damage
func get_damage(damage_amount):
	if is_alive and not is_player_invulnerable:
		$HealthBar.value -= damage_amount
		calculate_health_points()
		if !$HurtSound.playing:
			$HurtSound.play()


# Append the enemy to the enemy list if it is in range
func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" || body.name == "Water":
		return
	else:
		enemy_list.append(body)


# If a enemy leaves the hit area free this enemy from the list
func _on_hit_area_body_exited(body: Node2D) -> void:
	enemy_list.erase(body)

# Shoot if timer runs out
func _on_timer_timeout() -> void:
	can_shoot = true


# Swing sword if timer runs out
func _on_sword_timer_timeout() -> void:
	can_swing = true


# If an enemy enters the hitbox of the player set get_damage to true
func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemy_in_damage_area = true


# If an enemy leaves the hitbox of the player set get_damage to false
func _on_damage_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemy_in_damage_area = false


# Timer for the timeout of the speed buff
func _on_speed_timer_timeout() -> void:
	has_speed_buff = false


func _on_control_level_up() -> void:
	$LevelUpSound.play()
	current_level += 1


# Will adjust the walk speed of the player if 
# the player does not have a speed boost already
func adjust_walk_speed():
	if !has_speed_buff:
		has_speed_buff = true
		current_speed += 200
	$SpeedTimer.start()


func start_invulnerability_timer(amount):
	is_player_invulnerable = true
	$InvulnerabilityIcon.show()
	$InvulnerabilityTimer.wait_time = amount
	$InvulnerabilityTimer.start()


func _on_invulnerability_timer_timeout() -> void:
	is_player_invulnerable = false
	$InvulnerabilityIcon.hide()
