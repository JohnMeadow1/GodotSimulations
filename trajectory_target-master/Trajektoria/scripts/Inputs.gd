extends Node

onready var velocity = get_node("BulletVelocity")
onready var velocityLabel = get_node("BulletVelocityLabel")

onready var gravity = get_node("Gravity")
onready var gravityLabel = get_node("GravityLabel")

onready var position = get_node("TargetPosition")
onready var positionLabel = get_node("TargetPositionLabel")

onready var height = get_node("GunHeight")
onready var heightLabel = get_node("GunHeightLabel")

onready var gun = get_node("../gun")
onready var target = get_node("../target")

func _ready():
	velocity.connect("value_changed", self, "on_value_changed")
	gravity.connect("value_changed", self, "on_gravity_changed")
	position.connect("value_changed", self, "on_position_changed")
	height.connect("value_changed", self, "on_height_changed")
	
	# Wartośsci poczatkowe
	var label = 'Bullet velocity: 115' 
	velocityLabel.set_text(label)
	gun.bulletSpeed = 115
	target.startVelocity = 115
	
	var gravityLabelTxt = 'Gravity: 9.8' 
	gravityLabel.set_text(gravityLabelTxt)
	target.gravity = 9.8
	gun.gravity = 9.8
	
	var positionLabelTxt = 'Target position: 700' 
	positionLabel.set_text(positionLabelTxt)
	target.positionX = 700
	
	var positionLabelTxt = 'Target position: 700' 
	positionLabel.set_text(positionLabelTxt)
	target.positionX = 700
	
	var gunHeightTxt = 'Gun height: 0' 
	heightLabel.set_text(gunHeightTxt)
	gun.height = 0
	
	set_fixed_process(true)

func _fixed_process( ):
	pass

func on_gravity_changed(val):
	gun.gravity = val
	target.gravity = val
	var label = 'Gravity: ' + str(val)
	gravityLabel.set_text(label)
	
func on_position_changed(val):
	var positionLabelTxt = 'Target position: ' + str(val) 
	positionLabel.set_text(positionLabelTxt)
	target.positionX = val
	
func on_height_changed(val):
	var gunHeightTxt = 'Gun height: ' + str(val)  
	heightLabel.set_text(gunHeightTxt)
	gun.height = val
	
func on_value_changed(val):
	gun.bulletSpeed = val
	target.startVelocity = val
	var label = 'Bullet velocity: ' + str(val)
	velocityLabel.set_text(label)