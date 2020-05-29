extends Node2D

export(NodePath) var car_path
onready var car = get_node(car_path) as Car2D

func _ready():
	pass
	
func _process(delta):
	update()
#	pass

func _draw():
	
	draw_line(Vector2(0, 250), Vector2(0, -250), Color.white, 1 )
	draw_line(Vector2(-350, 0), Vector2(350, 0), Color.white, 1 )
	for i in 7:
		draw_line(Vector2(-250 + i*100, -250), Vector2(-250 + i*100, 250), Color(1,1,1,0.2), 1 )
	for i in 5:
		draw_line(Vector2(-350, 200-i*100), Vector2(350, 200-i*100), Color(1,1,1,0.2), 1 )
	
	draw_line(Vector2(car.slip_ratio*300, -250), Vector2(car.slip_ratio*300 , 250), Color(0,0,0,1), 5 )
	draw_line(Vector2(-350, -car.longitudal_force/50 ), Vector2( 350, -car.longitudal_force/50 ), Color(1,0,0,1), 5 )
	
	for i in range (-30,30):
		var slip_i0 = -car.get_tyre_force(float(i)/30, car.weight_on_rear_axle) / 50
		var slip_i1 = -car.get_tyre_force(float(i+1)/30, car.weight_on_rear_axle)/ 50
		draw_line( Vector2(i*10, slip_i0), Vector2((i+1)*10, slip_i1 ), Color.blue, 5 )

#func slip_model( slip, vertical_force ):
#
#	var vertical_load = 10 #B Stiffness - dry 10, wet 12, snow 5, ice 4
#	var peak_langitudal_force = 1.9 #C Shape - dry 1.9, wet 2.3, snow 2, ice 2
#	var D = 1 #D Peak - dry 1, wet 0.82, snow 0.3, ice 0.3
#	var E = 0.97 #E Curvature - dry 0.97, wet 1, snow 1, ice 1
#
#	return vertical_force * D * sin( peak_langitudal_force * ( atan ( vertical_load * slip - E * ( vertical_load * slip - atan( vertical_load * slip )))))
