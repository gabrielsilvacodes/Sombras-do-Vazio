extends EnemyBase

func _ready():
	anim.animation_finished.connect(kill_air_enemy)

func _on_hitbox_body_entered(body):
	anim.play("death")
	
		
