extends CharacterBody2D

const SPEED := 150.0
const JUMP_FORCE := -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
var is_hurted := false
var knockback_vector := Vector2.ZERO
var direction


@onready var animation: AnimatedSprite2D = $anim
@onready var remote_transform := $remote as RemoteTransform2D

signal player_has_died()

func _physics_process(delta):
	# Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	# Direção horizontal
	direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Knockback
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	_set_state()
	move_and_slide()
	
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)

# Recebendo dano do inimigo
func _on_hurtbox_body_entered(body):
	if $ray_right.is_colliding():
		take_damage(Vector2(-200, -200))
	elif $ray_left.is_colliding():
		take_damage(Vector2(200, -200))

# Seguir a câmera
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

# Lógica de dano com feedback visual
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if Globals.player_life > 1:
		Globals.player_life -= 1
	else:
		Globals.player_life = 0
		emit_signal("player_has_died")
		queue_free()


	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1, 0, 0, 1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1, 1, 1, 1), duration)
	
	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false

func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
		
	if is_hurted:
		state = "hit"
	
	if animation.name != state:
		animation.play(state)
	
