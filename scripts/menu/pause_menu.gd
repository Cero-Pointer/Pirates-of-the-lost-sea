extends Control

@onready var pause_menu = get_node("/root/Game/PauseMenuCanvas")
@onready var control = $"../../Control"

signal quit

func _on_resume_pressed() -> void:
	control.set_cursor()
	get_tree().paused = false
	pause_menu.hide()


func _on_main_menu_pressed() -> void:
	SaveManager.update_all_collected_coins()
	SaveManager.save_var()
	control.reset_cursor()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_quit_pressed() -> void:
	quit.emit()
	SaveManager.save_var()
	get_tree().quit()


func _process(delta):
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		control.reset_cursor()
		pause_menu.show()
		get_tree().paused = true
