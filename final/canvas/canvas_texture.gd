extends ImmediateGeometry

onready var NUM = get_parent().NUM

func _ready():
	pass

func _process(delta):
	clear()
	begin( VisualServer.PRIMITIVE_TRIANGLES, null )
	for i in range(NUM-1):
		for j in range(NUM-1):
			# first triangle			
			set_normal( (get_parent().Nds[NUM * (i+1) + j + 1 ].position-get_parent().Nds[NUM * (i+1) + j ].position).cross(get_parent().Nds[NUM * (i  ) + j ].position-get_parent().Nds[NUM * (i+1) + j ].position).normalized() )
			set_uv( Vector2( float(i)/NUM, float(j)/NUM ) )
			add_vertex( get_parent().Nds[NUM * (i  ) + j ].position )
			set_uv( Vector2( float(i+1)/NUM, float(j+1)/NUM ) )
			add_vertex( get_parent().Nds[NUM * (i+1) + j + 1 ].position )
			set_uv( Vector2( float(i+1)/NUM, float(j)/NUM ) )
			add_vertex( get_parent().Nds[NUM * (i+1) + j ].position )
			# second triangle
			set_normal( (get_parent().Nds[NUM * (i  ) + j ].position-get_parent().Nds[NUM * (i  ) + j + 1 ].position).cross(get_parent().Nds[NUM * (i+1) + j + 1 ].position-get_parent().Nds[NUM * (i  ) + j + 1 ].position).normalized() )
			set_uv( Vector2( float(i)/NUM, float(j)/NUM ) )
			add_vertex( get_parent().Nds[NUM * (i  ) + j ].position )
			set_uv( Vector2( float(i)/NUM, float(j+1)/NUM ) )
			add_vertex( get_parent().Nds[NUM * (i  ) + j + 1 ].position )
			set_uv( Vector2( float(i+1)/NUM, float(j+1)/NUM ) )
			add_vertex( get_parent().Nds[NUM * (i+1) + j + 1 ].position )
	end()
