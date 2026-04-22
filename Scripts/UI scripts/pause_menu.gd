extends Control

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		print("ESC apasat, paused: ", get_tree().paused)
		if get_tree().paused:
			resume()
		else:
			pause()

func resume() -> void:
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	await $AnimationPlayer.animation_finished
	hide()

func pause() -> void:
	show()
	$AnimationPlayer.play("blur")
	get_tree().paused = true

func _on_resume_pressed() -> void:
	resume()

func _on_options_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/2d/main_menu.tscn")
