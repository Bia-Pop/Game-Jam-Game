extends Control

@onready var master_slider = $PanelContainer/MarginContainer/VBoxContainer/MasterSlider
@onready var music_slider = $PanelContainer/MarginContainer/VBoxContainer/MusicSlider
@onready var sfx_slider = $PanelContainer/MarginContainer/VBoxContainer/SfxSlider

func _ready() -> void:
	hide()
	master_slider.value = AudioManager.get_master_volume()
	music_slider.value = AudioManager.get_music_volume()
	sfx_slider.value = AudioManager.get_sfx_volume()

func _on_master_slider_value_changed(value: float) -> void:
	AudioManager.set_master_volume(value)

func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.set_music_volume(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)

func _on_resolutions_item_selected(index: int) -> void:
	var resolutions = [
		Vector2i(1280, 720),
		Vector2i(1920, 1080),
		Vector2i(2560, 1440)
	]
	DisplayServer.window_set_size(resolutions[index])

func _on_close_pressed() -> void:
	hide()
