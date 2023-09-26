extends Node3D

@export_category("Movement Variables")
@export_range(.1,100) var movement_speed:float = 1
@export var mouse_sensitivity:Vector2 = Vector2.ONE
@export var joy_cam_sensitivy:Vector2 = Vector2.ONE
@export_range(10,150,1) var CameraFOV:int = 75
@export_range(0,1) var slidingAmmount = .1
@onready var camera = $RigidBody3D/Camera3D
@onready var rb = $RigidBody3D

var input_vel = Vector2.ZERO
var input_rot = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.fov = CameraFOV
	pass # Replace with function body.


func _physics_process(delta):
	#movement
	
	input_vel = get_input_movement()
	#camera rotation from joystick
	input_rot = get_input_rotation()
	
	if input_vel != Vector2.ZERO: 
		apply_movement(input_vel)
	elif rb.velocity.length_squared() > 0.05: #threshold to stop sliding
		movement_slide()
		
	

	
func _unhandled_input(event):
	#camera rotation from mouse 
	if event is InputEventMouseMotion:
		camera_look(get_mouse_look(event as InputEventMouseMotion))
		get_viewport().set_input_as_handled() 
	if event is InputEventJoypadMotion:
		camera_look(input_rot)
		get_viewport().set_input_as_handled()

func get_input_movement():
	var frwd = Input.get_action_strength("ctrl_frwd") - Input.get_action_strength("ctrl_bckwd")
	var right = Input.get_action_strength("ctrl_right") - Input.get_action_strength("ctrl_left") 
	return circularize_vector(Vector2(right,frwd))

func get_input_rotation(): #returns the scaled output of the joystick input
	var up = Input.get_action_strength("ctrl_look_up") - Input.get_action_strength("ctrl_look_down")
	var right = Input.get_action_strength("ctrl_look_right") - Input.get_action_strength("ctrl_look_left")
	return circularize_vector(Vector2(right,up))*joy_cam_sensitivy

func get_mouse_look(mouse:InputEventMouseMotion): #returns the scaled output of the mouse input
	var rightleft = mouse.relative.x
	var updown = mouse.relative.y
	
	return Vector2(rightleft,updown)*mouse_sensitivity

func circularize_vector(input_vector:Vector2):
	return Vector2(
		input_vector.x * sqrt(1 - (input_vector.y * input_vector.y)/2),
		input_vector.y * sqrt(1 - (input_vector.x * input_vector.x)/2))

func apply_movement(input_dir:Vector2):
	var movement_dir = Vector3(-input_dir.x,0,input_dir.y)
	
	#BASIS IS THE ROTATION KINDA, SO MULTIPLYING IT BY THE VECTOR ROTATES IT TO CAMERA
	var basis_mult = rb.transform.basis * movement_dir
	rb.velocity = basis_mult * movement_speed
	
	#just in case, we stored the collisions
	var col = rb.move_and_slide()

func movement_slide():
	rb.velocity = rb.velocity.lerp(Vector3.ZERO,.1)
	rb.move_and_slide()
	

func camera_look(direction:Vector2):
	rotate_body(direction.x)
	rotate_view(direction.y)

#rotates the camera up and down
func rotate_view(angle):
	var rot = camera.get_rotation()
	rot.x += deg_to_rad(angle)
	rot.x = clamp(rot.x,-PI/2,PI/2)
	camera.set_rotation(rot)

#rotates the body left and right
func rotate_body(angle):
	rb.rotate_y(deg_to_rad(angle))	
