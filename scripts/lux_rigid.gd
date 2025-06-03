extends RigidBody2D

func _on_lux_tree_exited():
	queue_free()
