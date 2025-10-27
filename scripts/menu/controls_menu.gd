extends Control

@onready var control_menu = get_node("/root/Game/PauseControlMenu")
@onready var pause_menu = get_node("/root/Game/PauseMenuCanvas")
@onready var control = $"../../Control"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	control_menu.hide()


func _process(delta):
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		control.reset_cursor()
		control_menu.hide()
		get_tree().paused = true


func _on_button_pressed() -> void:
	pause_menu.show()
	control_menu.hide()
	get_tree().paused = true
