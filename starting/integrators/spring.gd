extends Node2D

var from = null
var to   = null

func _ready():
	pass
	
func initialize(_from, _to):
	from = _from
	to = _to

func _process(delta):
	position            = 0.5 * ( from.position + to.position )
	
	var relation_vector = from.position - to.position
	rotation            = atan2( relation_vector.x, -relation_vector.y )
	scale.y             = relation_vector.length() / 128.0
	scale.x             = 32.0 / max( relation_vector.length() , 32.0 )

