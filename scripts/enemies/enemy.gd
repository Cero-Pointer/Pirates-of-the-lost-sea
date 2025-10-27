extends CharacterBody2D

class_name Enemy

@onready var main_scene = get_node("/root/Game")
@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var softCollision = $SoftCollision
@onready var ui = get_node("/root/Game/Control")
@onready var target = get_node("/root/Game/world/Enviroment/Player")
# Is the enemy alive?
var is_alive = true
# Speed of the enemy
@export var speed = 100

@export var item_list: Array[Item_spawn_info] = []


func _physics_process(delta):
	if is_alive:
		if target != null:
			# Move the enemy to the player
			var velocity = global_position.direction_to(target.global_position)
			# Sprite movement
			sprite.animation = "walking"
			sprite.flip_v = false
			# Stops the sprite to jitter if position of target and enemy are the same
			if abs(global_position.x - target.global_position.x) > 0.5:
				sprite.flip_h = velocity.x < 0
			# Check for soft collision
			if softCollision.is_colliding():
				velocity += softCollision.get_push_vector() * delta * 10
			move_and_collide(velocity * speed * delta)


# Die Function for the enemy
func die():
	is_alive = false
	ui.update_kills()
	$AnimationPlayer.play("die")
	drop_random_item()


# Functions that drops an item if the enemy dies
func drop_random_item():
	# Calculate random chances
	var random_value = randi() % 100
	var accumulated_chance = 0
	# Always spawn a coin
	if item_list.size() > 0:
		var coin = item_list[0]
		var new_coin = load(str(coin.item.resource_path))
		var coin_instance = new_coin.instantiate()
		coin_instance.position = position
		main_scene.call_deferred("add_child", coin_instance)
		coin_instance.add_to_group("items")
		# Spawn a random item, but not always
		for i in range(1, item_list.size()):
			var item = item_list[i]
			accumulated_chance += item.chance
			var new_item = load(str(item.item.resource_path))
			if random_value < accumulated_chance:
				var item_instance = new_item.instantiate()
				# Generates a random offset, so the coin and item don't overlap
				var offset = Vector2(randf() * 80, randf() * 80)
				item_instance.position = position + offset
				main_scene.call_deferred("add_child", item_instance)
				item_instance.add_to_group("items")
