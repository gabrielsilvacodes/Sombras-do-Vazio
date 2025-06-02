extends EnemyBase

@onready var death_sound_player = $death_sound_player

func _ready():
	anim.animation_finished.connect(kill_air_enemy)

func _on_hitbox_body_entered(body):
	death_sound_player.play()
	anim.play("death")
