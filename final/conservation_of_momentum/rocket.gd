extends Sprite

var velocity = Vector2( 0.0, 0.0   )
var gravity  = Vector2( 0.0, 100.0 )

# target position
onready var target   = $"../target"

var explode_timer = 0

func _ready():
	pass

func _physics_process(delta):
	velocity      += gravity  * delta
	self.position += velocity * delta
	
	if (position - target.position).length() <= 40 and explode_timer == 0:
		$AnimationPlayer.play("explode")
		$explosion.rotation = true
		$explosion.visible  = rand_range( 0.0, 360.0 )
		explode_timer       = 0.8
		velocity            = velocity.normalized() * 100

	if explode_timer > 0:
		explode_timer -= delta
		if explode_timer <= 0:
			queue_free()

