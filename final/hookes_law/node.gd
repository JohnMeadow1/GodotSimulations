extends Node2D

var velocity = Vector2(0.0,0.0)
var old_position = Vector2(0.0,0.0)
var mass = 1.0
# 1./mass
var mu = 1.0
var neighbors = []
var ks = []
var ls = []

func _ready():
	old_position = position - velocity*get_physics_process_delta_time()

func _physics_process(delta):
	verlet(delta)

func set_velocity(v):
	velocity = v
	old_position = position - velocity*get_physics_process_delta_time()

func set_mass(m):
	mass = m
	mu = pow(m,-1.0)

func euler(delta):
	velocity += force()*mu*delta
	position += velocity*delta

func verlet(delta):
	var new_position = 2*position - old_position + force()*mu*pow(delta,2.0)
	old_position = position
	position = new_position
	velocity = (position - old_position)/delta
	
func force():
	var F = Vector2(0.0, 0.0)
	for i in range(neighbors.size()):
		var direction = neighbors[i].position - position
		F += -ks[i] * (ls[i] - direction.length())*direction.normalized()
	return F - 10*velocity