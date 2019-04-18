extends Sprite

var velocity = 100

export(float) var k = 1.0

func _process(delta):
	
	position.x -= 0.5 * position.x * k
