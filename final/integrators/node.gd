extends Node2D

var velocity          = Vector2( 0.0, 0.0 )
var previous_position = Vector2( 0.0, 0.0 )
var force             = Vector2( 0.0, 0.0 )
var distance          = Vector2( 0.0, 0.0 )

var mass           = 1.0
var mu             = 1.0 # 1./mass
var neighbor       = null
var stiffness      = 10
var resting_length = 150

export var is_static = false

func _ready():
	previous_position = position - velocity * get_physics_process_delta_time()
	if is_static:
		get_node("sprite").modulate = Color( 1.0, 0.0, 0.0 )
	mu = pow(mass, -1.0)
func _physics_process(delta):
	if !is_static:
		simplectic_euler( delta )
		
func verlet( delta ):
	get_force()
	var new_position = 2 * position - previous_position + force * delta * delta
	previous_position = position
	position = new_position
	velocity = (position - previous_position)/delta
	
func euler( delta ):
	get_force()
	position += velocity * delta
	velocity += force * delta
	
func simplectic_euler( delta ):
	get_force()
	velocity += force * delta
	position += velocity * delta
	
func get_force():
	distance = neighbor.position - position
	force = -stiffness * (resting_length - distance.length()) * distance.normalized()
	
func set_velocity(v):
	velocity          = v
	previous_position = position - velocity * get_physics_process_delta_time()

func set_mass(m):
	mass = m
	mu   = pow( m, -1.0 )
	

	