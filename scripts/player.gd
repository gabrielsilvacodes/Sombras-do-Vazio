extends CharacterBody2D

const SPEED = 200.0
const JUMP_FORCE = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jumping := false
var was_on_floor := false

@onready var animation: AnimatedSprite2D = $Anim

func _physics_process(delta):
	# Detectar início de queda
	var on_floor = is_on_floor()

	if not on_floor:
		velocity.y += gravity * delta

	# Início do pulo
	if Input.is_action_just_pressed("ui_accept") and on_floor:
		velocity.y = JUMP_FORCE
		is_jumping = true

	# Direção horizontal
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 📌 ANIMAÇÕES
	if not on_floor:
		if velocity.y < 0:
			animation.play("jump")  # Subindo
		else:
			animation.play("fall")  # Caindo
	elif direction:
		animation.play("run")
	else:
		animation.play("idle")

	# Detectar pouso (transição de queda para chão)
	if not was_on_floor and on_floor:
		is_jumping = false
		# Aqui você pode adicionar uma animação de "landing" se tiver

	was_on_floor = on_floor

	# Movimento final
	move_and_slide()
