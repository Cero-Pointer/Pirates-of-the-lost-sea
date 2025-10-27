extends Control


var sword_unlocked_costs = 200
var sword_attack_range_costs = 100
var sword_attack_speed_costs = 100
var coin_collection_rate_costs = 50
var exp_collection_rate_costs = 50
var hp_buff_costs = 100


func _ready() -> void:
	SaveManager.load_var()
	refresh_all_text()


# Handles the event when the "Back to Menu" button is pressed.
# Saves the current game variables and changes the scene to the main menu.
func _on_back_to_menu_button_pressed() -> void:
	SaveManager.save_var()
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


# Refreshes all text elements and button states in the UI.
func refresh_all_text():
	$ButtonBig/CoinAmount.text = str(SaveManager.all_collected_coins)
	if SaveManager.store_sword_unlocked:
		$BookWithoutBIg/SwordUnlockButton.add_theme_color_override("font_focus_color", Color.FOREST_GREEN)
		$BookWithoutBIg/SwordUnlockButton.set_disabled(true)
		$BookWithoutBIg/SwordAttackSpeedButton.set_disabled(false)
		$BookWithoutBIg/SwordAttackRangeButton.set_disabled(false)
	else:
		$BookWithoutBIg/SwordUnlockButton.set_disabled(false)
		$BookWithoutBIg/SwordAttackSpeedButton.set_disabled(true)
		$BookWithoutBIg/SwordAttackRangeButton.set_disabled(true)
	$BookWithoutBIg/SwordAttackRangeButton.text = "Upgrade\nSword Attack Range\n(Currently: +"+str(SaveManager.store_sword_attack_range)+")\n"+str(sword_attack_range_costs)
	$BookWithoutBIg/SwordAttackSpeedButton.text = "Upgrade\nSword Attack Speed\n(Currently: "+str(SaveManager.store_sword_attack_speed)+"s)\n"+str(sword_attack_speed_costs)
	$BookWithoutBIg/CoinCollectionRateButton.text = "Upgrade\nCoin Collection Rate\n(Currently: +"+str(SaveManager.store_coin_collection_rate)+")\n"+str(coin_collection_rate_costs)
	$BookWithoutBIg/EXPCollectionRateButton.text = "Upgrade\nEXP Collection Rate\n(Currently: +"+str(SaveManager.store_exp_collection_rate)+")\n"+str(exp_collection_rate_costs)
	$BookWithoutBIg/HPButton.text = "Upgrade\nHealth Points\n(Currently: +"+str(SaveManager.store_hp_buff)+")\n"+str(hp_buff_costs)


# Handles the event when the "Reset All" button is pressed.
# Resets all saved game data and refreshes the UI text elements to reflect the reset state.
func _on_reset_all_button_pressed() -> void:
	SaveManager.reset_save()
	refresh_all_text()


# Handles the event when the "Sword Unlock" button is pressed.
# Checks if the player has enough coins to unlock the sword.
func _on_sword_unlocked_pressed() -> void:
	if SaveManager.all_collected_coins >= sword_unlocked_costs:
		SaveManager.all_collected_coins -= sword_unlocked_costs
		SaveManager.store_sword_unlocked = true
		$BookWithoutBIg/SwordUnlockButton.add_theme_color_override("font_focus_color", Color.FOREST_GREEN)
		$BuySound.play()
	else:
		$BookWithoutBIg/SwordUnlockButton.add_theme_color_override("font_focus_color", Color.RED)
	refresh_all_text()


# Handles the event when the "Sword Attack Range" upgrade button is pressed.
# Checks if the player has enough coins to purchase the upgrade.
func _on_sword_attack_range_button_pressed() -> void:
	if SaveManager.all_collected_coins >= sword_attack_range_costs:
		SaveManager.all_collected_coins -= sword_attack_range_costs
		SaveManager.store_sword_attack_range += 20
		$BookWithoutBIg/SwordAttackRangeButton.add_theme_color_override("font_focus_color", Color.FOREST_GREEN)
		$BuySound.play()
	else:
		$BookWithoutBIg/SwordAttackRangeButton.add_theme_color_override("font_focus_color", Color.RED)
	refresh_all_text()


# Handles the event when the "Sword Attack Speed" upgrade button is pressed.
# Checks if the player has enough coins to purchase the upgrade.
func _on_sword_attack_speed_button_pressed() -> void:
	if SaveManager.all_collected_coins >= sword_attack_speed_costs:
		SaveManager.all_collected_coins -= sword_attack_speed_costs
		SaveManager.store_sword_attack_speed += -0.2
		$BookWithoutBIg/SwordAttackSpeedButton.add_theme_color_override("font_focus_color", Color.FOREST_GREEN)
		$BuySound.play()
	else:
		$BookWithoutBIg/SwordAttackSpeedButton.add_theme_color_override("font_focus_color", Color.RED)
	refresh_all_text()


# Handles the event when the "Coin Collection Rate" upgrade button is pressed.
# Checks if the player has enough coins to purchase the upgrade.
func _on_coin_collection_rate_button_pressed() -> void:
	if SaveManager.all_collected_coins >= coin_collection_rate_costs:
		SaveManager.all_collected_coins -= coin_collection_rate_costs
		SaveManager.store_coin_collection_rate += 1
		$BookWithoutBIg/CoinCollectionRateButton.add_theme_color_override("font_focus_color", Color.FOREST_GREEN)
		$BuySound.play()
	else:
		$BookWithoutBIg/CoinCollectionRateButton.add_theme_color_override("font_focus_color", Color.RED)
	refresh_all_text()


# Handles the event when the "EXP Collection Rate" upgrade button is pressed.
# Checks if the player has enough coins to purchase the upgrade.
func _on_exp_collection_rate_button_pressed() -> void:
	if SaveManager.all_collected_coins >= exp_collection_rate_costs:
		SaveManager.all_collected_coins -= exp_collection_rate_costs
		SaveManager.store_exp_collection_rate += 5
		$BookWithoutBIg/EXPCollectionRateButton.add_theme_color_override("font_focus_color", Color.FOREST_GREEN)
		$BuySound.play()
	else:
		$BookWithoutBIg/EXPCollectionRateButton.add_theme_color_override("font_focus_color", Color.RED)
	refresh_all_text()


# Handles the event when the "HP" upgrade button is pressed.
# Checks if the player has enough coins to purchase the upgrade.
func _on_hp_button_pressed() -> void:
	if SaveManager.all_collected_coins >= hp_buff_costs:
		SaveManager.all_collected_coins -= hp_buff_costs
		SaveManager.store_hp_buff += 10
		$BookWithoutBIg/HPButton.add_theme_color_override("font_focus_color", Color.FOREST_GREEN)
		$BuySound.play()
	else:
		$BookWithoutBIg/HPButton.add_theme_color_override("font_focus_color", Color.RED)
	refresh_all_text()
