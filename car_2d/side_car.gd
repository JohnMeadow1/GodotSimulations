extends Node2D

export(NodePath) var car_path
onready var car:Car2D  = get_node(car_path) as Car2D

onready var axle_front    :Vector2 = $tyre_front.position 
onready var axle_rear     :Vector2 = $tyre_rear.position 
onready var contact_front :Vector2 = $contact_front.position 
onready var contact_rear  :Vector2 = $contact_rear.position 

var weight_front_to_rear_ratio := 0.0
var speed_to_wheel_rotation := 0.0
var wheel_speed_front := 0.0
var wheel_speed_rear  := 0.0


func _ready():
	weight_front_to_rear_ratio = car.weight_on_rear_axle / car.weight_on_front_axle
	
func _process(delta):
	speed_to_wheel_rotation = car.speed_longitudal / car.wheel_radius
	wheel_speed_rear = car.wheel_angular_speed
#	print (speed_to_wheel_rotation)
#	print (wheel_speed_rear)

	$particle_rear.set("initial_velocity", (wheel_speed_rear - speed_to_wheel_rotation) * 10)
	$particle_front.set("initial_velocity", (wheel_speed_rear - speed_to_wheel_rotation) * 10)

	if wheel_speed_rear > speed_to_wheel_rotation:
		if $particle_rear.emitting:
			$particle_rear.emitting  = false
#		if $particle_front.emitting:
#			$particle_front.emitting = false
	else:
		if !$particle_rear.emitting:
			$particle_rear.emitting  = true
#		if !$particle_front.emitting:
#			$particle_front.emitting = true
	
	
	$body.rotation = (weight_front_to_rear_ratio - (car.weight_on_rear_axle / car.weight_on_front_axle)) / 31.4
	$tyre_rear.rotate(wheel_speed_rear * delta)
	$tyre_front.rotate(speed_to_wheel_rotation * delta)
	update()

func _draw():
	
	draw_line(contact_front, contact_front - Vector2(car.brake_torque*0.01, 0), Color.white, 3)
	draw_line(contact_rear, contact_rear + Vector2(car.drive_torque*0.01, 0), Color.white, 3)
	
	draw_line(axle_front, axle_front - Vector2(0, car.weight_on_front_axle)/200, Color.from_hsv(car.weight_on_front_axle/(car.mass*car.gravity),1,1,0.5), 6 )
	draw_line(axle_rear, axle_rear - Vector2(0, car.weight_on_rear_axle)/200, Color.from_hsv(car.weight_on_rear_axle/(car.mass*car.gravity),1,1,0.5), 6 )

		
