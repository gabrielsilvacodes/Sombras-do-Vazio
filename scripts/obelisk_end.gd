extends Area2D

@onready var transition = get_parent().get_node("transition")
@onready var obelisk_end_sfx = $obelisk_end_sfx
@onready var anim = $anim
@export var next_level : String = ""

var is_activated = false

func _ready():
	# Começa com a animação idle inativo
	anim.play("idle")

func _on_body_entered(body):
	if body.name == "player" and !next_level == "":
		if !is_activated:
			is_activated = true
			obelisk_end_sfx.play()
			anim.play("activate")
			await anim.animation_finished
			anim.play("activated")
		transition.change_scene(next_level)
	else:
		print("No scene loaded")
