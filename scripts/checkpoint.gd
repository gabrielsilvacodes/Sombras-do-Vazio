extends Area2D

var is_active = false
@onready var anim = $anim
@onready var marker_2d = $Marker2D
@onready var checkpoint_sfx = $checkpoint_sfx


func _on_body_entered(body):
	if body.name != "player" or is_active:
		return
	activate_checkpoint()
	checkpoint_sfx.play()
	
func activate_checkpoint():
	Globals.current_checkpoint = marker_2d
	anim.play("raising")
	is_active = true

func _on_anim_animation_finished():
	if anim.animation == "raising":
		anim.play("checked")
