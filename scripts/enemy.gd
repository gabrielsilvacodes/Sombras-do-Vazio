extends CharacterBody2D

const SPEED := 800.0

@onready var wall_detector := $wall_detector as RayCast2D
@onready var sprite := $texture as Sprite2D
@onready var anim := $anim as AnimationPlayer

@export var enemy_score := 100

var direction := -1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if wall_detector.is_colliding():
		_reverse_direction()

	# Movimento horizontal
	velocity.x = direction * SPEED * delta

	# Espelhamento do sprite
	sprite.flip_h = direction == 1

	move_and_slide()

func _reverse_direction():
	direction *= -1
	wall_detector.scale.x *= -1

func _on_anim_animation_finished(anim_name):
	if anim_name == "death":
		Globals.score += enemy_score
		queue_free()
