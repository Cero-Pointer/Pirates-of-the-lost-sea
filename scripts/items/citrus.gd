extends Item

@onready var player = get_node("/root/Game/world/Enviroment/Player")
@onready var hitbox_damage = player.get_node("DamageArea/HitBoxDamage")

func _on_body_entered(body: Node2D) -> void:
	super._on_body_entered(body)
	if body.name == "Player":
		player.heal_player(20)
