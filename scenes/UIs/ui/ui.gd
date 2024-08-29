extends CanvasLayer


static var speed:float=0
static var max_speed:float=0
func _ready():
	speed=$VSlider.value
	max_speed=$VSlider.max_value

func _process(_delta: float) -> void:
	$fps.text=str(Engine.get_frames_per_second())
	$Label.text=str($VSlider.value)

func _on_v_slider_value_changed(value: float) -> void:
	speed=value
