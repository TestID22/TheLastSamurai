extends Node2D

@onready var _animated_player = $"Start Game/AnimationPlayer"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://level 1.tscn")


func _on_start_game_mouse_entered():
	_animated_player.play("move_on")


func _on_start_game_mouse_exited():
	print("out of focus")

