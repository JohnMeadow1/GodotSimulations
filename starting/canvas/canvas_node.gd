extends Node

var position
var velocity          = Vector3( 0.0,   0.0, 0.0 )
var previous_position = Vector3( 0.0,   0.0, 0.0 )
var F                 = Vector3( 0.0,   0.0, 0.0 )
var gravitational_acc = Vector3( 0.0, -0.02, 0.0 )

var mass      = 1.0
var mu        = 1.0 # 1./mass
var neighbors = []
var ks        = []
var ls        = []

var is_static = false

func _ready():
	previous_position = position - velocity * get_physics_process_delta_time()

func _physics_process(delta):
	if !is_static:
		verlet(delta)

func set_velocity(v):
	velocity          = v
	previous_position = position - velocity * get_physics_process_delta_time()

func set_mass(m):
	mass = m
	mu   = pow( m, -1.0 )

func add_neighbor(nghbr, lngth, elsct=10.0):
	neighbors.push_back(nghbr)
	ls.push_back(lngth)
	ks.push_back(elsct)

func euler(delta):
	velocity += force(delta) * mu * delta
	position += velocity * delta

func verlet(delta):
	var new_position  = 2 * position - previous_position + force(delta) * mu * pow( delta , 2.0 )
	previous_position = position
	position          = new_position
	velocity          = ( position - previous_position ) / delta
	
func force(delta):
	F = Vector3( 0.0, 0.0, 0.0 )
	for i in range(neighbors.size()):
		var dir  = neighbors[i].position - self.position
		var dist = ls[i] -  (dir.length())
		F -= ks[i] * dist * dir.normalized()
	var gravity = self.mass * gravitational_acc
	return F + gravity - 0.4*self.velocity