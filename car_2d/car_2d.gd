extends Node2D
class_name Car2D

var gravity := 9.8 #m/s sqared
# engine specification
var engine_rpm_max := 6000 #revolution
var engine_rpm_min := 1000 #revolution
var engine_rpm_range := float(engine_rpm_max - engine_rpm_min) #revolution
export(Curve) var engine_torque_curve:Curve #curve engine model 

# car specification
var car_length            := 4.7 #meter
var pixel_per_meter       := 20.0 #car length in pixels / meter
var center_of_mass_height := 1.0 #meter from ground
var mass                  := 1500.0 #Kilogram
var gear_box              := [0.0, 2.66, 1.78, 1.30, 1.0, 0.74, 0.5, 2.90] # gear ratio (last one is reverse gear ratio)
var gear_max              := 6 #number of gears forward
var differential_ratio    := 3.42 #crankshaft rotations per wheel turn
var transimission_efficiecny := 0.7 #transmission eficiency 1 = 100%

# wheel data
var wheel_radius     := 0.34 #meter
var wheel_mass       := 30  #kg

var tyre_grip_coefficient := 1.0 #tyre grip coefficient range (1.0 - 1.5)
var tyre_pressure         := 2.9 #bar

# wheel calculations
var wheelbase           := 0.0 #meter - calculated form axle distance
var axle_front_distance := 0.0 #meter - calculated distance of front axle form center of mass 
var axle_rear_distance  := 0.0 #meter - calculated distance of rear axle form center of mass 
var wheel_angular_speed := 0.0 #radians/sec
var wheel_rpm           := 0.0 #rpm
var wheel_angular_acceleration := 0.0 #radians/sec^2
var wheel_inertia       := 0.0
var drive_inertia       := 0.0

# turning
var wheel_turn_speed := 0.1 #lerp ratio - truning speed of front wheels (1 is instantaneous)
var wheel_turn_max   := deg2rad(30) #radians - max turn angle (30 degress)
var wheel_turn       := 0.0 #radians - current wheel turn angle

# drag data
var front_area          := 2.0 #meter squared - area of front of the car
var air_density         := 1.29 #kilograms per meters cubed
var drag_coefficient    := 0.32 #measure of aerodynamics
var drag_force          := 0.0 #Niuton

# rolling resistance 
var rolling_coefficient := 0.0 #coefficient of rolling
var rolling_resistance  := 0.0 #Niuton

# car calculations
var speed            := 0.0 #m/s
var speed_lateral    := 0.0 #m/s
var speed_longitudal := 0.0 #m/s
var velocity         := Vector2() #m/s
var acceleration     := 0.0 #m/s^2

var orientation      := 0.0 #radians
var facing           := Vector2() #unit vector

var weight_on_front_axle := 0.0 #kg
var weight_on_rear_axle  := 0.0 #kg

var engine_torque      := 0.0 #Niutonometr
var rpm_at_max_torque  := 0.0 #revolutions per minute
var drive_torque       := 0.0 #Niutonometr
var traction_torque    := 0.0 #Niutonometr

var total_torque       := 0.0 #Niutonometr 

var brake_torque       := 0.0 #Niutonometr
var traction_force     := Vector2() #Niuton
var total_force        := 0.0 #Niuton
var drive_force        := 0.0 #Niuton
var longitudal_force   := 0.0 #Niuton
var engine_rpm_current := 0.0 #revolutions per minute
var engine_angular_speed := 0.0 #radians/sec

var slip_ratio         := 0.0

# stering data
var is_accelerate := false
var is_brake      := false
var gear_current := 0
var throttle     := 0.0
var brake        := 0.0
var engine_effect :AudioEffect
func _ready():
	calculate_rpm_at_max_torque()
	
	wheelbase = ($body/wheel_fl.global_position.x - $body/wheel_rl.global_position.x) 
	wheelbase /= pixel_per_meter
	
	axle_front_distance = abs($body/wheel_fl.global_position.x - global_position.x) 
	axle_front_distance /= pixel_per_meter
	
	axle_rear_distance  = abs($body/wheel_rl.global_position.x - global_position.x)
	axle_rear_distance /= pixel_per_meter
	
	calculate_weight_distribution()
	
#	wheel_inertia = wheel_mass * pow(wheel_radius, 2) / 2.0 
	wheel_inertia = wheel_mass * pow(wheel_radius, 2) # for 2 wheels
	drive_inertia = 300.0 * pow(0.2, 2) / 2.0
	$engine.play()
	engine_effect = AudioServer.get_bus_effect ( 0, 0 )
	
func _process( delta ):
	process_input()
#	is_accelerate = true
	process_stering( delta )
	
