extends Node2D

var velative_velocity:Vector2

func _ready():
	pass 

func _physics_process(delta):
	for j in range(get_child_count()):
		for i in range( j, get_child_count() ):
			var body1 = get_child(i)
			var body2 = get_child(j)
			if body1 != body2:
				if (body1.position - body2.position).length() <= (body1.radius + body2.radius):
					solve_collision( body1, body2 )
	update()
	
func solve_collision( body1:Circle, body2:Circle ):
	var e = min(body1.restitution,body2.restitution)
	var u = max(body1.friction,body2.friction)
	var t = Vector2(0,0)
	
	var normal  = (body1.position - body2.position).normalized()
	var tangent = normal.tangent()
	var velocity_1 = body1.velocity + body1.angular_velocity * body1.radius * tangent
	var velocity_2 = body2.velocity + body2.angular_velocity * body2.radius * -tangent
	velative_velocity = velocity_1 - velocity_2
	print ("vlocity: \n", body1.velocity,body2.velocity)
	print ("rel_vel: \n", velative_velocity)
	var tangent_velocity_component = velative_velocity.project(tangent).normalized()
	
	print ("tangent: \n", normal, tangent)
	print ("tan_vel: \n", tangent_velocity_component)
	if normal.dot(body1.velocity-body2.velocity)>=0:
		return
	var collision_point_1 = - normal * body1.radius
	var collision_point_2 = normal  * body2.radius
	
	
	var collision_response = body1.mass * body2.mass * ( 1.0 + e ) * normal.dot(velative_velocity)
	+ collision_point_1.cross(normal) * body1.angular_velocity
	- collision_point_2.cross(normal) * body2.angular_velocity
	collision_response /= (body1.mass + body2.mass)
	+ collision_point_1.cross(normal) * body1.inertia
	+ collision_point_2.cross(normal) * body2.inertia
	print("impulse: ", collision_response, " ", u)
	print("normal: ", normal, " ", normal - u * tangent_velocity_component)

	body1.velocity -= collision_response / body1.mass * (normal - u * tangent_velocity_component)
	body2.velocity += collision_response / body2.mass * (normal - u * tangent_velocity_component)
	
	body1.angular_velocity -= collision_response / body1.inertia * collision_point_1.cross(normal - u * tangent_velocity_component)
	body2.angular_velocity += collision_response / body2.inertia * collision_point_2.cross(normal - u * tangent_velocity_component)
#
func _draw():
	draw_line(Vector2(100,100), Vector2(100,100) + velative_velocity, Color(1,1,1,0.3), 5)
#	var collision_tangent = body1.position + (body2.position - body1.position)*0.5