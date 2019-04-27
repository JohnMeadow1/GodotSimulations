#tool
extends Node2D

# mouse drag params 
var selectionDistance := 10.0
var pressed           :bool= false
var selection:PointMass
var prev_mouse_position

var link_object  := load("res://spring.tscn") as PackedScene
var point_object := load("res://node.tscn") as PackedScene

func _ready():
	if !Engine.is_editor_hint():
#		generate_sphere_body( Vector2(512,400), 100 )
#		generate_square_body( Vector2(275,75), 100 )
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
	
#func _physics_process(delta):
#	pass
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
	pass
		
func generate_sphere_body( sphere_position:Vector2, radius:float ):
	pass
	
func generate_square_body( square_position:Vector2, size:float ):
	pass
	
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