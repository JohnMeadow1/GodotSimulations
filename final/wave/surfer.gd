extends Node2D

var gravity  = Vector2(0,0.9)
var velocity = Vector2(0,0)
var contact_points = [Vector2(),Vector2(),Vector2()]
var angle_left     = 0
var angle_right    = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	pass

func _physics_process(delta):
	var horizontal_position = round(float(position.x) / get_viewport_rect().size.x * get_parent().numer_of_nodes)

	if horizontal_position > 0 && horizontal_position < get_parent().numer_of_nodes-1:
		contact_points[1] = $"../oscillator".get_child(horizontal_position).position
		contact_points[0] = $"../oscillator".get_child(horizontal_position-1).position
		contact_points[2] = $"../oscillator".get_child(horizontal_position+1).position
	elif horizontal_position <= 0:
		contact_points[0] = $"../oscillator".get_child(0).position
		contact_points[1] = $"../oscillator".get_child(0).position
		contact_points[2] = $"../oscillator".get_child(1).position
	else:
		contact_points[0] = $"../oscillator".get_child(get_parent().numer_of_nodes-1).position
		contact_points[1] = $"../oscillator".get_child(get_parent().numer_of_nodes-1).position
		contact_points[2] = $"../oscillator".get_child(get_parent().numer_of_nodes-2).position
		
		if horizontal_position-1 < get_parent().numer_of_nodes:
			contact_points[1] = $"../oscillator".get_child(horizontal_position).position
			contact_points[0] = $"../oscillator".get_child(horizontal_position).position

	var  slope_vector = (contact_points[0] - contact_points[1])
	angle_left        = atan2(slope_vector.y, slope_vector.x)
	slope_vector      = (contact_points[2] - contact_points[1])
	angle_right       = atan2(slope_vector.y, slope_vector.x)

	velocity += gravity
	
	var local_position = 0
	if horizontal_position >= 0:
		local_position = check_water_collision(horizontal_position-1).y
#		velocity.x     += local_position - position.y
		velocity.x     -= sign(local_position - position.y) *0.01
	if horizontal_position < get_parent().numer_of_nodes:
		local_position = check_water_collision(horizontal_position+1).y
		velocity.x     += sign(local_position - position.y) *0.01
	
#	$Sprite.rotation = atan2((position - local_position).y,position - local_position).x)
	
	var distance = clamp (abs(check_water_collision(horizontal_position).y - position.y),1,9)
	var depth = check_water_collision(horizontal_position).y - position.y
	if depth < 0:
		velocity.y -= 1.3 * clamp(-depth / 5, 0, 5)
		velocity   *= 0.90
	else:
		velocity *= 0.99
#	velocity.y += sign(check_water_collision(horizontal_position).y - position.y) / (10-distance)
	
	position += velocity
	update()

func check_water_collision(horizontal_position):
#	print(horizontal_position)
	if (horizontal_position >= 0) && (horizontal_position < get_parent().numer_of_nodes):
		return $"../oscillator".get_child(horizontal_position).position
	else:
		return Vector2(0,0)
		
func _draw():
	draw_circle( contact_points[0]-position, 3, Color(0,1,1) )
	draw_circle( contact_points[1]-position, 3, Color(0,1,1) )
	draw_circle( contact_points[2]-position, 3, Color(0,1,1) )
	draw_line(Vector2(),Vector2(cos(angle_left),sin(angle_left))*50, Color(1,0,1,1), 3)
	draw_line(Vector2(),Vector2(cos(angle_right),sin(angle_right))*50, Color(1,1,0,1), 3)
	
	