extends Node2D

var velocity          = Vector2( 0.0, 0.0 )
var previous_position = Vector2( 0.0, 0.0 )
var F                 = Vector2( 0.0, 0.0 )

var mass      = 1.0
var mu        = 1.0 # 1./mass
var neighbors = []
var ks        = []
var ls        = []

export var is_static = false

func _ready():
	previous_position = position - velocity * get_physics_process_delta_time()
	if is_static:
		get_node("sprite").modulate = Color( 1.0, 0.0, 0.0 )

func _physics_process(delta):
	if !is_static:
		verlet(delta)


func set_velocity(v):
	velocity          = v
	previous_position = position - velocity * get_physics_process_delta_time()

func set_mass(m):
	mass = m
	mu   = pow( m, -1.0 )

func euler(delta):
	velocity += force() * mu * delta
	position += velocity * delta

func verlet(delta):
	var new_position  = 2 * position - previous_position + force() * mu * pow( delta , 2.0 )
	previous_position = position
	position          = new_position
	velocity          = ( position - previous_position ) / delta
	
func force():
	F = Vector2( 0.0, 0.0 )
	# TODO: Calculation of forces
	return F 