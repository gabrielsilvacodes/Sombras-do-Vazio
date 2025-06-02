extends EnemyBase

@onready var death_sound_player = $death_sound_player  # nó de som exclusivo


func _ready():
	wall_detector = $wall_detector
	texture = $texture
	anim.animation_finished.connect(kill_ground_enemy)

func _physics_process(delta):
	_apply_gravity(delta)
	movement(delta)
	flip_direction()

func _on_hitbox_body_entered(body):
	death_sound_player.play()
	anim.play("death")

