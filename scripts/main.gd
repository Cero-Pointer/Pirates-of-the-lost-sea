extends Node2D

@onready var transition = $transition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition.play("fade_in")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
