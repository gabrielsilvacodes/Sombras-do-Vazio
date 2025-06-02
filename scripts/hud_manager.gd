extends Control

@onready var lux_counter = $container/lux_container/lux_counter as Label
@onready var timer_counter = $container/timer_container/timer_counter as Label
@onready var score_counter = $container/score_container/score_counter as Label
@onready var clock_timer = $clock_timer as Timer
@onready var life_bar := $container/life_container/life_bar as TextureRect

var minutes = 0
var seconds = 0 

@export_range(0, 5) var default_minutes := 1
@export_range(0,59) var default_seconds := 0

signal time_is_up()

func _ready():
	lux_counter.text = str("%04d" % Globals.lux)
	score_counter.text = str("%06d" % Globals.score)
	timer_counter.text = str("%02d" % default_minutes) + ":" + str("%02d" % default_seconds)
	reset_clock_timer()

func _process(delta):
	# Atualiza HUD de lux e score
	lux_counter.text = str("%04d" % Globals.lux)
	score_counter.text = str("%06d" % Globals.score)

	# Atualiza frame da barra de vida
	if Globals.player_life <= 0:
		life_bar.texture.current_frame = 0
	else:
		var current_life = clamp(Globals.player_life, 0, 10)
		life_bar.texture.current_frame = current_life


	# Verifica se o tempo acabou
	if minutes == 0 and seconds == 0:
		emit_signal("time_is_up")


func _on_clock_timer_timeout():
	if seconds == 0: 
		if minutes > 0:
			minutes -= 1
			seconds = 60
	seconds -= 1
	
	timer_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)

func reset_clock_timer():
	minutes = default_minutes
	seconds = default_seconds
