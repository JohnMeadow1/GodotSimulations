#tool
extends Node2D

# mouse drag params 
var selectionDistance := 10.0
var pressed           :bool= false
var selection:PointMass
var prev_mouse_position

var link_object  := load("res://spring.tscn") as PackedScene
var point_object := load("res://node.tscn")   as PackedScene

func _ready():
	if !Engine.is_editor_hint():
#		generate_sphere_body( Vector2(512,400), 50, 8 )
		generate_square_body( Vector2(275,75), Vector2(20,16), Vector2(20,20)  )
		generate_line( Vector2(200,100), 2, 30 )
		globals.debug = get_node("../GUI/Debug")

func _process(_delta):
	# mouse drag
#	if pressed:
#		if selection != null:
#			selection.position          = get_global_mouse_position()
#			selection.previous_position = get_global_mouse_position()
#			selection.velocity          = Vector2()

	if pressed:
		for node in get_children():
			if get_global_mouse_position().distance_to(node.position) < selectionDistance*selectionDistance:
				node.position          += (get_global_mouse_position()-prev_mouse_position) * (1-get_global_mouse_position().distance_to(node.position)/(selectionDistance*selectionDistance))
				node.previous_position += (get_global_mouse_position()-prev_mouse_position) * (1-get_global_mouse_position().distance_to(node.position)/(selectionDistance*selectionDistance))
	prev_mouse_position = get_global_mouse_position()

func _physics_process(delta):
	for child in get_children():
		if !child.is_static:
			child.get_force()
		
	for child in get_children():
		if !child.is_static:
			child.verlet(delta)

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
		
func generate_line( line_position:Vector2, node_spacing:float, nodes_in_line:int ):
	var previous_point:PointMass
	for i in range(nodes_in_line):
		var new_point := point_object.instance()
		new_point.position = Vector2( i * node_spacing, 0 ) + line_position
		add_child(new_point)
		if i>0:
			add_spring(new_point,previous_point)
		else:
			new_point.is_static = true
		previous_point = new_point
		
func generate_sphere_body( sphere_position:Vector2, radius:float, nodes_count:int ):
	
	var center_point := point_object.instance()
	center_point.position += sphere_position
	add_child(center_point)
	var deg_node = deg2rad(360.0 / nodes_count)
	for i in range(nodes_count):
		var new_point := point_object.instance()
		new_point.position = Vector2( sin(i*deg_node), cos(i*deg_node) ) * radius 
		new_point.position += sphere_position
		add_child(new_point)
		add_spring(new_point,center_point)
		if i >0:
			add_spring(new_point,get_child(get_child_count()-2))
	add_spring(get_child(get_child_count()-nodes_count),get_child(get_child_count()-1))

func generate_square_body( square_position:Vector2, dimensions:Vector2, spacing:Vector2 ):
	for y in range(dimensions.y):
		for x in range(dimensions.x):
			var new_point := point_object.instance()
			new_point.position = Vector2( x * spacing.x, y * spacing.y ) 
			new_point.position += square_position
			add_child(new_point)
			if x>0:
				add_spring(new_point,get_child(get_child_count()-2))
			if y>0:
				add_spring(new_point,get_child(get_child_count()-dimensions.x-1))
				if x<dimensions.x-1:
					add_spring(new_point,get_child(get_child_count()-dimensions.x))
				if x>0:
					add_spring(new_point,get_child(get_child_count()-dimensions.x-2))
			if y==0:
				new_point.is_static = true
			
	
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

func _on_Gravity_value_changed(value):
	globals.gravity = Vector2(0, value)
	globals.debug.text = "Gravity = " + str(value)
	
func _on_Stiffness_value_changed(value):
	globals.stiffness = value
	globals.debug.text = "Stiffness = " + str(value)
	
func _on_Medium_value_changed(value):
	globals.medium_damping = value
	globals.debug.text = "Medium damping = " + str(value)
