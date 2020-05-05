extends Sprite

var water = null
var timer = 0.2
var image_size = Vector2(200, 200)


func _ready():
	var image_texture = ImageTexture.new()
	image_texture.create( image_size.x, image_size.y ,Image.FORMAT_L8 )
#	image_texture.create( image_size.x, image_size.y ,Image.FORMAT_GRAYSCALE )
	
	water = Water.new()
	water.init( image_size.x, image_size.y, image_texture )

	self.set_texture( water.get_texture() )
	set_process( true )

func _process(delta):
	
	timer += delta
	if timer > 0.2:

		water.touch( Vector2( round(rand_range( 0, image_size.x )), round(rand_range( 1, image_size.y ) )), randi()%10 )
		timer = rand_range(0,0.1)
	water.update(0.1)
	
func gerate_wave():
	for i in range (10):
		water.touch( Vector2( 20+i,25), 3 )