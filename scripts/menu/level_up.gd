extends Control

@onready var player = get_node("/root/Game/world/Enviroment/Player")
@onready var level_up_screen = get_node("/root/Game/LevelUpCanvas")
@onready var control: CanvasLayer = $"../../Control"

var gun_attack_speed_count = 0
var walking_speed_count = 0


func _on_walking_speed_pressed() -> void:
	player.level_up_speed += 40
	walking_speed_count += 1
	update_button_texts()
	close_level_up_screen()



func _on_gun_attack_speed_pressed() -> void:
	player.gun_attack_speed -= 0.4
	gun_attack_speed_count += 1
	update_button_texts()
	close_level_up_screen()


func close_level_up_screen():
	control.set_cursor()
	get_tree().paused = false
	level_up_screen.hide()


func update_button_texts() -> void:
	$Card3/WalkingSpeed.text = "Walking Speed ("+str(walking_speed_count)+")"
	$Card2/GunAttackSpeed.text = "Gun Attack Speed ("+str(gun_attack_speed_count)+")"
	


func _on_fully_heal_pressed() -> void:
	player.heal_player(9999)
	update_button_texts()
	close_level_up_screen()


func _on_invulnerability_pressed() -> void:
	player.start_invulnerability_timer(10)
	update_button_texts()
	close_level_up_screen()
