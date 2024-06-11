extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_button_pressed():
	get_tree().change_scene_to_file("res://level 1.tscn")


func _on_start_game_mouse_exited():
	print("out of focus")