#	throttle = 0.01
	calculate_weight_distribution()
	
	facing = Vector2( cos(orientation), sin(orientation) )
	speed = velocity.length()
	speed_longitudal = velocity.x
	
	drag_force         = get_drag_at_speed( speed )
	rolling_resistance = get_rolling_resistance_at_speed( speed )

	engine_torque = throttle * get_engine_torque_at_rpm( engine_rpm_current )
	
	engine_rpm_current   = get_engine_rpm( wheel_rpm )
	$engine.pitch_scale  = max(1 +( (engine_rpm_current-engine_rpm_min) / engine_rpm_range) * 2, 0.01)
	
	engine_effect.set("pitch_scale", 1 - (max(0,(engine_rpm_current-engine_rpm_min)) / engine_rpm_range)*0.2)
	
#	var engine_rpm_current2 =  wheel_angular_speed * gear_box[gear_current] *differential_ratio * 60/TAU  

	engine_angular_speed = engine_rpm_current / 60.0

	drive_torque = get_drive_torque()
	brake_torque = get_brake_torque()
	drive_force = drive_torque / wheel_radius
	 
	traction_torque = min(drive_torque, weight_on_rear_axle)
	total_torque    = traction_torque - brake_torque
	
	wheel_angular_speed = speed_longitudal / wheel_radius
	
	wheel_angular_acceleration = total_torque / (wheel_inertia )
#	wheel_angular_acceleration = total_torque / wheel_inertia / drive_inertia
	wheel_angular_speed += wheel_angular_acceleration * delta
	wheel_rpm = wheel_angular_speed * 60 / TAU
	
	var effective_wheel_radius = wheel_radius
	if abs(speed_longitudal) > 0 :
#		slip_ratio = (wheel_angular_speed * effective_wheel_radius - speed_longitudal) / speed_longitudal
		slip_ratio = (wheel_angular_speed * effective_wheel_radius) / abs(speed_longitudal) - 1.0
	else:
		slip_ratio = (wheel_angular_speed * effective_wheel_radius)
		
	longitudal_force = get_tyre_force( slip_ratio, weight_on_rear_axle )
	longitudal_force = longitudal_force
#	longitudal_force = total_torque/ wheel_radius 

	total_force = longitudal_force - drag_force - rolling_resistance

	acceleration = total_force / mass
	
	velocity += acceleration * facing * delta
	position += velocity * pixel_per_meter * delta
	
	$body/wheel_fl.rotation = wheel_turn
	$body/wheel_fr.rotation = wheel_turn
	
	print_debug_data()
	update()

func print_debug_data():
	$Label.text = "Speed: %5.2f kph %5.2f mps" % [ speed * 3.6, speed ]
	$Label.text += "\nAccel: %05.2f m/s (%2.1f G)" % [ acceleration, acceleration / gravity ]
	$Label.text += "\nEngine: %4d gear: %1d" % [ engine_rpm_current, gear_current ]
	$Label.text += "\nWheel : %4d RPM Ratio: %3.1f" % [ wheel_rpm, gear_box[gear_current] * differential_ratio ]
	$Label.text += "\nEngine: %5.2f N " % [engine_torque]  
#	$Label.text += "\nDrive: %5.2f N" % ( drive_torque )
#	$Label.text += "\nBreak: %5.2f N" % ( brake_torque )
#	$Label.text += "\nTraction: %5.2f N" % ( traction_torque )
#	$Label.text += "\nTotal: %5.2f N" % ( total_torque )
#	$Label.text += "\nLongitudal F: %5.2f " % ( longitudal_force )
	$Label.text += "\nTotal F: %5.2f N" % ( total_force )
	$Label.text += "\nWeight: %5.1f, R: %5.1f N" % [weight_on_front_axle , weight_on_rear_axle ]
	$Label.text += "\nSlip ratio: %5.2f " % ( slip_ratio )
#	$Label.text += "\nroll_coeff F: %1.5f " % ( rolling_coefficient )
	$Label.text += "\nwheel s : %5.2f " % ( wheel_angular_speed )
	$Label.text += "\nwheel a : %5.2f " % ( wheel_angular_acceleration )

func calculate_weight_distribution():
	weight_on_front_axle = axle_rear_distance / wheelbase * mass * gravity
	weight_on_front_axle -= center_of_mass_height / wheelbase * mass * acceleration

	weight_on_rear_axle  =  axle_front_distance / wheelbase * mass * gravity
	weight_on_rear_axle  += center_of_mass_height / wheelbase * mass * acceleration
	
func get_drag_at_speed( speed_value ):
	return 0.5 * drag_coefficient * front_area * air_density * speed_value * speed_value

