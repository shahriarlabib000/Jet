extends RigidBody3D

@export var speed:int=500
@export var rollSpeed:int=2000
@export var turnSpeed:int=1500
var dir:float=0

func _ready() -> void:
	print(get_viewport().size)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	state.apply_central_force(basis.z * -speed)
	
	
func _physics_process(delta: float) -> void:
	dir=Input.get_axis("ui_right","ui_left")
	apply_torque(basis.y * delta * dir * turnSpeed)
	dir=Input.get_axis("ui_up","ui_down")
	apply_torque(basis.x * delta * dir * turnSpeed)
	dir=Input.get_axis("rRight","rLeft")
	apply_torque(basis.z * delta * dir * rollSpeed)
	$thirdPerson.global_rotation.z=0
	
