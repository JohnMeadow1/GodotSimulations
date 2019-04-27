#tool
extends Node2D

# mouse drag params 
var selectionDistance := 10.0
var pressed           :bool= false
var selection:PointMass
var prev_mouse_position

# bodies
#var bodies         = [ ]
#var links          = [ ]
var link_object  := load("res://spring.tscn") as PackedScene
var point_object := load("res://node.tscn") as PackedScene


func _ready():
	if !Engine.is_editor_hint():
#		generate_sphere_body( Vector2(512,400), 100 )
		generate_square_body( Vector2(275,75), 100 )
		generate_line(  Vector2(200,100), 300, 10 )

func _process(_delta):
	# mouse drag
	if pressed:
		if selection != null:
			selection.position          = get_global_mouse_position()
			selection.previous_position = get_global_mouse_position()

#	if pressed:
#		for node in get_children():
#			if get_global_mouse_position().distance_to(node.position) < selectionDistance:
#				node.position          += (get_global_mouse_position()-prev_mouse_position) * (1-get_global_mouse_position().distance_to(node.position)/selectionDistance)
#				node.previous_position += (get_global_mouse_position()-prev_mouse_position) * (1-get_global_mouse_position().distance_to(node.position)/selectionDistance)
#	prev_mouse_position = get_global_mouse_position()
	
func _physics_process(delta):
	for node in get_children():
		if !(node as PointMass).is_static:
			(node as PointMass).get_force()

	for node in get_children():
		if !(node as PointMass).is_static:
			(node as PointMass).verlet(delta)
		
#	update()

func add_spring( node_1, node_2 ):
	var link = link_object.instance()
	link.initialize( node_1, node_2 )
	$"../springs".add_child( link )

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			pressed   = true
			selection = null
			for node in get_children():
				if event.position.distance_to(node.position) < selectionDistance:
					selection = node
		else:
			pressed   = false
			selection = null
		
func generate_line( line_position:Vector2, line_length:float, nodes_in_line:int ):
	var previous_point:PointMass 
	for i in range(nodes_in_line):
		var new_point_mass := point_object.instance() as PointMass
		new_point_mass.position = Vector2( 0, i*line_length/nodes_in_line ) + line_position
		add_child(new_point_mass)
		if i > 0:
			add_spring(new_point_mass, previous_point)
		else:
			new_point_mass.is_static = true
		previous_point = new_point_mass
		
func generate_sphere_body( sphere_position:Vector2, radius:float ):
	var center_point := point_object.instance() as PointMass
	center_point.position = sphere_position
	add_child(center_point)
	var previous_point:PointMass 
	for i in range(9):
		var new_point_mass := point_object.instance() as PointMass
		new_point_mass.position = Vector2( sin(i*PI/4.5), cos(i*PI/4.5) ) * radius + sphere_position
		add_child(new_point_mass)
		add_spring(new_point_mass, center_point)
		if i>0:
			add_spring(new_point_mass, previous_point)
		previous_point = new_point_mass
	add_spring(previous_point, get_child(get_child_count()-9))
	
func generate_square_body( square_position:Vector2, size:float ):
	for i in range(10):
		for j in range(10):
			var new_point_mass := point_object.instance() as PointMass
			new_point_mass.position = Vector2( j/4.0, i/4.0 ) * size + square_position
			if i == 0:
				new_point_mass.is_static = true
			add_child(new_point_mass)
	for i in range(10):
		for j in range(10):
			if j < 9:
				add_spring(get_child(get_child_count()-100 + i*10+j ), get_child(get_child_count()-100 + i*10+(j+1) ))
#				if i < 9:
#					add_spring(get_child(get_child_count()-100 + i*10+j ), get_child(get_child_count()-100 + (i+1)*10+(j+1) ))
			if i < 9:
				add_spring(get_child(get_child_count()-100 + i*10+j ), get_child(get_child_count()-100 + (i+1)*10+j ))
#				if j > 0:
#					add_spring(get_child(get_child_count()-100 + i*10+j ), get_child(get_child_count()-100 + (i+1)*10+(j-1) ))

func draw_arrow( from, to, color = Color(1.0, 1.0, 1.0, 0.5) ):
	var arrow_point = PoolVector2Array()
	var color_point = PoolColorArray()
	var vec = to - from
	if vec.length() > 10.0:
		arrow_point.append(to + 5.0  * vec.normalized().tangent())
		color_point.append(color)
		arrow_point.append(to - 5.0  * vec.normalized().tangent())
		color_point.append(color)
		arrow_point.append(to + 10.0 * vec.normalized())
		color_point.append(color)
		draw_line ( from, to, color, 3 )
		draw_polygon(arrow_point,color_point)

#func _draw():
#	for body in bodies:
#		draw_arrow(body.position, body.position + body.velocity)
#
#	if selection != null:  # draw selected point
#		draw_circle( selection.position, 30, Color( 1, 1, 1, 0.3 ) )