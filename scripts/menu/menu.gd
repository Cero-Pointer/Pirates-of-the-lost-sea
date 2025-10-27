extends Control

@onready var transition = $transition
var start_game = preload("res://scenes/game.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveManager.load_var()
	if !MenuMusic.playing:
		MenuMusic.play()


func _on_start_button_pressed() -> void:
	MenuMusic.stop()
	$ArrrrSound.play()
	transition.play("fade_out")


func _on_option_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/store.tscn")


func _on_quit_button_pressed() -> void:
	SaveManager.save_var()
	get_tree().quit()


func _on_credit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/credits.tscn")

func _on_transition_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(start_game)


func _on_how_to_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/how_to_play.tscn")
