extends RigidBody2D

@onready var pickup_area := $lux  # a instância de Area2D
@onready var pickup_timer := $pickup_timer

func _ready():
	pickup_area.monitoring = false  # desativa coleta
	pickup_timer.start()  
	
	
func _on_pickup_timer_timeout():
	pickup_area.monitoring = true  # ativa coleta após 0.3s


func _on_lux_tree_exited():
	queue_free()


