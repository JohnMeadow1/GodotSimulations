extends Node2D

var velocity = Vector2( 0.0, 0.0   )
var gravity  = Vector2( 0.0, 100.0 )

# target position
onready var target   = $"../target"

var explode_timer = 0

func _ready():
	pass

func _physics_process(delta):
	# TODO: solution of the equation of motion for rocket
	
	# rotating the rocket along its current velocity
	rotation = atan2( velocity.y, velocity.x )
	
	# explosion animation
	if ((position - target.position).length() <= 40 or position.y >= 460) and explode_timer == 0:
		$AnimationPlayer.play("explode")
		$explosion.rotation = rand_range( 0.0, 360.0 )
		$explosion.visible  = true
		$rocket.visible     = false
		explode_timer       = 0.8
		velocity            = velocity.normalized() * 10

	if explode_timer > 0:
		explode_timer -= delta
		if explode_timer <= 0:
			queue_free()

