tool
extends Node2D
class_name SpringNode

export(NodePath) var node_path_1:NodePath setget set_node_1
export(NodePath) var node_path_2:NodePath setget set_node_2

var from:PointMass
var to:PointMass

func set_node_1(value:NodePath):
	node_path_1 = value
	if Engine.is_editor_hint() and has_node(value):
		from = get_node(value) as PointMass
	
func set_node_2(value:NodePath):
	node_path_2 = value
	if Engine.is_editor_hint() and has_node(value):
		to = get_node(value) as PointMass
	
func initialize( node_1:PointMass, node_2:PointMass ):
	from = node_1
	to   = node_2
	
func _ready():
#	if !Engine.is_editor_hint():
	if !from:
		from = get_node(node_path_1) as PointMass
	if !to:
		to = get_node(node_path_2) as PointMass
	from.add_neighbor(to)
	to.add_neighbor(from)
		
		
func _process( _delta ):
	if from and to :
		position            = 0.5 * ( from.position + to.position )
		
		var relation_vector := from.position - to.position
		rotation            = atan2( relation_vector.x, -relation_vector.y )
		scale.y             = relation_vector.length() / 128.0
		scale.x             = 16.0 / max( relation_vector.length() , 32.0 )

