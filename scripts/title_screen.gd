extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.luxs = 0
	Globals.score = 0
	Globals.player_life = 10.

func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_credits_btn_pressed():
	pass # Replace with function body.


func _on_quit_btn_pressed():
	get_tree().quit()
