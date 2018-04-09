extends Node

var Nds = []  # węzły
var NUM = 100
var e = 0.0 # wsp. restytucji

var node_object = load("material_point.tscn")
onready var sphere = $sphere

func _ready():
	create_scene()

func _process(delta):
	pass

func _physics_process(delta):
	for i in range(Nds.size()):
		for j in range(i):
			var dist = (Nds[i].position - Nds[j].position)
			if(dist.length() < Nds[i].radius() + Nds[j].radius()):
				print("Collision of pts: ",i," and ",j)
				var n = dist.normalized()
				var vI = Nds[i].velocity
				var vJ = Nds[j].velocity
				var mI = Nds[i].mass
				var mJ = Nds[j].mass
				var vIn = vI.dot(n)
				var vJn = vJ.dot(n)
				var Jdmm = (e + 1)*(vJn-vIn)/(mI+mJ)
				Nds[i].velocity +=  Jdmm*mJ*n - vIn*n
				Nds[j].velocity += -Jdmm*mI*n - vJn*n
				Nds[i].euler(get_physics_process_delta_time())
				Nds[j].euler(get_physics_process_delta_time())

func create_scene():
	# initialize points
	for i in range(NUM):
		var new_node  = node_object.instance()
		var r     = 3.5
		var phi   = 2*PI*randf()
		var theta = -0.5*PI + PI*randf()
		new_node.position = r*Vector3(cos(phi)*sin(theta),cos(theta),sin(phi)*sin(theta))
		Nds.push_back(new_node)
		add_child(new_node)