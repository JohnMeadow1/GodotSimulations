extends Node2D

const TRACK_LENGTH = 300
var track_front  = PoolIntArray()
var track_back   = PoolIntArray()
var track1 = PoolVector2Array()
var track2 = PoolVector2Array()
var track3 = PoolVector2Array()
var track4 = PoolVector2Array()

export (NodePath) var front_l
export (NodePath) var front_r
export (NodePath) var rear_l
export (NodePath) var rear_r

var front_left_wheel
var front_right_wheel
var rear_left_wheel
var rear_right_wheel

func _ready():
	front_left_wheel = get_node(front_l)
	front_right_wheel = get_node(front_r)
	rear_left_wheel = get_node(rear_l)
	rear_right_wheel = get_node(rear_r)

func _process(delta):
	if( track_front.size() >= TRACK_LENGTH ):
		track_back.remove(0)
		track_front.remove(0)
		track1.remove(0)
		track2.remove(0)
		track3.remove(0)
		track4.remove(0)
	track1.append(front_left_wheel.global_position)
	track2.append(front_right_wheel.global_position)
	track3.append(rear_left_wheel.global_position)
	track4.append(rear_right_wheel.global_position)
	track_back.append($car.skid_size_back)
	track_front.append($car.skid_size_front)
#	track_back.append(3)
#	track_front.append(3)
	update()

func _draw():
	for i in range(track_front.size() -1 ):
		if track_front[i] > 0:
			draw_line(track3[i], track3[i+1], Color(0, 0, 0, 0.5), track_front[i])
			draw_line(track4[i], track4[i+1], Color(0, 0, 0, 0.5), track_front[i])
		if track_back[i] > 0:
			draw_line(track1[i], track1[i+1], Color(0, 0, 0, 0.5), track_back[i])
			draw_line(track2[i], track2[i+1], Color(0, 0, 0, 0.5), track_back[i])
