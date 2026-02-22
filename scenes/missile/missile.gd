extends RigidBody3D
class_name Missile

var crashP := preload("res://scenes/crashP/crash_particle.tscn")
@onready var jet:Jet = get_node("/root/main/jet")
@onready var audio:AudioStreamPlayer3D = get_node("/root/main/explode")

@export var z_force := 120000000

func _ready() -> void:
	global_rotation = jet.global_rotation
	apply_central_impulse(global_basis.y * -500)
	apply_central_impulse(global_basis.z * z_force)
	
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	state.apply_central_force(basis.z * z_force)
	
func _physics_process(_delta: float) -> void:
	if global_position.distance_to(jet.global_position) > 100000 :
		queue_free()
	if $RayCast3D.is_colliding():
		collided($RayCast3D.get_collider(),$RayCast3D.get_collision_point())
		


func collided(node:Node3D,pos:Vector3 = global_position) -> void:
	if node.is_in_group("terrain"):
		var inst:GPUParticles3D = crashP.instantiate()
		get_parent().add_child(inst)
		inst.global_position = pos
		inst.emitting = true
		set_axis_velocity(basis.z)
		hide()
		audio.play()
		audio.global_position = pos
		queue_free()
