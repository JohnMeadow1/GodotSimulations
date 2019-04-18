extends Node

var length          = 1.0
var rest_length     = 1.0
var stiffness       = 1.0
var connected_nodes = []
var length_ratio    = 0.5

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func add_node( node ):
	connected_nodes.push_back(node) 