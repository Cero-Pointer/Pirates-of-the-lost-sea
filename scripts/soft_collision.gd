extends Area2D

# Check if something is colliding.
# Returns true if something is colliding. False otherwise
func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0

# Gets the push vector. Return 0 if no collision is happening
func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		# Get the first area we are colliding with
		var area = areas[0]
		# Get Vector from colliding postion to other position
		push_vector = area.global_position.direction_to(global_position)
	return push_vector
