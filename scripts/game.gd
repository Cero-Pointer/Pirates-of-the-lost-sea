extends Node2D

func _on_player_die_signal() -> void:
	SaveManager.update_all_collected_coins()
	SaveManager.save_var()
	$CanvasLayer/FadeOut/ColorRect.show()
	$CanvasLayer/FadeOut.play("fade_out")


func _on_pause_menu_quit() -> void:
	SaveManager.update_all_collected_coins()
	SaveManager.save_var()


func _on_control_level_up() -> void:
	$LevelUpCanvas.show()
	$Control.reset_cursor()
	get_tree().paused = true
