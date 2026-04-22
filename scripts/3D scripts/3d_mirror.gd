extends Area3D

class_name InteractableArea3D

var can_interact : bool  = false

func _on_body_entered(body: Node3D) -> void:
	print("3D body entered!")
	can_interact = true



func _on_body_exited(body: Node3D) -> void:
	print("3D body exited!")
	can_interact = false
