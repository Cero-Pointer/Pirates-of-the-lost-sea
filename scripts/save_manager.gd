extends Node

# Signal emitted when coins are collected.
signal coin_collected

# Total coins collected across all sessions.
var all_collected_coins: int = 0

# Coins collected in the current session.
var collected_coins = 0

# Persistent upgrade variables for the player.
var store_sword_unlocked: bool = false              # Whether the sword is unlocked.
var store_sword_attack_range: float = 0             # Sword attack range bonus (+20 per level).
var store_sword_attack_speed: float = 0             # Sword attack speed bonus (-0.2 per level).
var store_coin_collection_rate: float = 0           # Coin collection rate bonus (+1 per level).
var store_exp_collection_rate: float = 0            # Experience collection rate bonus (+5 per level).
var store_hp_buff: int = 0                          # Health point bonus (+10 per level).

# Debug flag to load predefined values for testing.
var debug = false


# File path for saving and loading game data.
var save_path = "user://save_game.dat"


# Called when the node is added to the scene. Connects the coin_collected signal.
func _ready() -> void:
	connect("coin_collected", Callable(self, "_on_coin_collected"))


# Loads saved variables or initializes defaults if no save file exists.
func load_var():
	if debug:
		# Load predefined debug values if debug is true
		all_collected_coins = 400
		store_sword_unlocked = true
		store_sword_attack_range = 0
		store_sword_attack_speed = 0
		store_coin_collection_rate = 100
		store_exp_collection_rate = 100
		store_hp_buff = 100
	elif FileAccess.file_exists(save_path):
		# Load values from the save file.
		var file = FileAccess.open(save_path, FileAccess.READ)
		all_collected_coins = file.get_var(all_collected_coins)
		store_sword_unlocked = file.get_var(store_sword_unlocked)
		store_sword_attack_range = file.get_var(store_sword_attack_range)
		store_sword_attack_speed = file.get_var(store_sword_attack_speed)
		store_coin_collection_rate = file.get_var(store_coin_collection_rate)
		store_exp_collection_rate = file.get_var(store_exp_collection_rate)
		store_hp_buff = file.get_var(store_hp_buff)
	else:
		# Initialize default values.
		all_collected_coins = 0
		store_sword_unlocked = false
		store_sword_attack_range = 0
		store_sword_attack_speed = 0
		store_coin_collection_rate = 0
		store_exp_collection_rate = 0
		store_hp_buff = 0

# Updates the total coins collected and resets the session coin count.
func update_all_collected_coins():
	all_collected_coins += collected_coins
	collected_coins = 0

# Saves all variables to the save file.
func save_var():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(all_collected_coins)
	file.store_var(store_sword_unlocked)
	file.store_var(store_sword_attack_range)
	file.store_var(store_sword_attack_speed)
	file.store_var(store_coin_collection_rate)
	file.store_var(store_exp_collection_rate)
	file.store_var(store_hp_buff)

# Resets all save data to default values and saves the changes.
func reset_save():
	all_collected_coins = 0
	store_sword_unlocked = false
	store_sword_attack_range = 0
	store_sword_attack_speed = 0
	store_coin_collection_rate = 0
	store_exp_collection_rate = 0
	store_hp_buff = 0
	save_var()

# Updates the session coin count when the coin_collected signal is emitted.
func _on_coin_collected(amount):
	collected_coins = amount

# Handles the event if the application exit and saves the data
func _notification(notifictation):
	if notifictation == 1006:
		save_var()
