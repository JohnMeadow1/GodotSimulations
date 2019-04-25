#Application: the evolution of the system governed by the stiff equation
extends Node2D

export var k:float = 2.0

func _physics_process( delta ):
	$Label.text = str(1 - k * delta)
	
	position.x *= (1 - k * delta)
