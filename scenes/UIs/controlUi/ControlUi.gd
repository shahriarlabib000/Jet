extends CanvasLayer


static var speed:float=0
static var max_speed:float=0

func _ready():
	if DisplayServer.has_hardware_keyboard():
		hide()
	speed=$VSlider.value
	max_speed=$VSlider.max_value

func _process(_delta: float) -> void:
	$fps.text=str(Engine.get_frames_per_second())
	$Label.text=str($VSlider.value)
	if Input.is_action_pressed("t_up"):
		%VSlider.value += 1
	if Input.is_action_pressed("t_down"):
		%VSlider.value -= 1

func _on_v_slider_value_changed(value: float) -> void:
	speed=value
