
extends Sprite

var velocity = 0
var timer    = 0
var id       = 0

var gravity = 0
var angle = 0

var time = 0;
var startPos = Vector2(0,0)

var Vx = 0
var Vy = 0

func _ready():
	Vx = velocity*cos(angle) #poczatkowa predkosc pozioma
	Vy = velocity*sin(angle) #poczatkowa predkosc pionowa
	startPos = get_pos()
	set_fixed_process(true)

func _fixed_process(delta):
	time += delta
	var X = Vx * time
	var Y = Vy * time - ((gravity * time * time )/ 2)
	
	X = startPos.x + X
	Y = startPos.y - Y
	set_pos( Vector2(X, Y) )
	
	# destroy on touching ground
	if ((Vector2(X, Y))[1] > 420):
		queue_free()
