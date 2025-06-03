extends CharacterBody2D

const SPEED := 150.0
const AIR_FRICTION := 0.5

var is_jumping := false
var can_jump := true
var is_hurted := false
var knockback_vector := Vector2.ZERO
var knockback_power := 20
var direction

#handle jump and gravity
@export var jump_height := 96
@export var max_time_to_peak := 0.5

var jump_velocity
var gravity
var fall_gravity


@onready var animation: AnimatedSprite2D = $anim
@onready var remote_transform := $remote as RemoteTransform2D
@onready var coyote_timer = $coyote_timer as Timer
@onready var jump_sfx = $jump_sfx as AudioStreamPlayer
@onready var hit_sfx = $hit_sfx
@onready var player_start_position = $"../player_start_position"


signal player_has_died()

func _ready():
	jump_velocity = (jump_height * 2) / max_time_to_peak
	gravity = (jump_height * 2) / pow(max_time_to_peak, 2)
	fall_gravity = gravity * 2

func _physics_process(delta):
	if not is_on_floor():
		velocity.x = 0
#		velocity.y += gravity * delta
		
	# Pulo
	if Input.is_action_just_pressed("ui_accept") and can_jump:
		velocity.y = -jump_velocity
		is_jumping = true
		jump_sfx.play()
	elif is_on_floor():
		is_jumping = false
		
	if velocity.y > 0 or not Input.is_action_pressed("ui_accept"):
		velocity.y += fall_gravity * delta
	else:
		velocity.y += gravity * delta
	
	
	if is_on_floor() and !can_jump:
		can_jump = true
	elif can_jump and coyote_timer.is_stopped():
		coyote_timer.start()

	# Direção horizontal
	direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = lerp(velocity.x, direction * SPEED, AIR_FRICTION)
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
	var knockback = Vector2((global_position.x - body.global_position.x) * knockback_power, -200)
	print(knockback)
	take_damage(knockback)
	
# Seguir a câmera
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

# Lógica de dano com feedback visual
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if Globals.player_life > 1:
		Globals.player_life -= 1
		hit_sfx.play()
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
	
	if is_hurted:
		state = "hit"
	elif !is_on_floor():
		if velocity.y > 0:
			state = "fall"
		else:
			state = "jump"
	elif direction != 0:
		state = "run"
		
	if animation.name != state:
		animation.play(state)

	

func _on_coyote_timer_timeout():
	can_jump = false

func handle_death_zone():
	if Globals.player_life > 1:
		Globals.player_life -= 1
		visible = false
		set_physics_process(false)
		
		await get_tree().create_timer(1.0).timeout
		Globals.respawn_player()
		visible = true
		set_physics_process(true)
	else:
		visible = false
		await get_tree().create_timer(0.5).timeout
		player_has_died.emit()
