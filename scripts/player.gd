extends CharacterBody2D

const SPEED := 200.0
const JUMP_FORCE := -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_life := 3
var knockback_vector := Vector2.ZERO

@onready var animation: AnimatedSprite2D = $Anim
@onready var remote_transform := $remote as RemoteTransform2D

func _physics_process(delta):
	# Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE

	# Direção horizontal
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 📌 Animações
	if not is_on_floor():
		if velocity.y < 0:
			animation.play("jump")
		else:
			animation.play("fall")
	elif direction != 0:
		animation.play("run")
	else:
		animation.play("idle")

	# Knockback
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector

	move_and_slide()

# 👊 Recebendo dano do inimigo
func _on_hurtbox_body_entered(body):
	if player_life < 0:
		queue_free()
	else:
		if $ray_right.is_colliding():
			take_damage(Vector2(-200, -200))
		elif $ray_left.is_colliding():
			take_damage(Vector2(200, -200))

# 🧭 Seguir a câmera
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

# ❤️ Lógica de dano com feedback visual
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	player_life -= 1

	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1, 0, 0, 1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1, 1, 1, 1), duration)
