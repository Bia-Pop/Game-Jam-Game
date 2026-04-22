extends Node3D

@export var spawnpos : Marker3D
@export var player : CharacterBody3D
@export var scene_2D_path : String 

#var can_interact : bool = false
@export var mirror : InteractableObject


func _ready() -> void:
	print(mirror.area.can_interact)
	player.global_position = spawnpos.position
	mirror.interact = Callable(self, "_on_mirror_switch")



func _on_mirror_switch():
	print("SWITCHING!")
	mirror.area.can_interact = false
	print(mirror.area.can_interact)
	player.set_physics_process(false)
	
	SceneChanger.change_scene_to_path.call_deferred(scene_2D_path)


func _on_player_clicked(target) -> void:
	if target.area.can_interact:
		target.interact.call()
