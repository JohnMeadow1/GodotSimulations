extends Node2D

var force          = Vector2( 0.0  , 0.0 )
var node_mass      = 100.0
var infinitesimal  = Transform2D(0.05, Vector2(0.0,0.0))

# bodies
onready var bodies = [ $node_A, $node_B, $node_C ]
var links = [ ]
var link_object = load("res://spring.tscn")

# are the keys "→", "←", "↑" or "↓" pressed
var MOVE_LFT = false
var MOVE_RGT = false
var MOVE_UP  = false
var MOVE_DWN = false
var inf_DU = Vector2(0.0,0.01)
var inf_RL = Vector2(0.01,0.0)

func _ready():
	for i in range(bodies.size()):
		bodies[i].set_velocity(Vector2(0.0,0.0))
		bodies[i].set_mass(node_mass)
		for j in range(i):
			bodies[i].neighbors.push_back(bodies[j])
			bodies[i].ks.push_back(5.0)
			bodies[i].ls.push_back(100.0)
			bodies[j].neighbors.push_back(bodies[i])
			bodies[j].ks.push_back(5.0)
			bodies[j].ls.push_back(100.0)
			
			var link = link_object.instance()
			link.initialize(bodies[i],bodies[j])
			self.add_child( link )
			links.push_back([bodies[i],bodies[j]])
	pass

func _input(event):
	if event.is_action_pressed("ui_left"):
		MOVE_LFT = true
	if event.is_action_released("ui_left"):
		MOVE_LFT = false
	if event.is_action_pressed("ui_right"):
		MOVE_RGT = true
	if event.is_action_released("ui_right"):
		MOVE_RGT = false
	if event.is_action_pressed("ui_up"):
		MOVE_UP  = true
	if event.is_action_released("ui_up"):
		MOVE_UP  = false
	if event.is_action_pressed("ui_down"):
		MOVE_DWN = true
	if event.is_action_released("ui_down"):
		MOVE_DWN = false

func _process(delta):
	if MOVE_LFT:
		bodies[0].position -= inf_RL
	if MOVE_RGT:
		bodies[0].position += inf_RL
	if MOVE_UP:
		bodies[0].position -= inf_DU
	if MOVE_DWN:
		bodies[0].position += inf_DU
	update()

func draw_arrow(from, to, color = Color(1.0, 1.0, 1.0, 0.5)):
	var arrow_point = PoolVector2Array()
	var color_point = PoolColorArray()
	var vec = to - from
	if vec.length() > 10.0:
		arrow_point.append(to + 5.0*vec.normalized().tangent())
		color_point.append(color)
		arrow_point.append(to - 5.0*vec.normalized().tangent())
		color_point.append(color)
		arrow_point.append(to + 10.0*vec.normalized())
		color_point.append(color)
		draw_line ( from, to, color, 3 )
		draw_polygon(arrow_point,color_point)

func draw_spring(from, to):
	pass

func _draw():
	for body in bodies:
		draw_arrow(body.position, body.position + body.velocity)