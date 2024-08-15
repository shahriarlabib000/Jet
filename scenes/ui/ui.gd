extends CanvasLayer


static  var speed:float=0

func _process(_delta: float) -> void:
	$fps.text=str(Engine.get_frames_per_second())

func _on_v_slider_value_changed(value: float) -> void:
	speed=value
