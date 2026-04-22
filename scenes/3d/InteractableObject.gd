extends StaticBody3D

class_name InteractableObject


@export var area : Area3D
#signal interacted
#var interact : Callable = func() : pass


func interact():
	print("did something!")
	SceneChanger.change_scene_to_path("res://Rooms/Room2.tscn")
