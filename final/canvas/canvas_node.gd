extends Node

var position          = Vector3( 0.0, 0.0, 0.0 )
var velocity          = Vector3( 0.0, 0.0, 0.0 )
var previous_position = Vector3( 0.0, 0.0, 0.0 )
var F                 = Vector3( 0.0, 0.0, 0.0 )
var wind_velocity     = Vector3( 0.0, 0.0, 0.5 )
var wind_modulations  = [Vector3( 1.0, 0.0, 0.0 ), Vector3( 0.0, 0.0, 1.0 )]
var wind              = Vector3( 0.0, 0.0, 0.0 )
var gravity           = Vector3( 0.0,-0.9, 0.0 )
var direction         = Vector3( 0.0, 0.0, 0.0 )
var distance          = Vector3( 0.0, 0.0, 0.0 )

var omega             = 0.13
var mass              = 1.0
var mu                = 1.0 / mass # 1./mass
var neighbors         = []
var stiffness         = []
var resting_length    = []

var timer = 0.0

export var is_static = false

func _ready():
	previous_position = position - velocity * get_physics_process_delta_time()

func _physics_process(delta):
	if !is_static:
		verlet(delta)
		timer += delta

func set_velocity(v):
	velocity          = v
	previous_position = position - velocity * get_physics_process_delta_time()

func set_mass(m):
	mass = m
	mu   = pow( m, -1.0 )

func add_neighbor( neighbor, length, elasticity ):
	neighbors.push_back( neighbor )
	stiffness.push_back( elasticity )
	resting_length.push_back( length )

func euler(delta):
	velocity += force( delta ) * mu * delta
	position += velocity * delta

func verlet(delta):
	var new_position  = 2 * position - previous_position + force( delta ) * mu * pow( delta , 2.0 )
	previous_position = position
	position          = new_position
	velocity          = ( position - previous_position ) / delta

	
func force(delta):
	F = Vector3( 0.0, 0.0, 0.0 )
	for i in range( neighbors.size() ):
		direction = neighbors[i].position - self.position
		distance  = resting_length[i] - direction.length()
		if distance < 0:
			F -= stiffness[i] * distance * direction.normalized()
	wind = Vector3( sin(position.length()+timer), 0, sin(position.length()+timer) )
#	for mod in wind_modulations:
#		wind  += 0.1 * ( wind_velocity * exp( -( position.length() ) ) + sin( 2 * PI * omega * delta ) * mod - self.velocity )
#		omega *= -1.15
	return F + gravity + wind - self.velocity