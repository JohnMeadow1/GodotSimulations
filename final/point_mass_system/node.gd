tool
extends Node2D
class_name PointMass


var velocity          := Vector2( 0.0, 0.0 )
var previous_position := Vector2( 0.0, 0.0 )
var force             := Vector2( 0.0, 0.0 )
#var gravity           := Vector2( 0.0, 1000.0 )

#var mass:float      = 1.0 setget set_mass
var mu:float        = 10.0 # 1./mass
var neighbors:Array = []
#var stiffness:float = 1000.0
var resting_length:Array = []

#onready var debug = get_node("../../GUI/Debug")

export(bool) var is_static:bool = false setget set_static
func set_static(value):
	is_static = value
	if is_static:
		get_node("sprite").modulate = Color( 1.0, 0.0, 0.0 )
	else:
		get_node("sprite").modulate = Color( 1.0, 1.0, 1.0 )

func add_neighbor(point_mass):
	neighbors.append(point_mass)
	resting_length.append((point_mass.position - position).length())

func _ready():
	previous_position = position - velocity * get_physics_process_delta_time()
	
#func _process(delta):
#	update()

#func _physics_process( delta ):
#	if !Engine.is_editor_hint() && !is_static:
#		symplectic_euler( delta )

func get_force():
	force = Vector2()
	for i in range( neighbors.size() ):
		var distance = neighbors[i].position - position
		var difference = distance.length() - resting_length[i]
		var relative_velocity = neighbors[i].velocity - velocity
		
		var spring_damping = relative_velocity.project(distance)
		
		# use for cloth stretching
		if difference > 0:
			# spring stiffness
			force += globals.stiffness * difference * distance.normalized()
			# spring damping
			force += spring_damping * 1
			
		# use for soft body
#		# spring stiffness
#		force += globals.stiffness * difference * distance.normalized()
#		# spring damping
#		force += spring_damping * 1
	
	# gravity
	force += globals.gravity
	# medium damping
	force -= velocity * globals.medium_damping

func euler( delta ):
#	get_force()
	position += velocity * delta
	velocity += force * delta 
		
func symplectic_euler( delta ):
#	get_force()
	velocity += force * delta
	position += velocity * delta 

func verlet( delta ):
#	get_force()
	var new_position  = 2*position - previous_position 
	new_position     += force * pow( delta, 2.0 )
	
	previous_position = position
	position          = new_position
	velocity          = (position - previous_position)/delta
	
func set_velocity(v):
	velocity          = v
	previous_position = position - velocity * get_physics_process_delta_time()

#func set_mass(m):
#	mass = m
#	mu   = pow( m, -1.0 )

#func _draw():
#	draw_line(Vector2(),damping*100, Color.black,5)
