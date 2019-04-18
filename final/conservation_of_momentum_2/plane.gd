extends Node2D

var velocity       = Vector2( 120.0, 0.0 )
var force          = Vector2( 0.0  , 0.0 )
var mass           = 1000.0
var mass_rocket    = 100.0
var drop_velocity  = Vector2( 35.0 , 35.0 )
var infinitesimal  = Transform2D(0.05, Vector2(0.0,0.0))

var rocket_object = load("res://rocket.tscn")

# target position
onready var target              = $"../target".position
onready var rocket_spawn_offset = $plane/rocket.position

# are the keys "↑" or "↓" pressed
var CHANGE_DROP_VELOCITY_CLCKWS = false
var CHANGE_DROP_VELOCITY_CNTRCLCKWS = false

func _ready():
	pass

func _physics_process(delta):
#	TODO: solve the equation of motion
#	position += velocity * delta
	
	if self.position[0] < 0 :
		$plane.scale.x = $plane.scale.x * -1
		velocity      *= -1
	if self.position[0] > get_viewport_rect().size.x :
		$plane.scale.x = $plane.scale.x * -1
		velocity      *= -1

func _process(delta):
	if CHANGE_DROP_VELOCITY_CLCKWS:
		drop_velocity = infinitesimal.xform_inv(drop_velocity)
	if CHANGE_DROP_VELOCITY_CNTRCLCKWS:
		drop_velocity = infinitesimal.xform(drop_velocity)
	update()
	
func _input(event):
	if event.is_action_pressed("release_rocket"):
		release_rocket()
	if event.is_action_pressed("rot_velocity_clockwise"):
		CHANGE_DROP_VELOCITY_CLCKWS = true
	if event.is_action_released("rot_velocity_clockwise"):
		CHANGE_DROP_VELOCITY_CLCKWS = false
	if event.is_action_pressed("rot_velocity_counter_clockwise"):
		CHANGE_DROP_VELOCITY_CNTRCLCKWS = true
	if event.is_action_released("rot_velocity_counter_clockwise"):
		CHANGE_DROP_VELOCITY_CNTRCLCKWS = false

func release_rocket():
	if mass > mass_rocket:
		var new_rocket      = rocket_object.instance()
		new_rocket.position = position + rocket_spawn_offset
		# TODO: set starting velocity for new_rocket
		# TODO: satisfy the conservation of momentum principle:
		#		(i)   for bomb being dropped
		#		(ii)  for bomb being thrown in the direction oposite to plane's velocity
		#		(iii) for bomb being thrown in any direction
		get_parent().add_child( new_rocket )
		
func _draw():
	var arrow_point = PoolVector2Array()
	var color_point = PoolColorArray()
	arrow_point.append(velocity + 5.0*velocity.normalized().tangent())
	color_point.append(Color(0.56, 0.89, 0.42, 0.7))
	arrow_point.append(velocity - 5.0*velocity.normalized().tangent())
	color_point.append(Color(0.56, 0.89, 0.42, 0.7))
	arrow_point.append(velocity + 10.0*velocity.normalized())
	color_point.append(Color(0.56, 0.89, 0.42, 0.7))
	draw_line ( Vector2(0,0), velocity, Color( 0.56, 0.89, 0.42, 0.7 ), 3 )
	draw_polygon(arrow_point,color_point)
	
	var arrow_point2 = PoolVector2Array()
	var color_point2 = PoolColorArray()
	arrow_point2.append(drop_velocity + 5.0*drop_velocity.normalized().tangent())
	color_point2.append(Color(0.42, 0.42, 0.95, 0.7))
	arrow_point2.append(drop_velocity - 5.0*drop_velocity.normalized().tangent())
	color_point2.append(Color(0.42, 0.42, 0.95, 0.7))
	arrow_point2.append(drop_velocity + 10.0*drop_velocity.normalized())
	color_point2.append(Color(0.42, 0.42, 0.95, 0.7))
	draw_line ( Vector2(0,0), drop_velocity, Color(0.42, 0.42, 0.95, 0.7), 3 )
	draw_polygon(arrow_point2,color_point2)