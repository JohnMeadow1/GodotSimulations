extends Node2D

export(NodePath) var car_path
onready var car:Car2D = get_node(car_path) as Car2D

var drag = []
var roll = []
var traction = 0.0
var counter := 0

func _process(delta):
	if counter > 600:
		drag.pop_front()
		roll.pop_front()
	else:
		counter+=1
	drag.append(car.drag_force * 0.2)
	roll.append(car.rolling_resistance * 0.2)
	traction = car.traction_torque * 0.2
	update()

func _draw():
	draw_line(Vector2(0, 50), Vector2(0, -500), Color.white, 1 )
	draw_line(Vector2(-50, 0), Vector2(750, 0), Color.white, 1 )
	for i in 7:
		draw_line(Vector2(100 + i*100, 0), Vector2(100 + i*100, -450), Color(1,1,1,0.2), 1 )
	for i in 5:
		draw_line(Vector2(0, -i*100), Vector2(700, -i*100), Color(1,1,1,0.2), 1 )
	
	draw_line(Vector2(0, -traction), Vector2(600, -traction), Color.blue, 3 )
	
	for i in counter-1:
		draw_line(Vector2(i,-drag[i]), Vector2(i+1,-drag[i+1]), Color.magenta, 3 )
		draw_line(Vector2(i,-roll[i]), Vector2(i+1,-roll[i+1]), Color.yellow, 3 )
		draw_line(Vector2(i,-roll[i]-drag[i]), Vector2(i+1,-roll[i+1]-drag[i+1]), Color.cyan, 3 )
