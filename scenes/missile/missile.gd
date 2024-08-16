extends RigidBody3D

var crashP=preload("res://scenes/crashP/crash_particle.tscn")
@onready var jet=get_node("/root/main/jet")
func _ready() -> void:
	global_basis=jet.global_basis
	
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	state.apply_central_force(jet.global_basis.z * -500)
	#pass


func _on_area_3d_body_entered(body:PhysicsBody3D) -> void:
	if body.is_in_group("terrain"):
		var inst:GPUParticles3D=crashP.instantiate()
		get_parent().add_child(inst)
		inst.global_position=global_position
		inst.emitting=true
		queue_free()
		
