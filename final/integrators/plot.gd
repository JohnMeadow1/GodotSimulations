extends Node2D

export(NodePath) var point_path = null
var point_node:Node2D           = null
var velocity_data               = PoolRealArray()
var position_data               = PoolRealArray()
var max_stored_data:int         = 500

var max_value:float = 0.0

func _ready():
	if point_path:
		point_node = get_node(point_path)
		print("grabbed node: " +str(point_node.name))

func _physics_process(delta):
	if velocity_data.size() >= max_stored_data:
		position_data.remove(0)
		velocity_data.remove(0)
	velocity_data.append( point_node.velocity.length() )
	position_data.append( (point_node.distance.length() - point_node.resting_length)*0.1 )
	max_value = max(max_value, point_node.distance.length() - point_node.resting_length)
	$Label.text = str(max_value)
	update()

func _draw():
	for i in range( position_data.size() - 1 ):
		draw_line( Vector2(i + 100, velocity_data[i] ),
		           Vector2(i + 101, velocity_data[i+1] ), Color(0,0,0),1)
