extends Node2D

onready var oscilator = $'../oscillator'

func _process(delta):
	update()
	
func _draw():
	for i in get_parent().numer_of_nodes:
		var points = PoolVector2Array()
		var colors = PoolColorArray()
		var local_color_change = (get_viewport_rect().size.y-oscilator.get_child(i).position.y)/1000
		var local_color_change2 = (get_viewport_rect().size.y-oscilator.get_child(i).position.y)/2000
		var local_color_change3 = (get_viewport_rect().size.y-oscilator.get_child(i+1).position.y)/1000
		var local_color_change4 = (get_viewport_rect().size.y-oscilator.get_child(i+1).position.y)/2000
		colors.push_back( Color( 0.2 + local_color_change2 , 0.3 + local_color_change2 , 0.9 + local_color_change , 0.8 ) )
		colors.push_back( Color( 0.2 + local_color_change4 , 0.3 + local_color_change4 , 0.9 + local_color_change3, 0.8 ) )
		colors.push_back( Color( (0.2 + local_color_change4)*0.8 , (0.3 + local_color_change4)*0.8 , (0.8 + local_color_change3) * 0.8, 0.8  ) )
		colors.push_back( Color( (0.2 + local_color_change2)*0.8 , (0.3 + local_color_change2)*0.8 , (0.8 + local_color_change)  * 0.8, 0.8  ) )
		points.push_back( oscilator.get_child(i).position )
		points.push_back( oscilator.get_child(i+1).position  )
		points.push_back( Vector2( oscilator.get_child(i+1).position.x * 0.6 + 202, (oscilator.get_child(i+1).position.y) * 0.5 + 192 ) )
		points.push_back( Vector2( oscilator.get_child(i).position.x   * 0.6 + 202, (oscilator.get_child(i).position.y)   * 0.5 + 192 ) )
		draw_polygon( points, colors )

