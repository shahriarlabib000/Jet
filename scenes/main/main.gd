extends Node3D

var crashed_particle := preload("res://scenes/crashP/crash_particle.tscn")
var camidx:int = 1

@onready var cams = get_tree().get_nodes_in_group("cam")
@onready var jet = $jet

func _process(_delta: float) -> void:
	$ground.fov = clamp((100/$ground.position.distance_to(jet.position))* 100,1,70)
	$ground.look_at(jet.position)
	if Input.is_action_just_pressed("camSwitch"):
		cams[camidx].current = true
		camidx += 1
		camidx %= cams.size()
	if Input.is_action_just_pressed("replay"):
		get_tree().reload_current_scene()
		
	$UIs/gyroLayer/gyro/ground.rotation = jet.rotation.z
	#$ui/gyro/measure.position.y += jet.rotation.x/5


func _on_jet_crashed() -> void:
	$UIs/ControlUi.hide()
	$UIs/death.show()
	jet.hide()
	jet.call_deferred("set_process_mode", PROCESS_MODE_DISABLED)
	#jet.process_mode = Node.PROCESS_MODE_DISABLED
	 
	var inst:GPUParticles3D = crashed_particle.instantiate()
	inst.position = jet.position
	add_child(inst)
	inst.emitting = true
