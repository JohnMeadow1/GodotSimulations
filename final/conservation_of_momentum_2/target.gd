extends Node2D

var velocity = Vector2( 50.0 , 0.0 )

func _ready():
	self.position.x = 0.5 * get_viewport_rect().size.x;

func _physics_process(delta):
	self.position += velocity * delta
	
	if(self.position.x < 0.4 * get_viewport_rect().size.x or self.position.x > 0.6 * get_viewport_rect().size.x ):
		velocity *= -1