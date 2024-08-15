extends RigidBody3D

@export var speed:int=500
@export var rollSpeed:int=2000
@export var turnSpeed:int=1500
@onready var uiScript=preload("res://scenes/ui/ui.gd")
var dir:float=0
var roll:bool

func _ready() -> void:
	print(get_viewport().size)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	state.apply_central_force(basis.z * -uiScript.speed)
	
	
func _physics_process(delta: float) -> void:
	dir=Input.get_axis("ui_right","ui_left")
	if dir:
		roll=false
	apply_torque(basis.y * delta * dir * turnSpeed)
	if(abs(global_rotation_degrees.z)< 30):
		apply_torque(basis.z * delta * dir * turnSpeed)
		
	
	dir=Input.get_axis("ui_up","ui_down")
	apply_torque(basis.x * delta * dir * turnSpeed)
	
	dir=Input.get_axis("rRight","rLeft")
	apply_torque(basis.z * delta * dir * rollSpeed)
	if dir:
		roll=true
		
	if(global_rotation.z!=0 and !roll):
		apply_torque(basis.z * -(global_rotation_degrees.z/abs(global_rotation_degrees.z)) * delta * turnSpeed/3)
	
	$tppNode.global_rotation.z=0
	
	
	#if uiScript.speed<=200:
		#gravity_scale=0.3
		#apply_central_impulse(basis.z *delta * 90*5* -uiScript.speed)
	#else :
		#gravity_scale=0
