extends Node2D

@export var bounces := 4
@export var collision_mask_bits := 1
@onready var line := $Line2D
@export var start_angle := 30.0  # degrees or radians your choice


const MAX_LENGTH = 2000
var max_target_position
var rot:= 0.0

var lasers := []

func _ready() -> void:
	lasers.append($Laser)
	
	for i in range(bounces):
		#make new raycast for each bounce and append
		var raycast = $Laser.duplicate()
		raycast.enabled = false
		#raycast.add_exception(self)# just dont' add exception...
#raycast.add_exception(sender) old. not work in 4?
		add_child(raycast)
		lasers.append(raycast)
		raycast.global_position = global_position#neew
	max_target_position = Vector2(MAX_LENGTH,0).rotated(rot)
	
	$Laser.target_position = max_target_position
	#will not make the laser move in relation to its parent
	line.top_level = true 
	
	
func _process(delta: float) -> void:
	lasers[0].enabled = true
	
	for i in range(1, lasers.size()):
		lasers[i].enabled = false
	#new code above
	rot = get_local_mouse_position().angle()
	#rot = deg_to_rad(start_angle)

	
	#reset points
	line.clear_points()
	
	#add first point as laser's start pos
	line.add_point(global_position)
	
	#set the farthest cast
	max_target_position = Vector2(MAX_LENGTH,0).rotated(rot)
	
	var idx = -1
	for raycast in lasers:
		idx += 1
		var raycastcollison = raycast.get_collision_point()
		raycast.target_position = max_target_position
		
		#if raycast detects coll
		if raycast.is_colliding():
			#place next lien point at the coll point
			line.add_point(raycastcollison)
			var collider = raycast.get_collider()#raycast instead of collison fix error
			#move next raycast to the bounced vector off of the wall's normal
			#if collider.is_in_group("refractor"):#THIS IS THE ONE I ADDED
			max_target_position = max_target_position.bounce(raycast.get_collision_normal())
			if idx < lasers.size() -1:#if not last raycast,enable next raycast
				lasers[idx+1].enabled = true
				lasers[idx+1].global_position = raycastcollison + (1*max_target_position.normalized())
			if idx == lasers.size() -1: # if last raycast, set end particle to collison
				pass#no particle here
		else: #if no coll
			#place next line poitn max_dis away
			line.add_point(global_position + max_target_position)
			if idx == 0:
				raycast.target_position = max_target_position
				
