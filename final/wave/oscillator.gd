extends Node2D

var selection = null

func _process(delta):
	update()

func splat( id, velocity, size ) :
	get_child(id).position.y        += velocity * size
	get_child(id).previous_position += velocity/2 * size

func _draw():
	if selection != null:
		draw_circle( selection.position, 15, Color( 1, 1, 1, 1 ) )