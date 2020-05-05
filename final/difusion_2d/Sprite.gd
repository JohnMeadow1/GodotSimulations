extends Sprite

var water = null
var timer = 0.2
var image_size = Vector2(100, 100)
var img = Image.new()
var img_old = Image.new()

func _ready():
	var image_texture = ImageTexture.new()
	image_texture.create( image_size.x, image_size.y ,Image.FORMAT_L8 )

	img.create(image_size.x, image_size.y, false, Image.FORMAT_L8)
	img.lock()
	for i in range(20):
		for j in range(20):
			img.set_pixel(40+j, 40+i, Color.gray)
	img.unlock()
	image_texture.set_data(img)
	texture = image_texture

func _physics_process(delta):
	var value = 0
	img_old = img
	img_old.lock()
	img.lock()
	for i in range(2,image_size.y-1):
		for j in range(2,image_size.x-1):
			value += img_old.get_pixel(i-1,j).r
			value += img_old.get_pixel(i+1,j).r
			value += img_old.get_pixel(i,j-1).r
			value += img_old.get_pixel(i,j+1).r
			value -= img_old.get_pixel(i,j).r*4
#			value
#			print(value)
			img.set_pixel(i, j, Color(value,value,value))
	img_old.unlock()
	img.unlock()
