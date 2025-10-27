extends CanvasLayer

signal level_up

var normal_cursor = preload("res://assets/weapons/normal_crosshair.png")
var reload_cursor = preload("res://assets/weapons/reload_crosshair.png")
var reloading = false
@onready var progressbar = $ProgressBar
@onready var level_label = $LevelLabel
@onready var kill_label = $KillLabel
@onready var coin_label = $CoinLabel
@onready var player = get_node("/root/Game/world/Enviroment/Player")
@onready var game: Node2D = get_tree().root.get_node("Game") 

@export var collected_coins_step = 10

var current_kills = 0
var collected_coins = 0


func _ready():
	Input.set_custom_mouse_cursor(normal_cursor, Input.CURSOR_ARROW, Vector2(36, 36))


# Sets the custom mouse cursor based on the current reloading state.
# Uses the reload cursor if reloading, otherwise uses the normal cursor.
func set_cursor():
	if reloading:
		Input.set_custom_mouse_cursor(reload_cursor, Input.CURSOR_ARROW, Vector2(36, 36))
	else:
		Input.set_custom_mouse_cursor(normal_cursor, Input.CURSOR_ARROW, Vector2(36, 36))


# Resets the cursor to the default system cursor by removing any custom mouse cursor.
func reset_cursor():
	Input.set_custom_mouse_cursor(null)


# Updates the progress bar based on the given amount.
# If the updated value reaches or exceeds 100, it emits a level-up signal,
# resets the progress bar, and updates the level label.
# Otherwise, it increments the progress bar by the given amount and the stored experience collection rate.
func update_progressbar(amount):
	if progressbar.value + amount + SaveManager.store_exp_collection_rate >= 100:
		level_up.emit()
		progressbar.value = 0
		level_label.text = "Level: " + str(player.current_level) 
	else:
		progressbar.value += amount + SaveManager.store_exp_collection_rate


# Handles the event when the player starts or stops reloading.
# Updates the reloading state based on the input value and updates the cursor accordingly.
func _on_player_reloading(val) -> void:
	if val:
		reloading = true
	elif !val:
		reloading = false
	set_cursor()


# Updates the player's total coin count with the specified amount.
# Adds the given amount and the stored coin collection rate to the total collected coins,
# updates the coin label, and emits a signal to notify about the updated coin count.
func update_coins(amount):
	collected_coins += amount + SaveManager.store_coin_collection_rate
	coin_label.text = "Coins: "+ str(collected_coins)
	SaveManager.emit_signal("coin_collected", collected_coins)


# Updates the player's kill count.
# Increments the current kill count by 1 and updates the kill label to display the new value.
func update_kills():
	current_kills += 1
	kill_label.text = "Kills: " + str(current_kills)


# Handles the event when the player dies.
# Resets the cursor to its default state.
func _on_player_die_signal() -> void:
	reset_cursor()
