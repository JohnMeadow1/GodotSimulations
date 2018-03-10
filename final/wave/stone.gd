extends Node2D

var velocity = Vector2(0,0)
var water_node = 0
var underwater = false

func _ready():
	randomize()
	velocity = Vector2(0, 1)
	
func initialize():
	var smallest_dist = 1000
	position = Vector2( rand_range(100, get_viewport_rect().size.x-100), -30 )
	for i in $'../../'.numer_of_nodes + 1:
		if abs(position.x - $'../../oscillator'.get_child(i).position.x) < smallest_dist:
			smallest_dist = position.x - $'../../oscillator'.get_child(i).position.x
			water_node = i

func _process(delta):
	position += velocity
	velocity += Vector2(0,1)
	if position.y > get_viewport_rect().size.y +30:
		queue_free()
	if underwater:
		velocity *= 0.8
	else:
		if $'../../oscillator'.get_child(water_node).position.y < position.y + 15 :
			underwater = true
			$'../../'.splash($'../../oscillator'.get_child(water_node).position, velocity)
			for i in range(max(water_node-1,0), min (water_node+2, $'../../'.numer_of_nodes)):
#				if abs($'../../oscillator'.get_child(i).position.x - position.x) < 15:
#					$'../../oscillator'.get_child(i).position.y += velocity.y*5/(abs($'../../oscillator'.get_child(i).position.x - position.x)+1)
				$'../../oscillator'.get_child(i).position.y += velocity.y * (1 -  (i - water_node)/2)/1.5
#				$'../../oscillator'.get_child(i).previous_position += velocity.y * (1 -  (abs($'../../oscillator'.get_child(i).position.y - $'../../oscillator'.get_child(water_node).position.y)/2))
#					$'../../oscillator'.get_child(i).previous_position += velocity.y*10/(($'../../oscillator'.get_child(i).position - position).length()+1)
		velocity *= 0.96