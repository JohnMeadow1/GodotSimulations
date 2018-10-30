extends MeshInstance

var velocity           = Vector3()
var neighborhood_range = 10
var neighbors          = []
var neighborCount      = 0
var alignment          = Vector3()
var cohesion           = Vector3()
var separation         = Vector3()

var timer = 0.0

func _ready():
	timer = rand_range(0,3) + rand_range(0,3) 
	velocity = Vector3(rand_range(-1,1),rand_range(-1,1),rand_range(-1,1)).normalized()

func _process(delta):
#	alignment  = alignment()
#	cohesion   = cohesion()
#	separation = separation()
	all()
	direction_change(delta)

#	update()
func direction_change(delta):
	timer -= delta
	if timer <=0:
		velocity += Vector3(rand_range(-1,1),rand_range(-1,1),rand_range(-1,1)).normalized() *0.1
		timer     = rand_range(0,3) + rand_range(0,3) 
		
func all():
	self.translation
	alignment          = Vector3()
	cohesion           = Vector3()
	separation         = Vector3()
	
	neighborCount      = 0
	var distance       = 0
	var distance_squared = 0
	for boid in get_parent().get_children():
		if boid != self:
			distance = max((boid.translation-translation).length(),1)
			distance_squared = max(distance * distance,1)
			if (boid.translation-translation).length() < neighborhood_range:
				alignment  += boid.velocity / distance_squared
				separation += (boid.translation - translation) / distance_squared
				cohesion   += boid.translation
				neighborCount += 1
				
	if neighborCount == 0:
		alignment  = velocity
		cohesion   = translation
		separation = Vector3()
	else:
		alignment  /= max(neighborCount,1)
		cohesion   /= max(neighborCount,1)
		separation /= max(neighborCount,1)
			
	alignment  = alignment.normalized()
	cohesion   = (cohesion - translation) / max( neighborhood_range, 1 )
	separation = separation.normalized() * -1
#	self.set_parameter(0,Color(1,0,0))
#	self.material_override.set("albedo_color", Color(1,0,0))

#func alignment():
#	var local_velocity = Vector3()
#	neighborCount = 0
#	for boid in get_parent().get_children():
#		if boid != self:
#			if (boid.translation-translation).length() < float(neighborhood_range)*1.0:
#				local_velocity += boid.velocity
#				neighborCount += 1
#	if neighborCount > 1:
#		local_velocity /= neighborCount
#	return local_velocity
#
#func cohesion():
#	var average_translation = Vector3()
#	neighborCount = 0
#	for boid in get_parent().get_children():
#		if boid != self:
#			if (boid.translation-translation).length() < float(neighborhood_range)*1.0:
#				average_translation += boid.translation
#				neighborCount += 1
#	if neighborCount > 1:
#		average_translation /= neighborCount
#	average_translation = average_translation - translation
#	return  average_translation
#
#func separation():
#	var separation = Vector3()
#	neighborCount = 0
#	for boid in get_parent().get_children():
#		if boid != self:
#			if (boid.translation-translation).length() < float(neighborhood_range)*1.0:
#				separation += boid.translation - translation
#				neighborCount += 1
#
#	if neighborCount > 1:
#		separation /= neighborCount
#
#	separation *= -1
#	return separation

#func check_border_conditions():
#	pass
#	if translation.x + velocity.x  > get_viewport().size.x-20 or translation.x + velocity.x < 20:
#		velocity.x *= -1
#	if translation.y + velocity.y  > get_viewport().size.y-20 or translation.y + velocity.y < 20:
#		velocity.y *= -1
		
#func _draw():
#	draw_line(Vector3(), separation*100, Color(1,0,0,0.1),3)
#	draw_line(Vector3(), alignment *100, Color(0,1,0,0.1),3)
#	draw_line(Vector3(), cohesion  *100, Color(0,0,1,0.1),3)
#	draw_vector( separation * 50, Color( 1.0, 0.0, 0.0, 0.3 ), 3 )
#	draw_vector( alignment  * 50, Color( 0.0, 1.0, 0.0, 0.3 ), 3 )
#	draw_vector( cohesion   * 50, Color( 0.0, 0.0, 1.0, 0.3 ), 3 )

#func draw_vector( vector, color, arrow_size ):
#	if vector.length_squared() > 1:
#		var points    = []
#		var direction = vector.normalized()
#		points.push_back( vector + direction * arrow_size * 2 )
#		points.push_back( vector + direction.rotated(  PI / 2 ) * arrow_size )
#		points.push_back( vector + direction.rotated( -PI / 2 ) * arrow_size )
#		draw_polygon( PoolVector3Array( points ), PoolColorArray( [color] ) )
#		draw_line( Vector3(), vector, color, arrow_size )