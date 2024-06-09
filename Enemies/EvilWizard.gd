extends CharacterBody2D

@onready var _wizard_animation = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		_wizard_animation.flip_h = true
		
	move_and_slide()


func _on_attack_range_body_entered(body):
	_wizard_animation.play("attack")


func _on_attack_range_body_exited(body):
	_wizard_animation.play("idle")
	_wizard_animation.animation_finished
