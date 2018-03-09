extends Node

var Pts = []
var lx = 0.025 # odległość węzłów w x
var ly = 0.025 # odległość węzłów w y
var NUM = 100

func _ready():
	generate_geometry()

func _physics_process(delta):
	pass

func generate_geometry():
	# initialize points
	for i in range(-NUM/2,NUM/2+1):
		for j in range(-NUM/2,NUM/2+1):
			# trzeba tak zrobić, żeby to węzły się tworzyły
			Pts.push_back(Vector3(lx*i,ly*j,0.0))
		
	var canvas_tex = $canvas_texture
	canvas_tex.begin( VisualServer.PRIMITIVE_TRIANGLES, null )
	
	for i in range(NUM):
		for j in range(NUM):
			# first triangle
			var P1 = Pts[NUM*(i)+j]
			var P2 = Pts[NUM*(i+1)+j]
			var P3 = Pts[NUM*(i+1)+j+1]
			var P4 = Pts[NUM*(i)+j+1]
			canvas_tex.set_normal( (P3-P2).cross(P1-P2).normalized() )
			canvas_tex.set_uv( Vector2( 0, 1 ) )
			canvas_tex.add_vertex( P1 )
			canvas_tex.set_uv( Vector2( 1, 0 ) )
			canvas_tex.add_vertex( P3 )
			canvas_tex.set_uv( Vector2( 1, 1 ) )
			canvas_tex.add_vertex( P2 )
			# second triangle
			canvas_tex.set_normal( (P1-P4).cross(P3-P4).normalized() )
			canvas_tex.set_uv( Vector2( 0, 1 ) )
			canvas_tex.add_vertex( P1 )
			canvas_tex.set_uv( Vector2( 0, 0 ) )
			canvas_tex.add_vertex( P4 )
			canvas_tex.set_uv( Vector2( 1, 0 ) )
			canvas_tex.add_vertex( P3 )

	canvas_tex.end()