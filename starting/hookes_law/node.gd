extends Node2D

var velocity = Vector2(0.0,0.0)
var old_position = Vector2(0.0,0.0)
var mass = 1.0
# reciprocal mass mu = 1./mass
var mu = 1.0

# arrays with neighbours, as well as the corresponding constants
var neighbors = []
var ks = []
var ls = []

# calulation of step_{-1}
func _ready():
	old_position = position - velocity*get_physics_process_delta_time()

# calculation of the force
func force():
	var F = Vector2(0.0, 0.0)
	# TODO: calculation of the force from Hooke's Law
	return F

# using verlet algorithm
func _physics_process(delta):
	verlet(delta)

# smart setters
func set_velocity(v):
	velocity = v
	old_position = position - velocity*get_physics_process_delta_time()

func set_mass(m):
	mass = m
	mu = pow(m,-1.0)

# integrating algorithms: euler and verlet
func euler(delta):
	velocity += force()*mu*delta
	position += velocity*delta

func verlet(delta):
	var new_position = 2*position - old_position + force()*mu*pow(delta,2.0)
	old_position = position
	position = new_position
	velocity = (position - old_position)/delta
