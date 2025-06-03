extends Node

signal luxs_updated
signal score_updated

var luxs := 0 
var score := 0 
var player_life := 10 

var player = null

var player_start_position = null

var current_checkpoint = null

func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
	else:
		player.global_position = player_start_position.global_position
