
extends Camera

var camera_position           = Vector3(0,0,0)
var camera_target             = Vector3(0,0,0)
var camera_up_vector          = Vector3(0,1,0)

var camera_distance_to_center = 5

var yaw         = 0
var pitch       = 25

var sensitivity = 0.05
var scoll_speed = 2

func _ready():
	set_process_input(true)
	set_as_toplevel(true)
	Input.set_mouse_mode( Input.MOUSE_MODE_CAPTURED )

func _physics_process( delta ):
	var x = camera_distance_to_center * sin(deg2rad(yaw)) * cos(deg2rad(pitch))
	var y = camera_distance_to_center * sin(deg2rad(pitch))
	var z = camera_distance_to_center * cos(deg2rad(yaw)) * cos(deg2rad(pitch))

	look_at_from_position( Vector3 ( x, y, z ), camera_target, camera_up_vector )

func _input(event):
	if event is InputEventMouseMotion:
		yaw     += event.relative.x * sensitivity
		pitch    = clamp ( pitch + event.relative.y * sensitivity,-80,80)
		
	if event is InputEventMouseButton:
		if (event.pressed and event.button_index == 4):
			camera_distance_to_center = clamp( camera_distance_to_center - scoll_speed, 4, 400)

		if (event.pressed and event.button_index == 5):
			camera_distance_to_center = clamp( camera_distance_to_center + scoll_speed, 4, 400)
