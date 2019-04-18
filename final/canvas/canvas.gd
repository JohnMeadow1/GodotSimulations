extends Node

const CLOTH_SIZE      = 4
var spring_length_x   = 1.25 # odległość węzłów w x
var spring_length_y   = 1.25 # odległość węzłów w y
var k_spring_stiffnes = 20
var points            = []  # 
var nodes             = []  # węzły
var springs           = []  # węzły

var variable = null

var attached          = [ -CLOTH_SIZE/2, -CLOTH_SIZE/4, 0, CLOTH_SIZE/4, CLOTH_SIZE/2-1 ] # punkt zaczepienia

var node_object       = load("res://canvas_node.tscn")
var spring_object     = load("res://spring.gd") 
func _ready():
	create_canvas()
	connect_springs()
#	nodes[ CLOTH_SIZE * CLOTH_SIZE / 2 ].position += Vector3( 0.0, 0.0, 0.1 )
	

func _process(delta):
	for spring in springs:
		spring.length_ratio = ( spring.connected_nodes[0].position - spring.connected_nodes[1].position ).length() / spring.rest_length * 0.5
		
#		spring.connected_nodes[0].position
#		var new_position  = 2 * position - previous_position + force( delta ) * mu * pow( delta , 2.0 )
#		previous_position = position
#		position          = new_position
#		velocity          = ( position - previous_position ) / delta
#
	generate_wireframe()

func generate_wireframe():
	$canvas_texture/wireframe.clear()
	$canvas_texture/wireframe.begin( Mesh.PRIMITIVE_LINES, null )
	for spring in springs:
		$canvas_texture/wireframe.set_color( Color( spring.length_ratio, spring.length_ratio, spring.length_ratio ) )
		$canvas_texture/wireframe.add_vertex( spring.connected_nodes[0].position )
		$canvas_texture/wireframe.add_vertex( spring.connected_nodes[1].position )
	$canvas_texture/wireframe.end()

func connect_springs():
	for i in range( (CLOTH_SIZE * (CLOTH_SIZE-1)) ):
		var new_spring = spring_object.new()
		var local_i = floor( float(i) / (CLOTH_SIZE - 1) ) * (CLOTH_SIZE)  + i % (CLOTH_SIZE -1) 
		var local_i_plus = local_i + 1
		
#		print( local_i," ", local_i_plus )
		new_spring.add_node( nodes[local_i] )
		new_spring.add_node( nodes[local_i_plus] )
		springs.push_back(new_spring)
		
	for i in range( (CLOTH_SIZE * (CLOTH_SIZE-1)) ):
		var new_spring = spring_object.new()
		var local_i = floor( float(i) / (CLOTH_SIZE) ) * (CLOTH_SIZE)  + i % (CLOTH_SIZE) 
		var local_i_plus = local_i + CLOTH_SIZE
		
#		print( local_i," ", local_i_plus )
		new_spring.add_node( nodes[local_i] )
		new_spring.add_node( nodes[local_i_plus] )
		springs.push_back(new_spring)
			
func create_canvas():
	# initialize points
	for i in range( -CLOTH_SIZE / 2, CLOTH_SIZE / 2 ):
		for j in range( -CLOTH_SIZE / 2, CLOTH_SIZE / 2 ):
			# trzeba ta zrobić, żeby to węzły się tworzyły
			var new_node     = node_object.instance()
			new_node.position = Vector3( spring_length_x * i, spring_length_y * j, 0.0 )
			
			if j == CLOTH_SIZE / 2-1 and i in attached:
				new_node.is_static = true
				
			nodes.push_back(new_node)
#			add_child(new_node)
			
	for i in range(CLOTH_SIZE-1):
		for j in range(CLOTH_SIZE-1):
			nodes[CLOTH_SIZE * (i  ) + j    ].add_neighbor(nodes[CLOTH_SIZE * (i+1) + j    ],spring_length_x,k_spring_stiffnes)
			nodes[CLOTH_SIZE * (i  ) + j    ].add_neighbor(nodes[CLOTH_SIZE * (i  ) + j + 1],spring_length_y,k_spring_stiffnes)
#			nodes[CLOTH_SIZE * (i  ) + j    ].add_neighbor(nodes[CLOTH_SIZE * (i+1) + j + 1],sqrt(spring_length_x*spring_length_x+spring_length_y*spring_length_y),k_spring_stiffnes)
			nodes[CLOTH_SIZE * (i+1) + j    ].add_neighbor(nodes[CLOTH_SIZE * (i  ) + j    ],spring_length_x,k_spring_stiffnes)
			nodes[CLOTH_SIZE * (i  ) + j + 1].add_neighbor(nodes[CLOTH_SIZE * (i  ) + j    ],spring_length_y,k_spring_stiffnes)
#			nodes[CLOTH_SIZE * (i+1) + j + 1].add_neighbor(nodes[CLOTH_SIZE * (i  ) + j    ],sqrt(spring_length_x*spring_length_x+spring_length_y*spring_length_y),k_spring_stiffnes)
#			nodes[CLOTH_SIZE * (i+1) + j    ].add_neighbor(nodes[CLOTH_SIZE * (i  ) + j + 1],sqrt(spring_length_x*spring_length_x+spring_length_y*spring_length_y),k_spring_stiffnes)
#			nodes[CLOTH_SIZE * (i  ) + j + 1].add_neighbor(nodes[CLOTH_SIZE * (i+1) + j    ],sqrt(spring_length_x*spring_length_x+spring_length_y*spring_length_y),k_spring_stiffnes)
		nodes[CLOTH_SIZE * (CLOTH_SIZE-1) + i  ].add_neighbor(nodes[CLOTH_SIZE * (CLOTH_SIZE-1) + i+1],spring_length_y,k_spring_stiffnes)
		nodes[CLOTH_SIZE * (CLOTH_SIZE-1) + i+1].add_neighbor(nodes[CLOTH_SIZE * (CLOTH_SIZE-1) + i  ],spring_length_y,k_spring_stiffnes)
		nodes[CLOTH_SIZE * (i)   + CLOTH_SIZE - 1].add_neighbor(nodes[CLOTH_SIZE * (i  ) + CLOTH_SIZE - 1],spring_length_y,k_spring_stiffnes)
		nodes[CLOTH_SIZE * (i+1) + CLOTH_SIZE - 1].add_neighbor(nodes[CLOTH_SIZE * (i+1) + CLOTH_SIZE - 1],spring_length_y,k_spring_stiffnes)