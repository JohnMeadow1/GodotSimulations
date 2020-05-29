extends Node2D

export(NodePath) var car_path
onready var car:Car2D = get_node(car_path) as Car2D

var rpm_range := 0.0
var rpm_offset := 0.0
var max_torque_at_rpm := 0.0
var max_torque := 0.0

func _ready():
	rpm_range = float(car.engine_rpm_range) / 1000
	rpm_offset = float(car.engine_rpm_min) / 10

func _process(delta):
	update()

func _draw():
	
	draw_line(Vector2(0, 50), Vector2(0, -500), Color.white, 1 )
	draw_line(Vector2(-50, 0), Vector2(750, 0), Color.white, 1 )
	for i in 7:
		draw_line(Vector2(100 + i*100, 0), Vector2(100 + i*100, -450), Color(1,1,1,0.2), 1 )
	for i in 5:
		draw_line(Vector2(0, -i*100), Vector2(700, -i*100), Color(1,1,1,0.2), 1 )
		
	draw_line(Vector2(car.engine_rpm_current/10, 0), Vector2(car.engine_rpm_current/10, -450), Color(0,1,0,1), 3 )

	var rpm_0 := 0.0
	var rpm_1 := rpm_offset
	var torque_0 := 0.0
	var torque_1 :float = car.engine_torque_curve.interpolate(0.0)
	
	var kW_value_0 := 0.0
#	var kW_value_1 :float = torque_1 * (rpm_1*10 / car.rpm_at_max_torque) / 1.36
	var kW_value_1 :float = torque_1 * rpm_1 * PI / 3000
	
	for i in 99:
		rpm_0 = rpm_1
		rpm_1 = rpm_offset + (i+1) * rpm_range
		torque_0 = torque_1
		torque_1 = car.engine_torque_curve.interpolate(float(i+1)/100)
		
		draw_line( Vector2(rpm_0, -torque_0), Vector2(rpm_1, -torque_1), Color.red, 3 )
		
		kW_value_0 = kW_value_1
#		kW_value_1 = torque_1 * (rpm_1*10 / car.rpm_at_max_torque) / 1.36
		kW_value_1 = torque_1 * rpm_1 * PI / 3000
		
		draw_line( Vector2(rpm_0, -kW_value_0), Vector2(rpm_1, -kW_value_1), Color.magenta, 3 )
		
		
