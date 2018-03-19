extends Node

var Pts = []  # punkty
var Nds = []  # węzły
var lx = 0.15 # odległość węzłów w x
var ly = 0.15 # odległość węzłów w y
var NUM = 30
var k = 8
var attached = [ -NUM/2, -NUM/4, 0, NUM/4] # punkty zaczepienia

var node_object = load("res://canvas_node.tscn")

func _ready():
	create_canvas()
	Nds[NUM*NUM/2].position += Vector3(0.0,0.0,0.2*randf())

func _process(delta):
	pass

func create_canvas():
	# initialize points
	for i in range(-NUM/2,NUM/2):
		for j in range(-NUM/2,NUM/2):
			var new_node = node_object.instance()
			new_node.position = Vector3( lx*i, ly*j, 0.0)
			if j == NUM/2-1 and i in attached:
				new_node.is_static = true
			Nds.push_back(new_node)
			add_child(new_node)
			
	for i in range(NUM-1):
		for j in range(NUM-1):
			Nds[NUM * (i  ) + j    ].add_neighbor(Nds[NUM * (i+1) + j    ],lx,k)
			Nds[NUM * (i  ) + j    ].add_neighbor(Nds[NUM * (i  ) + j + 1],ly,k)
			Nds[NUM * (i  ) + j    ].add_neighbor(Nds[NUM * (i+1) + j + 1],sqrt(lx*lx+ly*ly),k)
			Nds[NUM * (i+1) + j    ].add_neighbor(Nds[NUM * (i  ) + j    ],lx,k)
			Nds[NUM * (i  ) + j + 1].add_neighbor(Nds[NUM * (i  ) + j    ],ly,k)
			Nds[NUM * (i+1) + j + 1].add_neighbor(Nds[NUM * (i  ) + j    ],sqrt(lx*lx+ly*ly),k)
			Nds[NUM * (i+1) + j    ].add_neighbor(Nds[NUM * (i  ) + j + 1],sqrt(lx*lx+ly*ly),k)
			Nds[NUM * (i  ) + j + 1].add_neighbor(Nds[NUM * (i+1) + j    ],sqrt(lx*lx+ly*ly),k)
		Nds[NUM * (NUM-1) + i  ].add_neighbor(Nds[NUM * (NUM-1) + i+1],ly,k)
		Nds[NUM * (NUM-1) + i+1].add_neighbor(Nds[NUM * (NUM-1) + i  ],ly,k)
		Nds[NUM * (i)   + NUM - 1].add_neighbor(Nds[NUM * (i  ) + NUM - 1],ly,k)
		Nds[NUM * (i+1) + NUM - 1].add_neighbor(Nds[NUM * (i+1) + NUM - 1],ly,k)