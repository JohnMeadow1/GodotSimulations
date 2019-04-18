extends Node2D

var numer_of_nodes    = 120
var node_object       = load("res://node.tscn")
# setup params
var selected_param    = 0
var params_count      = 4
var params_dictionary = { mass = 0.05, stiffness = 10.0, damping = 0.05, spread = 0.15  }
var params_change     = { mass = 1, stiffness = 1.0, damping = 1, spread = 0.05  }
var params_min        = { mass = 0.01,  stiffness = 0.1,  damping = 0.001, spread = 0.001  }
var params_max        = { mass = 100.0, stiffness = 50.0, damping = 10,    spread = 0.25  }
var param_names       = ['mass','stiffness','damping','spread']

var stone_object       = load("res://stone.tscn")
var metaball_object    = load("res://metaball.tscn")

# mouse drag params 
var selection_distance = 15
var pressed            = false
var selection          = null

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

var wave_timer = 0.0

func _ready():
	randomize()
	for i in range ( numer_of_nodes + 1):
		var node                   = node_object.instance()
		var distance_between_nodes = get_viewport_rect().size.x / numer_of_nodes
		node.rest_depth            = 300.0
		node.position              = Vector2( i * distance_between_nodes, get_viewport_rect().size.y - node.rest_depth  )
		node.previous_position     = node.position
		node.start_position        = get_viewport_rect().size.y
		$oscillator.add_child( node )
	update_params()

	
func update_params():
	for node in $oscillator.get_children():
		node.set_mass(params_dictionary.mass)
		node.set_stiffness(params_dictionary.stiffness)
		node.set_damping(params_dictionary.damping)

func splash(position,velocity):
	for i in range (randi()%50+20):
		var new_meataball      = metaball_object.instance()
		new_meataball.velocity = -velocity.normalized().rotated( rand_range(-PI/6, PI/6) ) * rand_range(15,35)
		new_meataball.position = position
		new_meataball.scale = Vector2(1,1)*rand_range(0.1,1)*rand_range(0.1,1)
		new_meataball.step  = get_viewport_rect().size.x/numer_of_nodes
		$Viewport/metaballs.add_child( new_meataball )
	
func _input(event):
	# mouse drag
	if event is InputEventMouseButton:
		if event.pressed:
			pressed   = true
			$oscillator.selection = null
			for node in $oscillator.get_children():
				if event.position.distance_to(node.position) < selection_distance:
					$oscillator.selection = node
		else:
			pressed   = false
			$oscillator.selection = null

func _process(delta):
	$front_water.texture = $Viewport.get_texture()
	
	#spawn rock
	if rand_range(0,100) < 1:
		var new_stone = stone_object.instance()
		$stones.add_child(new_stone)
		new_stone.initialize()
		
	btn_right    = ui_right.check()
	btn_left     = ui_left.check()
	btn_up       = ui_up.check()
	btn_down     = ui_down.check()
	
	if input_timer <= 0:
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
		if $oscillator.selection != null:
			$oscillator.selection.position.y        = get_global_mouse_position().y
			$oscillator.selection.previous_position = get_global_mouse_position().y
	else:
		$oscillator.selection = null
		for node in $oscillator.get_children():
			if get_global_mouse_position().distance_to( node.position ) < selection_distance:
				$oscillator.selection = node
	
	wave_timer += delta*5
	$oscillator.get_child(numer_of_nodes-1).position.y = sin(wave_timer)*50 +450
	propagate_waves()
	print_values()
	update()
	
func propagate_waves():
	for i in range(numer_of_nodes+1):
		if i > 0:
			$oscillator.get_child(i).left_delta  = params_dictionary['spread'] * ($oscillator.get_child(i).position.y - $oscillator.get_child(i-1).position.y );
		if i < numer_of_nodes:
			$oscillator.get_child(i).right_delta = params_dictionary['spread'] * ($oscillator.get_child(i).position.y - $oscillator.get_child(i+1).position.y );
	 
	for i in range(numer_of_nodes+1):
		if i > 0:
			$oscillator.get_child(i-1).position.y += $oscillator.get_child(i).left_delta 
		if i < numer_of_nodes:
			$oscillator.get_child(i+1).position.y += $oscillator.get_child(i).right_delta 
			
func print_values():
	$"Gui/Mass".set_text(       str( params_dictionary['mass'] ) )
	$"Gui/Stiffness".set_text(  str( params_dictionary['stiffness'] ) )
	$"Gui/Damping".set_text(    str( params_dictionary['damping'] ) )
	$"Gui/Wave_spread".set_text(str( params_dictionary['spread'] ) )

	$"Gui/Mass".set("custom_colors/font_color",        Color(1,1,1))
	$"Gui/Stiffness".set("custom_colors/font_color",   Color(1,1,1))
	$"Gui/Damping".set("custom_colors/font_color",     Color(1,1,1))
	$"Gui/Wave_spread".set("custom_colors/font_color", Color(1,1,1))

	if selected_param == 0:
		$"Gui/Mass".set("custom_colors/font_color",        Color(1,0,0))
	if selected_param == 1:
		$"Gui/Stiffness".set("custom_colors/font_color",   Color(1,0,0))
	if selected_param == 2:
		$"Gui/Damping".set("custom_colors/font_color",     Color(1,0,0))
	if selected_param == 3:
		$"Gui/Wave_spread".set("custom_colors/font_color", Color(1,0,0))