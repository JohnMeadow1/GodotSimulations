extends Node2D

var velocity          = Vector2( 0.0, 0.0 )
var previous_position = Vector2( 0.0, 0.0 )
var force             = Vector2( 0.0, 0.0 )
var gravity           = Vector2( 0.0, 100.0 )

var mass      = 1.0
var mu        = 1.0 # 1./mass
export(Array, NodePath) var neighbors:Array = []
var stiffness = []
var resting_length = []

var debug = null

export var is_static = false

func _ready():
	for node in neighbors:
		stiffness.append(100)
		resting_length.append((get_node(node).position - position).length())
		
	previous_position = position - velocity * get_physics_process_delta_time()
	if is_static:
		get_node("sprite").modulate = Color( 1.0, 0.0, 0.0 )
#	debug = get_node("../../CanvasLayer/Debug")
	
func _physics_process( delta ):
	if !is_static:
		verlet( delta )
		
func get_force():
	force = Vector2()
	var distance = Vector2()
	for i in range( neighbors.size() ):
		distance = position - get_node(neighbors[i]).position
		force += -stiffness[i] * (distance.length() - resting_length[i])        \
		* distance.normalized() + gravity

func euler( delta ):
	get_force()
	position += velocity * delta
	velocity += ( force + gravity )  * delta - velocity * 0.01
		
func siplectic_euler( delta ):
	get_force()
	velocity += force  * delta
	position += velocity * delta 

func verlet( delta ):
	get_force()
	velocity = (position - previous_position)
	var new_position = (2*position - previous_position) + force * pow(delta,2) - velocity*0.01
	previous_position = position
	position = new_position
	
func set_velocity(v):
	velocity          = v
	previous_position = position - velocity * get_physics_process_delta_time()

func set_mass(m):
	mass = m
	mu   = pow( m, -1.0 )
