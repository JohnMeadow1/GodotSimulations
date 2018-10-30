extends Node2D

var velocity           = Vector2()
var neighborhood_range = 200
var neighbors          = []
var neighborCount      = 0
var alignment          = Vector2()
var cohesion           = Vector2()
var separation         = Vector2()

var timer = 0.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	timer = rand_range(0,3) + rand_range(0,3) 
	pass

func _process(delta):
#	alignment  = alignment()
#	cohesion   = cohesion()
#	separation = separation()
#	direction_change(delta)
	all()

	update()
func direction_change(delta):
	timer -= delta
	if timer <=0:
		velocity += Vector2(rand_range(-1,1),rand_range(-1,1)).normalized() *15
		timer = rand_range(0,3) + rand_range(0,3) 
		
func all():
	alignment          = Vector2()
	cohesion           = Vector2()
	separation         = Vector2()
	neighborCount      = 0
	var distance       = 0
	var distance_squared = 0
	for boid in get_parent().get_children():
		if boid != self:
			distance = (boid.position-position).length()
			distance_squared = distance*distance
			if (boid.position-position).length() < neighborhood_range:
				alignment  += boid.velocity/distance
				separation += (boid.position - position)/distance_squared
				cohesion   += boid.position
				neighborCount += 1
				
	if neighborCount == 0:
		alignment = velocity
		cohesion  = position
		separation = Vector2()
	else:
		alignment  /= neighborCount
		cohesion   /= neighborCount
		separation /= neighborCount
			
	alignment  = alignment.normalized()
	cohesion   = (cohesion - position)/neighborhood_range
	separation = separation.normalized() * -1

func alignment():
	var local_velocity = Vector2()
	neighborCount = 0
	for boid in get_parent().get_children():
		if boid != self:
			if (boid.position-position).length() < float(neighborhood_range)*1.0:
				local_velocity += boid.velocity
				neighborCount += 1
	if neighborCount > 1:
		local_velocity /= neighborCount
	return local_velocity

func cohesion():
	var average_position = Vector2()
	neighborCount = 0
	for boid in get_parent().get_children():
		if boid != self:
			if (boid.position-position).length() < float(neighborhood_range)*0.7:
				average_position += boid.position
				neighborCount += 1
	if neighborCount > 1:
		average_position /= neighborCount
	average_position = average_position - position
	return  average_position
	
func separation():
	var separation = Vector2()
	neighborCount = 0
	for boid in get_parent().get_children():
		if boid != self:
			if (boid.position-position).length() < float(neighborhood_range)*0.6:
				separation += boid.position - position
				neighborCount += 1
				
	if neighborCount > 1:
		separation /= neighborCount
		
	separation *= -1
	return separation

func check_border_conditions():
	if position.x + velocity.x  > get_viewport().size.x-20 or position.x + velocity.x < 20:
		velocity.x *= -1
	if position.y + velocity.y  > get_viewport().size.y-20 or position.y + velocity.y < 20:
		velocity.y *= -1
		
func _draw():
#	draw_line(Vector2(), separation*100, Color(1,0,0,0.1),3)
#	draw_line(Vector2(), alignment *100, Color(0,1,0,0.1),3)
#	draw_line(Vector2(), cohesion  *100, Color(0,0,1,0.1),3)
	draw_vector( separation * 50, Color( 1.0, 0.0, 0.0, 0.3 ), 3 )
	draw_vector( alignment  * 50, Color( 0.0, 1.0, 0.0, 0.3 ), 3 )
	draw_vector( cohesion   * 50, Color( 0.0, 0.0, 1.0, 0.3 ), 3 )

func draw_vector( vector, color, arrow_size ):
	if vector.length_squared() > 1:
		var points    = []
		var direction = vector.normalized()
		points.push_back( vector + direction * arrow_size * 2 )
		points.push_back( vector + direction.rotated(  PI / 2 ) * arrow_size )
		points.push_back( vector + direction.rotated( -PI / 2 ) * arrow_size )
		draw_polygon( PoolVector2Array( points ), PoolColorArray( [color] ) )
		draw_line( Vector2( 0.0, 0.0 ), vector, color, arrow_size )