tool
extends EditorPlugin

# On Scene Tree Enter
func _enter_tree():
	# Load the Top Down Vehicle controller (since we have no other options yet)
	add_custom_type("VehicleController2D", "RigidBody2D", preload("top_down_vehicle.gd"), preload("icon.png"))

# On Scene Tree Exit
func _exit_tree():
	# Clean-up
	remove_custom_type("VehicleController2D")