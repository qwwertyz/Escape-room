# LaserBeam.gd
extends Node2D

@export var bounces := 4
@export var laser_length := 2000.0
@export var collision_mask_bits := 1  # bitmask: 1 == layer 1, 2 == layer 2, etc.

@onready var line := $Line2D
var max_cast_to
var rot:= 0.0

var lasers := []

func _ready() -> void:
	lasers.append($Laser)
