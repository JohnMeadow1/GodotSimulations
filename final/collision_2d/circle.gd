extends Node2D
class_name Circle
export(int)   var radius = 20
export(float) var mass = 10.0
export(float) var restitution    = 1.0
export(float) var friction       = 0.0
export(float) var angular_velocity   = 0
export(Vector2)var velocity      = Vector2.ZERO

var mass_invert:float = 0.0
var inertia:float     = 0.0 


func _ready():
#	velocity = Vector2(rand_range(-150,150),rand_range(-150,150))
	mass = max( mass, 0.01 )
	mass_invert = 1.0 / mass
	inertia = pow( radius, 2.0 ) * mass * 0.4

func _physics_process( delta ):
	check_window_boundry( delta )
	position += velocity * delta
	rotation += angular_velocity * delta
	$Position2D.rotation = -rotation
	$Position2D/velocity.text = str(velocity.length()) +"\n" +str(angular_velocity) 
	update()

func _draw():
	draw_circle(Vector2.ZERO, radius, Color(0.5, 0.5, 0.5) * mass )
	draw_line(Vector2.ZERO, Vector2(radius, 0), Color.black)

func check_window_boundry( delta ):
	if position.x + (velocity.x * delta) >= get_viewport_rect().size.x-radius:
		velocity.x *= -1
	if position.x + (velocity.x * delta) <= radius:
		velocity.x *= -1
	if position.y + (velocity.y * delta) >= get_viewport_rect().size.y-radius:
		velocity.y *= -1
	if position.y + (velocity.y * delta) <= radius:
		velocity.y *= -1
		
#	if position.x + (velocity.x * delta) >= get_viewport_rect().size.x-radius:
#		position.x -= get_viewport_rect().size.x
#	if position.x + (velocity.x * delta) <= radius:
#		position.x += get_viewport_rect().size.x
#	if position.y + (velocity.y * delta) >= get_viewport_rect().size.y-radius:
#		position.y -= get_viewport_rect().size.y
#	if position.y + (velocity.y * delta) <= radius:
#		position.y += get_viewport_rect().size.y