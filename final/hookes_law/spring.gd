extends Node2D

var from = null
var to   = null

func _ready():
	pass
	
func initialize(_from, _to):
	from = _from
	to = _to

func _process(delta):
	position = 0.5*(from.position + to.position)
	var temp_pos = from.position - to.position
	rotation = atan2(temp_pos.x,-temp_pos.y)
	scale.y = temp_pos.length()/128.0
	scale.x = 32.0/max(temp_pos.length(),32.0)
	pass
