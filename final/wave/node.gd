extends Node2D

var velocity          = 0
var previous_position = 0
var start_position    = 0
var F                 = 0
var left_delta        = 0
var right_delta       = 0

var damping          = 0.125
var mass             = 1.0
var mu               = 1.0 # 1./mass
var stiffness        = 0
var rest_depth       = 0


func _ready():
	previous_position = position.y - velocity * get_physics_process_delta_time()

func _physics_process(delta):
#	euler(delta)
	verlet(delta)

func set_velocity( new_value ):
	velocity          = new_value
	previous_position = position.y - velocity * get_physics_process_delta_time()

func set_mass( new_value ):
	mass = new_value
	mu   = pow( new_value, -1.0 )

func set_stiffness( new_value ):
	stiffness = new_value
	
func set_damping( new_value ):
	damping = new_value

func euler(delta):
	velocity   += force() * mu * delta
	position.y += velocity * delta

func verlet(delta):
	var new_position  = 2 * position.y - previous_position + force() * mu * pow( delta , 2.0 )
	previous_position = position.y
	position.y        = new_position
	velocity          = ( position.y - previous_position ) / delta
	
func force():
	var direction = start_position - position.y
	F = -stiffness * ( rest_depth - direction )
	return clamp(F, -500, 500) - damping * velocity