extends CharacterBody2D

@onready var anim = $anim as AnimatedSprite2D
@export var enemy_score := 300

func _on_hitbox_body_entered(body):
	anim.play("death")
	
func _on_anim_animation_finished():
	if anim.animation == "death":
		queue_free()
		Globals.score += enemy_score
		
