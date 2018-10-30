extends Node

var GENERATE_BOIDS  = 150
var boids = []
var neighborCount   = 0

var alignment_rate  = 1.0
var cohesion_rate   = 0.9
var separation_rate = 0.5

var world_size      = 50
var random_start_size = 25

var boid_object = load("res://boid.tscn")


func _ready():
	$CanvasLayer/alignment.value  = alignment_rate
	$CanvasLayer/cohesion.value   = cohesion_rate
	$CanvasLayer/separation.value = separation_rate
	randomize()
	for i in range ( GENERATE_BOIDS ):
		var new_boid = boid_object.instance()
#		new_boid.translation = Vector3(rand_range(21,get_viewport().size.x-21),rand_range(21,get_viewport().size.y-21))
		new_boid.translation.x = rand_range(-random_start_size,random_start_size)
		new_boid.translation.y = rand_range(25,random_start_size)
		new_boid.translation.z = rand_range(-random_start_size,random_start_size)
#		new_boid.velocity = Vector3(rand_range(-1,1),rand_range(-1,1),rand_range(-1,1)).normalized()
		$boids.add_child(new_boid)
	

func _process(delta):
	for boid in $boids.get_children():
#		boid.velocity   += ((boid.alignment * alignment_rate + boid.cohesion * cohesion_rate + boid.separation * separation_rate).normalized()) *0.01
		boid.velocity   += boid.alignment  * alignment_rate
		boid.velocity   += boid.cohesion   * cohesion_rate 
		boid.velocity   += boid.separation * separation_rate
		
#		print(avoid_buildings(boid)*100)
		boid.velocity   += avoid_buildings(boid) * 10
#		print(boid.alignment," ", boid.cohesion," ", boid.separation)
#		boid.velocity   *= 0.1
		boid.velocity   *= 0.20
		boid.velocity = boid.velocity.normalized()
#		boid.check_border_conditions()

		if boid.translation.x + boid.velocity.x > world_size || boid.translation.x + boid.velocity.x < -world_size:
			boid.velocity.x *= -1
		if boid.translation.y + boid.velocity.y > world_size || boid.translation.y + boid.velocity.y < 0:
			boid.velocity.y *= -1
		if boid.translation.z + boid.velocity.z > world_size || boid.translation.z + boid.velocity.z < -world_size:
			boid.velocity.z *= -1
		boid.translation += boid.velocity
		
		
func avoid_buildings(boid):
	var building_repuslision        = Vector3()
	var building_repuslision_vector = Vector3()
	var building_distance = 0
	for building in $buildings.get_children():
		building_repuslision_vector = Vector3()
		
		building_repuslision_vector.x = boid.translation.x - building.translation.x
#		building_repuslision_vector.y = boid.translation.y - building.mesh.get("size").y
		building_repuslision_vector.z = boid.translation.z - building.translation.z
		building_distance = building_repuslision_vector.length()
		if building_distance <= 15 :
			
			if boid.translation.y > building.mesh.get("size").y && boid.translation.y < building.mesh.get("size").y + 10:
				building_repuslision_vector.y = (boid.translation.y - (building.mesh.get("size").y ))
				building_distance = building_repuslision_vector.length()
#				print(building_repuslision_vector.y)
				building_repuslision += building_repuslision_vector.normalized()/(pow(building_distance - building.mesh.get("size").x,2)+1)
			elif boid.translation.y < building.mesh.get("size").y:
				building_repuslision += building_repuslision_vector.normalized()/(pow(building_distance - building.mesh.get("size").x,2)+1)

	return building_repuslision
	
func _on_alignment_value_changed(value):
	$Camera.ignore_mouse = true
	alignment_rate = value

func _on_cohesion_value_changed(value):
	$Camera.ignore_mouse = true
	cohesion_rate = value

func _on_separation_value_changed(value):
	$Camera.ignore_mouse = true
	separation_rate = value
