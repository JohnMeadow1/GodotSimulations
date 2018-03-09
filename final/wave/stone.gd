extends Node2D

var velocity = Vector2(0,0)
var water_node = 0
var underwater = false

func _ready():
	randomize()
	velocity = Vector2(0, 1)
	position = Vector2(rand_range(50,get_viewport_rect().size.x)-50, -30)
	
func initialize():
	var smallest_dist = 1000
	
	for i in $'../../Oscillator'.nb_points+1:
		if abs(position.x - $'../../Oscillator'.get_child(i).position.x) < smallest_dist:
			smallest_dist = position.x - $'../../Oscillator'.get_child(i).position.x
			water_node = i

func _process(delta):
	position += velocity
	velocity += Vector2(0,1)
	if position.y > get_viewport_rect().size.y +30:
		queue_free()
	if underwater:
		velocity *= 0.89
	else:
		velocity *= 0.98
		if abs($'../../Oscillator'.get_child(water_node).position.y - position.y) < 15:
			underwater = true
			for i in range(max(water_node-10,0), min (water_node+10, $'../../Oscillator'.nb_points)):
				if abs($'../../Oscillator'.get_child(i).position.x - position.x) < 15:
					$'../../Oscillator'.get_child(i).position.y += velocity.y*5/(abs($'../../Oscillator'.get_child(i).position.x - position.x)+1)