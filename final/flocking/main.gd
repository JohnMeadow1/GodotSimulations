extends Node

var GENERATE_BOIDS  = 50
var boids = []
var neighborCount   = 0

var alignment_rate  = 1.0
var cohesion_rate   = 1.0
var separation_rate = 1.0

var boid_object = load("res://boid.tscn")

func _ready():
	$CanvasLayer/alignment.value  = alignment_rate
	$CanvasLayer/cohesion.value   = cohesion_rate
	$CanvasLayer/separation.value = separation_rate
	randomize()
	for i in range ( GENERATE_BOIDS ):
		var new_boid = boid_object.instance()
		new_boid.position = Vector2(rand_range(21,get_viewport().size.x-21),rand_range(21,get_viewport().size.y-21))
		new_boid.velocity = Vector2(rand_range(-1,1),rand_range(-1,1)).normalized()
		$boids.add_child(new_boid)
		

func _process(delta):
	for boid in $boids.get_children():
		boid.velocity   += (boid.alignment * alignment_rate + boid.cohesion * cohesion_rate + boid.separation * separation_rate).normalized()
#		boid.velocity *= 0.95
		boid.velocity = boid.velocity.normalized()*5
		boid.check_border_conditions()
		boid.position += boid.velocity

func _on_alignment_value_changed(value):
	alignment_rate = value

func _on_cohesion_value_changed(value):
	cohesion_rate = value

func _on_separation_value_changed(value):
	separation_rate = value
