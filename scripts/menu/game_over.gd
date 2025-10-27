extends Control

@onready var transition = $transition
var start_game = preload("res://scenes/game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Input.set_custom_mouse_cursor(null)
	if !MenuMusic.playing:
		MenuMusic.play()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_start_again_pressed() -> void:
	$ArrrrSound.play()
	if MenuMusic.playing:
		MenuMusic.stop()
	transition.play("fade_out")


func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_transition_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(start_game)
