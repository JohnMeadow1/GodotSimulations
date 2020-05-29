extends Node2D

export(NodePath) var car_path
onready var car = get_node(car_path) as Car2D

var rpm_range := 0.0
var rpm_offset := 0.0
var max_torque_at_rpm := 0.0
var max_torque := 0.0

func _ready():
	rpm_range = float(car.engine_rpm_range) / 1000
	rpm_offset = float(car.engine_rpm_min) / 10
	
func _process(delta):
	update()
#	pass

func _draw():
	
	draw_line(Vector2(0, 50), Vector2(0, -500), Color.white, 1 )
	draw_line(Vector2(-50, 0), Vector2(750, 0), Color.white, 1 )
	for i in 7:
		draw_line(Vector2(100 + i*100, 0), Vector2(100 + i*100, -450), Color(1,1,1,0.2), 1 )
	for i in 5:
		draw_line(Vector2(0, -i*100), Vector2(700, -i*100), Color(1,1,1,0.2), 1 )
	
	var effective_rpm = car.engine_rpm_current / max((car.gear_box[car.gear_current] * car.differential_ratio), 1)
	draw_line(Vector2(effective_rpm/10, 0), Vector2(effective_rpm/10 , -450), Color(0,1,0,1), 3 )

	for k in car.gear_max+1:
		var rpm_multiplier :float = 0.0
		if k == 0:
			rpm_multiplier = 1
		else:
			rpm_multiplier = car.gear_box[k] * car.differential_ratio
		
		var rpm_0 := 0.0
		var rpm_1 := rpm_offset / rpm_multiplier 
		var torque_0 := 0.0
		var torque_1 :float = car.engine_torque_curve.interpolate(0.0) * rpm_multiplier / 10
		
		for i in 99:
			rpm_0 = rpm_1
			rpm_1 = rpm_offset / rpm_multiplier + ((i+1) / rpm_multiplier) * rpm_range
			torque_0 = torque_1
			torque_1 = car.engine_torque_curve.interpolate(float(i+1)/100) * rpm_multiplier / 10
			
			draw_line( Vector2(rpm_0, -torque_0), Vector2(rpm_1, -torque_1), Color.from_hsv(float(k)/(car.gear_max+1),1,1), 3 )
		
		
