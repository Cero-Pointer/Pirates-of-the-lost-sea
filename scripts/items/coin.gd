extends Item

@onready var progressbar = get_node("/root/Game/Control")

# Handles the event when a body enters the area.
# If the entered body is the player, it increments the coin count in the progress bar by 1.
func _on_body_entered(body: Node2D) -> void:
		super._on_body_entered(body)
		if body.name == "Player":
			progressbar.update_coins(5)
