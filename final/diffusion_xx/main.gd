extends Node2D

var lattice_size = 256.0
onready var Nx = int(get_viewport().get_size().x / lattice_size)
onready var Ny = int(get_viewport().get_size().y / lattice_size)
var elapsed = 0.0;

var dict = {}
func _ready():
	var SHADER = load("res://equation.shader")
	var sprite_gen = load("res://rect.tscn")
	for i in range(Nx):
		for j in range(Ny):
			var new_sprite = sprite_gen.instance()
			new_sprite.position = Vector2(i+0.5,j+0.5)*lattice_size
			new_sprite.scale *= lattice_size*0.9
			var mat = ShaderMaterial.new()
			mat.set_shader(SHADER)
			mat.set_shader_param("delta",get_process_delta_time())
			mat.set_shader_param("dl",lattice_size)
			if i == 0 or i == Nx-1:
				mat.set_shader_param("value",10.1)
				mat.set_shader_param("is_bulk",false)
			elif j == 0 or j == Ny-1:
				mat.set_shader_param("value",-10.1)
				mat.set_shader_param("is_bulk",false)
			else:
				mat.set_shader_param("value",abs(float(j)/float(Ny)))
				mat.set_shader_param("is_bulk",true)
			new_sprite.set_material(mat)
			dict[Vector2(i,j)] = new_sprite
			add_child(new_sprite)

func _process(delta):
	for i in range(1,Nx-1):
		for j in range(1,Ny-1):
			if i ==5 and j ==5:
				print(dict[Vector2(i,j)].get_material().get_shader_param("is_bulk"))#.get_data().get_pixel())
			#dict[Vector2(i,j)].get_material().set_shader_param("value",abs(sin(elapsed)))
			#dict[Vector2(i,j)].get_material().set_shader_param("value",dict[Vector2(i,j)].get_material().get_shader_param("value"))
			dict[Vector2(i,j)].get_material().set_shader_param("right",dict[Vector2(i+1,j)].get_material().get_shader_param("value"))
			dict[Vector2(i,j)].get_material().set_shader_param("left",dict[Vector2(i-1,j)].get_material().get_shader_param("value"))
			dict[Vector2(i,j)].get_material().set_shader_param("bottom",dict[Vector2(i,j+1)].get_material().get_shader_param("value"))
			dict[Vector2(i,j)].get_material().set_shader_param("top",dict[Vector2(i,j-1)].get_material().get_shader_param("value"))
			elapsed += delta