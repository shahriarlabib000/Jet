extends Node3D

var camidx:int=1
@onready var cams=get_tree().get_nodes_in_group("cam")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$ground.fov=10#(100/$ground.position.distance_to($jet.position))* 100
	$ground.look_at($jet.position)
	if Input.is_action_just_pressed("camSwitch"):
		cams[camidx].current=true
		camidx+=1
		camidx%=cams.size()
