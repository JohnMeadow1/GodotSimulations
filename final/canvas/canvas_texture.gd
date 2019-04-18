extends ImmediateGeometry

onready var CLOTH_SIZE = get_parent().CLOTH_SIZE

func _ready():
	
	pass

func _process(delta):
#	clear()
#	$wireframe.clear()
#	begin( Mesh.PRIMITIVE_TRIANGLES, null )
#	set_normal( Vector3( 0, 0, 1 ) )
#	for i in range(CLOTH_SIZE-1):
#		for j in range(CLOTH_SIZE-1):
#			$wireframe.begin( Mesh.PRIMITIVE_LINE_LOOP, null )
#			$wireframe.add_vertex( get_parent().nodes[CLOTH_SIZE * (i  ) + j ].position )
#			$wireframe.add_vertex( get_parent().nodes[CLOTH_SIZE * (i+1) + j ].position )
#			$wireframe.add_vertex( get_parent().nodes[CLOTH_SIZE * (i+1) + j + 1 ].position )
#			$wireframe.add_vertex( get_parent().nodes[CLOTH_SIZE * (i) + j + 1 ].position )
#			$wireframe.end()
			
			# first triangle
#			set_normal( (get_parent().nodes[CLOTH_SIZE * (i) + j+1 ].position-get_parent().nodes[CLOTH_SIZE * (i) + j ].position).cross(get_parent().nodes[CLOTH_SIZE * ( i + 1 ) + j + 1 ].position-get_parent().nodes[CLOTH_SIZE * (i) + j ].position) )
#			set_uv( Vector2( float(i)/CLOTH_SIZE, float(j)/CLOTH_SIZE ) )
#			add_vertex( get_parent().nodes[CLOTH_SIZE * (i  ) + j ].position )
##			set_uv( Vector2( float(i+1)/CLOTH_SIZE, float(j+1)/CLOTH_SIZE ) )
#			add_vertex( get_parent().nodes[CLOTH_SIZE * (i+1) + j + 1 ].position )
##			set_uv( Vector2( float(i+1)/CLOTH_SIZE, float(j)/CLOTH_SIZE ) )
#			add_vertex( get_parent().nodes[CLOTH_SIZE * (i+1) + j ].position )
#			# second triangle
##			set_normal( (get_parent().nodes[CLOTH_SIZE * (i  ) + j+1 ].position-get_parent().nodes[CLOTH_SIZE * (i) + j ].position).cross(get_parent().nodes[CLOTH_SIZE * (i+1) + j + 1 ].position-get_parent().nodes[CLOTH_SIZE * (i  ) + j ].position) )
##			set_uv( Vector2( float(i)/CLOTH_SIZE, float(j)/CLOTH_SIZE ) )
#			add_vertex( get_parent().nodes[CLOTH_SIZE * (i  ) + j ].position )
##			set_uv( Vector2( float(i)/CLOTH_SIZE, float(j+1)/CLOTH_SIZE ) )
#			add_vertex( get_parent().nodes[CLOTH_SIZE * (i  ) + j + 1 ].position )
##			set_uv( Vector2( float(i+1)/CLOTH_SIZE, float(j+1)/CLOTH_SIZE ) )
#			add_vertex( get_parent().nodes[CLOTH_SIZE * (i+1) + j + 1 ].position )
#	end()
	pass