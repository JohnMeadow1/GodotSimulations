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
		pass

func set_velocity(v):
	velocity          = v
	previous_position = position - velocity * get_physics_process_delta_time()

func set_mass(m):
	mass = m
	mu   = pow( m, -1.0 )
