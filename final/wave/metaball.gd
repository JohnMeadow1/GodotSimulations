extends Sprite

var velocity = Vector2()
var step     = 0.0
	
func _process(delta):
	position += velocity
	velocity += Vector2( 0, 1 )
	velocity *= 0.95

	if position.x < 0 || position.x >= get_viewport_rect().size.x:
		queue_free() 
	elif $'../../../oscillator'.get_child(int(position.x/step)).position.y < position.y-10:
		$'../../../oscillator'.splat(int(position.x/step), velocity.y, scale.x)
		queue_free() 
	