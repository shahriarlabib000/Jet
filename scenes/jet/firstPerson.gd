extends Camera3D

func _unhandled_input(event: InputEvent) -> void:
	if current and event is InputEventScreenDrag:
		rotation.x += event.relative.y * 0.001
		rotation.y += event.relative.x * 0.001
