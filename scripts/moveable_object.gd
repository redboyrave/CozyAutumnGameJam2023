@tool
extends Node3D
class_name MoveableObject

@export_category("Object Info") 
@export var mesh:Mesh
@export var collision:Shape3D
@export_range(0.1,100,.01) var weight:float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	$RigidBody3D/MeshInstance3D.mesh = mesh
	$RigidBody3D/CollisionShape3D.shape = collision
	$RigidBody3D.mass = weight


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact():
	#functionality for picking up the item.
	pass
