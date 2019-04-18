extends Node2D

var lattice_size = 256.0
onready var Nx = int(get_viewport().get_size().x / lattice_size)
onready var Ny = int(get_viewport().get_size().y / lattice_size)
var elapsed = 0.0;

var dict = {}
func _ready():
	
	$rect.get_material().set_shader_param("is_bulk",true)
	print( $rect.get_material().get_shader_param("is_bulk") )

func _process(delta):
	
	print( $rect.get_material().get_shader_param("stuff") )
	pass