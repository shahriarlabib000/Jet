extends RigidBody3D


signal crashed

@export var rollForce:int = 150000
@export var yawForce:int = 150000
@export var turningForce:int = 200000
@export var maxTilt:int = 20
@export var engine_force:int = 50000000

@onready var uiScript := preload("res://scenes/UIs/ui/ui.gd")
@onready var missile := preload("res://scenes/missile/missile.tscn")
@onready var engineSound :AudioStreamPlayer3D = $engineSound
var dir:float = 0
var roll:bool = false


func _ready() -> void:
	print(get_viewport().size)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	state.apply_central_force(basis.z * uiScript.speed/100 * engine_force)
	engineSound.pitch_scale = clampf(uiScript.speed/100,0.0,5000)
	

var tilt_err:float = 0
var prev_tilt_err:float = 0
func _physics_process(delta: float) -> void:
	dir = Input.get_axis("ui_right","ui_left")
	if dir:
		roll = false
	apply_torque(basis.y * dir * turningForce)
	#####
	if(abs(global_rotation_degrees.z) < maxTilt):
		apply_torque(basis.z * -dir * rollForce * 4)
	####
	dir=Input.get_axis("down","up")
	apply_torque(basis.x * dir * yawForce)
	
	dir=Input.get_axis("rLeft","rRight")
	apply_torque(basis.z * dir * rollForce)
	if dir:
		roll = true
	
	var gbz:float = global_rotation_degrees.z
	if(!is_zero_approx(gbz) and !roll):
		tilt_err = abs(gbz)
		if prev_tilt_err == 0:
			prev_tilt_err = tilt_err
		var deriv := (tilt_err - prev_tilt_err) / delta
		apply_torque(basis.z * -(gbz / abs(gbz))  * deriv * 20)
	
	$tppNode.global_rotation.z = 0
	
	if Input.is_action_just_pressed("missile"):
		var inst:RigidBody3D = missile.instantiate()
		inst.global_transform = $missileNode.global_transform
		get_node("/root/main").add_child(inst)
		
	$stream.get_active_material(0).set_shader_parameter("intensity",(uiScript.speed/uiScript.max_speed) * 5.0)


func _on_area_3d_body_entered(body:PhysicsBody3D) -> void:
	if body.is_in_group("terrain"):
		if uiScript.speed > 20:
			crashed.emit()
	


func _on_timer_timeout() -> void:
	print(linear_velocity.length())
