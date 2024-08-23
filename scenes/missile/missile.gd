extends RigidBody3D

var crashP=preload("res://scenes/crashP/crash_particle.tscn")
@onready var jet=get_node("/root/main/jet")

func _ready() -> void:
	global_basis=jet.global_basis
	
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	state.apply_central_force(basis.z * -500)
	
func _physics_process(_delta: float) -> void:
	if $RayCast3D.is_colliding():
		collided($RayCast3D.get_collider(),$RayCast3D.get_collision_point())
		


func collided(node:Node3D,pos:Vector3=global_position) -> void:
	if node.is_in_group("terrain"):
		process_mode=Node.PROCESS_MODE_DISABLED
		var inst:GPUParticles3D=crashP.instantiate()
		get_parent().add_child(inst)
		inst.global_position=pos
		inst.emitting=true
		$Audio.play()
		hide()
		#queue_free()
		


func _on_audio_finished() -> void:
	queue_free()
