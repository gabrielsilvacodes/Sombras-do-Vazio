extends Area2D

var luxs := 1
@onready var lux_sfx = $lux_sfx as AudioStreamPlayer


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	$anim.play("collect")
	lux_sfx.play()
	await $collision.call_deferred("queue_free")
	Globals.luxs += luxs
	
	
func _on_anim_animation_finished():
	queue_free()
