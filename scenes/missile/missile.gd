extends RigidBody3D

var crashP=preload("res://scenes/crashP/crash_particle.tscn")
func _integrate_forces(state):
	state.apply_central_force(global_basis.z * -5000)


func _on_area_3d_body_entered(body):
	if body.is_in_group("terrain"):
		var inst:GPUParticles3D=crashP.instantiate()
		get_parent().get_parent().add_child(inst)
		inst.emitting=true
		
