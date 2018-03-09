extends Node2D

var nb_points         = 60
# setup params

var selected_param    = 0
var params_count      = 4
var params_dictionary = { mass = 0.05, stiffness = 10.0, damping = 0.05, spread = 0.15  }
var params_change = { mass = 1, stiffness = 1.0, damping = 1, spread = 0.05  }
var params_min = { mass = 0.01,  stiffness = 0.1,  damping = 0.001, spread = 0.001  }
var params_max = { mass = 100.0, stiffness = 50.0, damping = 10,    spread = 0.25  }
var param_names       = ['mass','stiffness','damping','spread']
# mouse drag params 
var selectionDistance = 15
var pressed           = false
var selection         = null

# bodies
var bodies         = [ ]
var node_object    = load("res://node.tscn")
var stone_object    = load("res://stone.tscn")

var input_states = preload("res://input_states.gd")
var ui_right     = input_states.new("ui_right")
var ui_left      = input_states.new("ui_left")
var ui_up        = input_states.new("ui_up")
var ui_down      = input_states.new("ui_down")

var btn_right    = null
var btn_left     = null
var btn_up       = null
var btn_down     = null

var input_timer  = 0.1

func _ready():
	randomize()
	for i in range (nb_points+1):
		var node                   = node_object.instance()
		var distance_between_nodes = get_viewport_rect().size.x/nb_points
		node.rest_depth     = 300.0
		node.position       = Vector2( i * distance_between_nodes, get_viewport_rect().size.y - node.rest_depth  )
		node.previous_position = node.position
		node.start_position = get_viewport_rect().size.y
		add_child( node )
	update_params()
	
func update_params():
	for node in get_children():
		node.set_mass(params_dictionary.mass)
		node.set_stiffness(params_dictionary.stiffness)
		node.set_damping(params_dictionary.damping)
	
func print_values():
	$"../CanvasLayer/Mass".set_text(       str( params_dictionary['mass'] ) )
	$"../CanvasLayer/Stiffness".set_text(  str( params_dictionary['stiffness'] ) )
	$"../CanvasLayer/Damping".set_text(    str( params_dictionary['damping'] ) )
	$"../CanvasLayer/Wave_spread".set_text(str( params_dictionary['spread'] ) )

	$"../CanvasLayer/Mass".set("custom_colors/font_color",        Color(1,1,1))
	$"../CanvasLayer/Stiffness".set("custom_colors/font_color",   Color(1,1,1))
	$"../CanvasLayer/Damping".set("custom_colors/font_color",     Color(1,1,1))
	$"../CanvasLayer/Wave_spread".set("custom_colors/font_color", Color(1,1,1))

	if selected_param == 0:
		$"../CanvasLayer/Mass".set("custom_colors/font_color",        Color(1,0,0))
	if selected_param == 1:
		$"../CanvasLayer/Stiffness".set("custom_colors/font_color",   Color(1,0,0))
	if selected_param == 2:
		$"../CanvasLayer/Damping".set("custom_colors/font_color",     Color(1,0,0))
	if selected_param == 3:
		$"../CanvasLayer/Wave_spread".set("custom_colors/font_color", Color(1,0,0))
	
	
func _input(event):
	
	# mouse drag
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
	if rand_range(0,100) < 1:
		var new_stone = stone_object.instance()
		$'../stones'.add_child(new_stone)
		new_stone.initialize()
		
	btn_right    = ui_right.check()
	btn_left     = ui_left.check()
	btn_up       = ui_up.check()
	btn_down     = ui_down.check()
	if input_timer <=0:
		if btn_left >= 1:
			if params_dictionary[param_names[selected_param]] <=1:
				params_dictionary[param_names[selected_param]] -= params_change[param_names[selected_param]] * 0.1
			else:
				params_dictionary[param_names[selected_param]] = round(params_dictionary[param_names[selected_param]])
				params_dictionary[param_names[selected_param]] -= params_change[param_names[selected_param]]
			params_dictionary[param_names[selected_param]] = clamp(params_dictionary[param_names[selected_param]] ,params_min[param_names[selected_param]] ,params_max[param_names[selected_param]] )
			update_params()
			input_timer = 0.05
		if btn_right >= 1:
			if params_dictionary[param_names[selected_param]] <1:
				params_dictionary[param_names[selected_param]] += params_change[param_names[selected_param]] * 0.1
			else:
				params_dictionary[param_names[selected_param]] = round(params_dictionary[param_names[selected_param]])
				params_dictionary[param_names[selected_param]] += params_change[param_names[selected_param]]
			params_dictionary[param_names[selected_param]] = clamp(params_dictionary[param_names[selected_param]] ,params_min[param_names[selected_param]] ,params_max[param_names[selected_param]] )
			update_params()
			input_timer = 0.05
	else:
		input_timer -= delta
		
	if btn_up    == 3:
		selected_param -= 1
		if selected_param < 0:
			selected_param = params_count - 1
	if btn_down  == 3:
		selected_param += 1
		selected_param %= params_count
		
	if pressed:
		if selection != null:
			selection.position.y        = get_global_mouse_position().y
			selection.previous_position = get_global_mouse_position().y
	else:
		selection = null
		for node in get_children():
			if get_global_mouse_position().distance_to(node.position) < selectionDistance:
				selection = node
#	for j in range(3):
	for i in range(nb_points+1):
		if i > 0:
			get_child(i).left_delta  = params_dictionary['spread'] * (get_child(i).position.y - get_child(i-1).position.y );
#				get_child(i-1).velocity += get_child(i).left_delta
		if i < nb_points:
			get_child(i).right_delta = params_dictionary['spread'] * (get_child(i).position.y  - get_child(i+1).position.y );
#				get_child(i+1).velocity += get_child(i).right_delta
	 
	for i in range(nb_points+1):
		if i > 0:
			get_child(i-1).position.y += get_child(i).left_delta 
		if i < nb_points:
			get_child(i+1).position.y += get_child(i).right_delta 
	print_values()
	update()

func draw_water():
	for i in nb_points :
		var points = PoolVector2Array()
		var colors = PoolColorArray()
		var local_color_change = (get_viewport_rect().size.y-get_child(i).position.y)/1000
		var local_color_change2 = (get_viewport_rect().size.y-get_child(i).position.y)/2000
		var local_color_change3 = (get_viewport_rect().size.y-get_child(i+1).position.y)/1000
		var local_color_change4 = (get_viewport_rect().size.y-get_child(i+1).position.y)/2000
		colors.push_back( Color( 0.1 + local_color_change2 , 0.2 + local_color_change2 , 0.8 + local_color_change , 0.8 ) )
		colors.push_back( Color( 0.1 + local_color_change4 , 0.2 + local_color_change4 , 0.8 + local_color_change3, 0.8 ) )
		colors.push_back( Color( 0.1, 0.1, 0.2 - local_color_change4, 0.8 ) )
		colors.push_back( Color( 0.1, 0.1, 0.2 - local_color_change2, 0.8 ) )
		points.push_back( get_child(i).position )
#		colors.push_back( Color( 0, 0, (get_viewport_rect().size.y-get_child(i+1).position.y)/get_child(i+1).start_position ) )
		points.push_back( get_child(i+1).position  )
		points.push_back( Vector2( get_child(i+1).position.x, get_viewport_rect().size.y ) )
		points.push_back( Vector2( get_child(i).position.x, get_viewport_rect().size.y ) )
		draw_polygon( points, colors )


func _draw():
	draw_water()
	if selection != null:  # draw selected point
		draw_circle( selection.position, selectionDistance, Color( 1, 1, 1, 0.3 ) )