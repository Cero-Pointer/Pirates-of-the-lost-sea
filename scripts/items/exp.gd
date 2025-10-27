extends Item

@onready var player = get_node("/root/Game/world/Enviroment/Player")
@onready var progressbar = get_node("/root/Game/Control")


# Handles the event when a body enters the area.
# If the entered body is the player, it increases the progress bar value by 10.
func _on_body_entered(body: Node2D) -> void:
	super._on_body_entered(body)
	if body.name == "Player":
		progressbar.update_progressbar(10)
