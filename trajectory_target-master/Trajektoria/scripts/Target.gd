extends Node2D
var input_states = preload("input_states.gd")

var positionX     = 0

var velocity             = Vector2( 0.0, 0.0 )
var thrust = 0

onready var gun = get_node("../gun")
onready var bigLabel = get_node("../NoReach")
var angle1 = 0
var angle2 = 0

var startVelocity = 0
var gravity = 0

var state_left  = input_states.new("left")
var state_right = input_states.new("right")

func _ready():
	set_fixed_process(true)

func _fixed_process( delta ):
	process_input( delta )
	
func process_input( delta ):

	var pos = get_pos ()
	set_pos(Vector2(positionX, pos[1]))
	
	var x = positionX - gun.get_pos()[0]
	var y = - pos[1] + gun.get_pos()[1]

	var v2 = pow(startVelocity,2)
	var v4 = v2 * v2
	var toSqrt = v4 - gravity * (gravity * x * x + 2 * v2 * y)
	var sqrtS = sqrt(toSqrt)
	
	var angleInDeg1 = (v2 + sqrtS) / (gravity * x)
	angle1 = atan(angleInDeg1)
	
	var angleInDeg2 = (v2 - sqrtS) / (gravity * x)
	angle2 = atan(angleInDeg2)

	if toSqrt >= 0:
		gun.orientation = angle1
		gun.orientation1 = angle2
		bigLabel.set_text("")
	else:
		bigLabel.set_text("Velocity is too small or gravity is too big or target is too far away. Can't reach :(")
