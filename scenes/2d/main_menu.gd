extends CanvasLayer

@onready var options_panel = $OptionsPanel
@onready var continue_button: Button = $TextureRect/ButtonManager/Continue

func _ready() -> void:
	if FileAccess.file_exists("user://SaveFile.tres") == false:
		continue_button.disabled = true
	options_panel.visible = false

func _on_start_pressed() -> void:
	DirAccess.remove_absolute("user://SaveFile.tres")
	InventoryManager.reset_data()
	get_tree().change_scene_to_file("res://Rooms/Room2.tscn")

func _on_options_pressed() -> void:
	options_panel.visible = true

func _on_continue_pressed() -> void:
	InventoryManager.load_data()
	get_tree().change_scene_to_file("res://Rooms/Room2.tscn")

func _on_quit_game_pressed() -> void:
	get_tree().quit()
