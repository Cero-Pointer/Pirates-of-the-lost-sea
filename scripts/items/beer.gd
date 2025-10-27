extends Item

@onready var player = get_node("/root/Game/world/Enviroment/Player")
@onready var player_speed_timer = get_node("/root/Game/world/Enviroment/Player/SpeedTimer")

func _on_body_entered(body: Node2D) -> void:
		super._on_body_entered(body)
		if body.name == "Player":
			player.adjust_walk_speed()
