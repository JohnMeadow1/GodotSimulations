extends Node2D

var input_states = preload("input_states.gd")
var state_fire  = input_states.new("fire")

var gravity = 9.8
var change = 0
var fire_timer = 0
var bulletSpeed = 60

var height = 0

onready var position     = get_pos()

var CurrentOrientation          = 0
var orientation          = 0
var orientation1          = 0

var facing1               = Vector2 ( 0.0, 0.0 )
var facing2               = Vector2 ( 0.0, 0.0 )

var selfPos = Vector2(0, 0)
var bullet               = preload("res://Trajektoria/scenes/Bullet.tscn")

func _ready():
	set_fixed_process(true)

func _fixed_process( delta ):
	process_input( delta )
	
	if (change):
		change = 0
		CurrentOrientation = orientation
	else:
		change = 1
		CurrentOrientation = orientation1
		
	facing1 = Vector2 ( cos( orientation ), -sin( orientation ) )
	facing2 = Vector2 ( cos( orientation1 ), -sin( orientation1 ) )
	set_pos( Vector2(position[0], position[1]-height) )
	update()

func process_input( delta ):

	fire_timer += delta
	if fire_timer > 0.8:
		fire_timer = 0
		create_bullet()

	elif fire_timer < 0.8:
		fire_timer += delta
			
			
	var string = 'Angle 1: ' +str( fmod(rad2deg(orientation),360.0))
	string += '\nAngle 2: ' +str( fmod(rad2deg(orientation1),360.0))
	get_node("../Label").set_text( string )
	
func create_bullet():
	var new_bullet = bullet.instance()
	new_bullet.set_pos( get_pos() )
	new_bullet.velocity = bulletSpeed
	new_bullet.angle = CurrentOrientation
	new_bullet.gravity = gravity
	get_node("../bullets").add_child( new_bullet )
	
func _draw():
	draw_vector( Vector2( 0, 0 ), facing1   * 60     , Color( 1.0, 1.0, 1.0, 0.5 ), 5 )
	draw_vector( Vector2( 0, 0 ), facing2   * 60     , Color( 1.0, 1.0, 1.0, 0.5 ), 5 )

func draw_vector( origin, vector, color, arrow_size ):
	if vector.length_squared() > 1:
		var points    = []
		var direction = vector.normalized()
		points.push_back( vector + direction * arrow_size * 2 )
		points.push_back( vector + direction.rotated(  PI / 2 ) * arrow_size )
		points.push_back( vector + direction.rotated( -PI / 2 ) * arrow_size )
		draw_polygon( Vector2Array( points ), ColorArray( [color] ) )
		draw_line( origin, vector, color, arrow_size )
