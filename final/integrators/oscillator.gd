extends Node2D

var force          = Vector2( 0.0  , 0.0 )
var node_mass      = 1.00

# mouse drag params 
var selectionDistance = 50
var pressed           = false
var selection         = null

# bodies
var bodies         = [ ]
var links          = [ ]
var link_object    = load("res://spring.tscn")

func _ready():
	for node in get_children():
		bodies.push_back(node)

	$node2.set_velocity( Vector2( 0.0, 0.0 ) )
	$node2.set_mass( node_mass )
	$node2.neighbor = $node1
#	$node2.resting_length = ($node1.position - $node2.position).length()

	var link = link_object.instance()
	link.initialize( $node1,$node2 )
	$"../springs".add_child( link )

func _input(event):

	# mouse drag
	if event is InputEventMouseMotion:
		if pressed:
			if selection != null:
				selection.position          = event.position
				selection.previous_position = event.position
		else:
			selection = null
			for node in get_children():
				if event.position.distance_to(node.position) < selectionDistance:
					selection = node
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

func _process(delta):
	update()

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

func draw_spring(from, to):
	pass

func _draw():
	for body in bodies:
		draw_arrow(body.position, body.position + body.velocity)
		
	if selection != null:  # draw selected point
		draw_circle( selection.position, 30, Color( 1, 1, 1, 0.3 ) )