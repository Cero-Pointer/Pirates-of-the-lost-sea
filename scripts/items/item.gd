extends Area2D

class_name Item

var despawn_timer

func _ready() -> void:
	despawn_timer = Timer.new()
	despawn_timer.wait_time = 60
	despawn_timer.one_shot = true
	add_child(despawn_timer)
	despawn_timer.connect("timeout", Callable(self, "_on_despawn_timer_timeout"))
	despawn_timer.start()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$AnimationPlayer.play("pickup")


func _on_despawn_timer_timeout():
	queue_free()