func get_engine_rpm (wheel_rpm_value):
#	wheel_angular_speed * gear_box[gear_current] *differential_ratio * 60/TAU 
	if gear_current > 0:
		return wheel_rpm_value * gear_box[gear_current] * differential_ratio
	else:
		var rpm_value = lerp(engine_rpm_current, engine_rpm_min, 0.02)
		if is_accelerate:
			if throttle * engine_rpm_range + engine_rpm_min > engine_rpm_current:
				rpm_value = throttle * engine_rpm_range + engine_rpm_min
		return rpm_value

func get_rolling_resistance_at_speed( speed_value ):
	#mesure of tyre friction:
	# 0.01 - 0.015 - car tyre on asphalt, 
	# 0.002 - 0.005 - low resistance tubeless tires
	rolling_coefficient = 0.005 + (1.0/tyre_pressure) * (0.01 + 0.0095 * pow(speed_value / 100.0, 2) )
#	rolling_coefficient = 0.005 + (1.0/tyre_pressure) * (0.01 + 0.0095 * pow(speed_value*3.6/100.0, 2) )
#	return rolling_coefficient * mass * gravity * speed_value
	return rolling_coefficient * speed_value

func get_tyre_force( slip, vertical_force ):
	var vertical_load = 10 #B Stiffness - dry 10, wet 12, snow 5, ice 4
	var shape = 1.9 #C Shape - dry 1.9, wet 2.3, snow 2, ice 2
	var peak = 1 #D Peak - dry 1, wet 0.82, snow 0.3, ice 0.3
	var curvature = 0.97 #E Curvature - dry 0.97, wet 1, snow 1, ice 1
	var road_coefficient = 1.0
	return vertical_force * peak * sin( shape * ( atan ( vertical_load * slip - curvature * ( vertical_load * slip - atan( vertical_load * slip ))))) * road_coefficient
	
func get_engine_torque_at_rpm( rpm_value ):
	rpm_value -= engine_rpm_min
	rpm_value = float(rpm_value)/engine_rpm_range 
	return engine_torque_curve.interpolate(rpm_value) * throttle
	
func get_drive_torque_at_rpm( rpm_value, gear_value ):
	return get_engine_torque_at_rpm( rpm_value ) * gear_box[gear_value] * differential_ratio * transimission_efficiecny

func get_brake_torque():
	return clamp(brake * tyre_grip_coefficient * weight_on_front_axle *  speed_longitudal, -weight_on_front_axle, weight_on_front_axle)

func get_drive_torque():
	if gear_current:
		if engine_rpm_current > engine_rpm_max :
			return 0
		elif engine_rpm_current < engine_rpm_min:
			return get_drive_torque_at_rpm(lerp( engine_rpm_current, engine_rpm_min, 0.1), gear_current) 
		else:
			return get_drive_torque_at_rpm(engine_rpm_current, gear_current)
	else:
		return 0
	
func calculate_rpm_at_max_torque():
	var max_value := 0.0
	for i in 100:
		var i_norm =  float(i)/100
		if engine_torque_curve.interpolate_baked(i_norm) > max_value:
			max_value = engine_torque_curve.interpolate_baked(i_norm)
			rpm_at_max_torque = i_norm * engine_rpm_range + engine_rpm_min

func process_input():
	if Input.is_action_pressed("ui_left"):
		wheel_turn = lerp(wheel_turn, -wheel_turn_max, wheel_turn_speed)
		
	if Input.is_action_pressed("ui_right"):
		wheel_turn = lerp(wheel_turn, wheel_turn_max, wheel_turn_speed)
		
	# brake
	is_brake = false
	if Input.is_action_pressed("ui_down"):
		is_brake = true
		
	# handbrake
	if Input.is_action_pressed("ui_select"):
		pass
	# accelerate
	is_accelerate = false
	if Input.is_action_pressed("ui_up"):
		is_accelerate = true

	if Input.is_action_just_pressed("shift_up"):
		if gear_current == (gear_max + 1):
			gear_current = 0
		elif gear_current < gear_max:
			gear_current += 1
			
	if Input.is_action_just_pressed("shift_down"):
		if gear_current == 0:
			gear_current = gear_max + 1
		elif gear_current <= gear_max:
			gear_current -= 1

func process_stering(delta):
	if is_accelerate:
		throttle = lerp(throttle, 1, 0.075)
	else:
		throttle = lerp(throttle, 0, 0.5)
	
	if is_brake:
		brake = lerp(brake, 1, 0.1)
	else:
		brake = lerp(brake, 0, 0.5)

func _draw():
	var front = Vector2.ZERO
	front.x = $body/wheel_fl.global_position.x - position.x
	
	var rear = Vector2.ZERO
	rear.x = $body/wheel_rl.global_position.x - position.x
	
	draw_circle(front,weight_on_front_axle * 0.005, Color.from_hsv(1,1,1,0.4) )
	draw_circle(rear, weight_on_rear_axle * 0.005,  Color.from_hsv(1,1,1,0.4) )
	
	
	
	
