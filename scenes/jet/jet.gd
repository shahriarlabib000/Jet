extends RigidBody3D


signal crashed

@export var speed:int=500
@export var rollSpeed:int=2000
@export var turnSpeed:int=1500
@onready var uiScript=preload("res://scenes/ui/ui.gd")
@onready var missile=preload("res://scenes/missile/missile.tscn")
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
	
	if Input.is_action_just_pressed("missile"):
		var inst:RigidBody3D=missile.instantiate()
		inst.global_position=$missileNode.global_position
		get_node("/root/main").add_child(inst)
		


func _on_area_3d_body_entered(body:PhysicsBody3D) -> void:
	if body.is_in_group("terrain"):
		crashed.emit()
	
