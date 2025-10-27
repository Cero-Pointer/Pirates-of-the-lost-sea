extends Node2D

@export var spawns: Array[Enemy_spawn_info] = []

@onready var player = get_node("/root/Game/world/Enviroment/Player")
@onready var world = get_node("/root/Game/world")

var time = 0
var ground_tilemap
# keeping track of the number of enemies to protect the memory
const MAX_ENEMIES = 500
var debug = false


func _ready() -> void:
	ground_tilemap = world.get_ground_tile_map_layer()


func _on_timer_timeout() -> void:
	if player != null and not debug:
		time +=1
		#Reset Counter so that enemies keep spawning
		if time >= 60:
			time = 1
		var enemy_spawns = spawns
		# Go trough each enemy in the array
		for i in enemy_spawns:
			# If the enemy is in the correct time range spawn it
			if time >= i.time_start and time <= i.time_end:
				# Spawn the enemy after the given delay. Else reset it
				if i.spawn_delay_counter < i.enemy_spawn_delay:
					i.spawn_delay_counter += 1
				else:
					i.spawn_delay_counter = 0
					var new_enemy = load(str(i.enemy.resource_path))
					var counter = 0
					# Create enemies if the counter of the enemies is in range
					if get_tree().get_nodes_in_group("enemies").size() < MAX_ENEMIES:
						while counter < i.enemy_num:
							var enemy_spawn = new_enemy.instantiate()
							var random_pos = get_random_position()
							# Check if spawn is valid
							if random_pos != Vector2.ZERO: 
								enemy_spawn.global_position = get_random_position()
								enemy_spawn.add_to_group("enemies")
								add_child(enemy_spawn)
								counter += 1
							
					
func get_random_position() -> Vector2:
	# Get the viewport rect and multiply it by a random number
	var view_port_rect = get_viewport_rect().size * randf_range(1.1, 1.4)
	
	# Get the coordinates of every corner of the viewport rect
	var top_left = Vector2(player.global_position.x - view_port_rect.x / 2,
							player.global_position.y - view_port_rect.y / 2)
	var top_right = Vector2(player.global_position.x + view_port_rect.x / 2,
							player.global_position.y - view_port_rect.y / 2)
	var bottom_left = Vector2(player.global_position.x - view_port_rect.x / 2,
							player.global_position.y + view_port_rect.y / 2)
	var bottom_right = Vector2(player.global_position.x + view_port_rect.x / 2,
							player.global_position.y + view_port_rect.y / 2)
							
	
	var sides = ["up", "down", "right", "left"]
	while sides.size() > 0:
		# Choose a random corner where the enemy should spawn
		var pos_side = ["up", "down", "right", "left"].pick_random()
		# Delete the choosen side
		sides.erase(pos_side)
		# Initialize the spawn position
		var spawn_pos1 = Vector2.ZERO
		var spawn_pos2 = Vector2.ZERO
		
		# Switch statement to determine the side for spawn area
		match pos_side:
			"up":
				spawn_pos1 = top_left
				spawn_pos2 = top_right
			"down":
				spawn_pos1 = bottom_left
				spawn_pos2 = bottom_right
			"right":
				spawn_pos1 = top_right
				spawn_pos2 = bottom_right
			"left":
				spawn_pos1 = top_left
				spawn_pos2 = bottom_left
		
		# Set the spawn random to a position within the chosen corner
		var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
		var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
		var spawn_position: Vector2 = Vector2(x_spawn, y_spawn)
		# Check if tile is walkable
		if is_position_walkable(spawn_position):
			return spawn_position
	return Vector2.ZERO


func is_position_walkable(world_position):
	# Get tile coordinates
	var tile_coord = ground_tilemap.local_to_map(ground_tilemap.to_local(world_position))
	# Get data in tile
	var data = ground_tilemap.get_cell_tile_data(tile_coord)
	if data:
		return data.get_custom_data("walkable")
	else:
		return false
