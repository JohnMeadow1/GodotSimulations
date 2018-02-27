extends Node2D

var velocity       = Vector2( 120.0, 0.0 )
var force          = Vector2( 0.0  , 0.0 )
var mass           = 1000.0
var mass_rocket    = 100.0
var shoot_velocity = -50.0

var rocket_object = load("res://rocket.tscn")

# target position
onready var target              = $"../target".position
onready var rocket_spawn_offset = $plane/rocket.position

func _ready():
	pass

func _physics_process(delta):
	velocity += force    * delta
	position += velocity * delta
	
	if self.position[0] < 0 :
		$plane.scale.x = $plane.scale.x * -1
		velocity      *= -1
	if self.position[0] > get_viewport_rect().size.x :
		$plane.scale.x = $plane.scale.x * -1
		velocity      *= -1

func _process(delta):
	update()
	
func _input(event):
	if event.is_action_pressed("release_rocket"):
		release_rocket()

func release_rocket():
	if mass > mass_rocket:
		var new_rocket      = rocket_object.instance()
		new_rocket.velocity = velocity + shoot_velocity * velocity.normalized()
		new_rocket.position = position + rocket_spawn_offset
		
		mass               -= mass_rocket
		velocity           -= (mass_rocket / mass) * (shoot_velocity * velocity.normalized())
	
		get_parent().add_child( new_rocket )
		
func _draw():
	draw_line ( Vector2(0,0), velocity, Color( 1.0, 1.0, 0.0, 0.5 ), 3 )