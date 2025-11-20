# SphereReflector.gd
class_name SphereReflector
extends Node2D

@export var output_angle_degrees := 0.0

func _ready():
	# Ensure Area2D exists as a child:
	if not $Area2D:
		push_error("SphereReflector needs an Area2D child with CollisionShape2D.")
	# optional: ensure this node is on same "visual" layer as Area2D
	pass

func get_reflection_dir() -> Vector2:
	# Direction relative to global rotation of this node
	return Vector2.RIGHT.rotated(deg_to_rad(output_angle_degrees + rotation_degrees))

func rotate_by(deg: float):
	rotation_degrees += deg
