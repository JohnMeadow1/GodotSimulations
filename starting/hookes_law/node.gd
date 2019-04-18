extends Node2D

var velocity          = Vector2( 0.0, 0.0 )
var previous_position = Vector2( 0.0, 0.0 )
var force             = Vector2( 0.0, 0.0 )
var mass           = 1.0
var mu             = 1.0 # 1./mass
var neighbors      = []
var stiffness      = []
var resting_length = []

export var is_static = false

func _ready():
	previous_position = position - velocity * get_physics_process_delta_time()
	if is_static:
		get_node("sprite").modulate = Color( 1.0, 0.0, 0.0 )

func _physics_process(delta):
	if !is_static:
		verlet( delta )
		
func verlet( delta ):
	get_force()
	var new_position = 2 * position - previous_position + force * pow(delta,2) - (position - previous_position) * 0.005
	previous_position = position
	position = new_position
	velocity = (position - previous_position)/delta 

func get_force():
	force = Vector2( 0.0, 1000.0 )
	var distance = Vector2()
	for i in range(neighbors.size()):
		distance = neighbors[i].position - position
		force += -stiffness[i] * (resting_length[i] 
		- distance.length()) * distance.normalized()

func euler( delta ):
	get_force()
	position += velocity * delta
	velocity += force    * delta
	
func simplectic_euler( delta ):
	get_force()
	velocity += force    * delta
	position += velocity * delta
	
func set_velocity(v):
	velocity          = v
	previous_position = position - velocity * get_physics_process_delta_time()

func set_mass(m):
	mass = m
	mu   = pow( m, -1.0 )
