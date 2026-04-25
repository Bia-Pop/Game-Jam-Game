extends Node

@onready var blue_static_body_3d: InteractableObject = $BluePot/BlueStaticBody3D
@onready var green_static_body_3d: InteractableObject = $GreenPot/GreenStaticBody3D
@onready var yellow_static_body_3d: InteractableObject = $YellowPot/YellowStaticBody3D
@onready var cooking_static_body_3d: InteractableObject = $CookingPot/CookingStaticBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var liquid: MeshInstance3D = $CookingPot/Liquid

var already_interacting: bool = false

@export var solution: Array[ItemData]

var correct_steps_streak: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PuzzleManager.blue_pot_picked_up == true:
		blue_static_body_3d.queue_free()
	else:
		blue_static_body_3d.interact = Callable(self, "_on_bluepot_pickup")
		cooking_static_body_3d.remove_from_group("Interactables")
	
	if PuzzleManager.green_pot_picked_up == true:
		green_static_body_3d.queue_free()
	else:
		green_static_body_3d.interact = Callable(self, "_on_greenpot_pickup")
		cooking_static_body_3d.remove_from_group("Interactables")
		
	if PuzzleManager.yellow_pot_picked_up == true:
		yellow_static_body_3d.queue_free()
	else:
		yellow_static_body_3d.interact = Callable(self, "_on_yellowpot_pickup")
		cooking_static_body_3d.remove_from_group("Interactables")
		
	if PuzzleManager.complete_puzzles[PuzzleManager.puzzles.HIEROPHANT] == false:
		cooking_static_body_3d.interact = Callable(self, "_on_cooking_interaction")
	else:
		var material = liquid.get_surface_override_material(0)
		material.albedo_color = Color.YELLOW
		cooking_static_body_3d.remove_from_group("Interactables")

func _on_bluepot_pickup():
	InventoryManager.add_item(InventoryManager.BLUE_POT)
	PuzzleManager.blue_pot_picked_up = true
	SaveManager.save_file_data.blue_pot_picked_up = PuzzleManager.blue_pot_picked_up
	print("bluepot picked up!")
	blue_static_body_3d.queue_free()
	update_cooking_pot()
	
func _on_greenpot_pickup():
	InventoryManager.add_item(InventoryManager.GREEN_POT)
	PuzzleManager.green_pot_picked_up = true
	SaveManager.save_file_data.green_pot_picked_up = PuzzleManager.green_pot_picked_up
	print("greenpot picked up!")
	green_static_body_3d.queue_free()
	update_cooking_pot()
	
func _on_yellowpot_pickup():
	InventoryManager.add_item(InventoryManager.YELLOW_POT)
	PuzzleManager.yellow_pot_picked_up = true
	SaveManager.save_file_data.yellow_pot_picked_up = PuzzleManager.yellow_pot_picked_up
	print("yellowpot picked up!")
	yellow_static_body_3d.queue_free()
	update_cooking_pot()
	
func update_cooking_pot():
	if PuzzleManager.blue_pot_picked_up == false:
		cooking_static_body_3d.remove_from_group("Interactables")
		return
	if PuzzleManager.green_pot_picked_up == false:
		cooking_static_body_3d.remove_from_group("Interactables")
		return
	if PuzzleManager.yellow_pot_picked_up == false:
		cooking_static_body_3d.remove_from_group("Interactables")
		return
	cooking_static_body_3d.add_to_group("Interactables")
	cooking_static_body_3d.interact = Callable(self, "_on_cooking_interaction")

func _on_cooking_interaction():
	match InventoryManager.selected_item.item_name:
		"BluePot":
			already_interacting = true
			_on_blue_pot_anim_finished()
		"GreenPot":
			already_interacting = true
			_on_green_pot_anim_finished()
		"YellowPot":
			already_interacting = true
			_on_yellow_pot_anim_finished()
		_:
			print("Wrong item")
	
func _on_blue_pot_anim_finished():
	change_liquid_color(Color.AQUA)
	await get_tree().create_timer(0.5).timeout
	if solution[correct_steps_streak].item_name != "BluePot":
		reset_streak()
	else:
		correct_steps_streak += 1
		check_if_completed()
		
	already_interacting = false
	
func _on_green_pot_anim_finished():
	change_liquid_color(Color.WEB_GREEN)
	await get_tree().create_timer(0.5).timeout
	if solution[correct_steps_streak].item_name != "GreenPot":
		reset_streak()
	else:
		correct_steps_streak += 1
		check_if_completed()
	
	already_interacting = false
	
func _on_yellow_pot_anim_finished():
	change_liquid_color(Color.YELLOW)
	await get_tree().create_timer(0.5).timeout
	if solution[correct_steps_streak].item_name != "YellowPot":
		reset_streak()
	else:
		correct_steps_streak += 1
		check_if_completed()
		
	already_interacting = false

func check_if_completed():
	if correct_steps_streak == solution.size():
		end_puzzle()
		
func end_puzzle():
	print("HIEROPHANT OVER!")
	cooking_static_body_3d.remove_from_group("Interactables")
	PuzzleManager.finish_puzzle(PuzzleManager.puzzles.HIEROPHANT)
	SignalBus.hierophant_completed.emit()

func reset_streak():
	correct_steps_streak = 0
	change_liquid_color(Color.WHITE)
	
func change_liquid_color(new_color: Color):
	var material = liquid.get_surface_override_material(0)
	if material is StandardMaterial3D:
		var tween = create_tween()
		tween.tween_property(material, "albedo_color", new_color, 1)
	
