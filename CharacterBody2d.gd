extends CharacterBody2D

enum {
	IDLE,
	MOVE,
	JUMP,
	ATTACK,
	ATTACK2,
	ATTACK3,
	SLIDE
}
#variable
var state = MOVE
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var _animated_sprite = $AnimatedSprite2D


func _physics_process(delta):
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		JUMP:
			pass
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func move_state():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			_animated_sprite.play("run")
	else:
		if velocity.y == 0:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			_animated_sprite.play("idle")
	if direction == -1: 
		_animated_sprite.flip_h = true
	if direction == 1: 
		_animated_sprite.flip_h = false
		
	if Input.is_action_just_released('attack'):
		state = ATTACK
	
func attack_state():
	velocity.x = 0 
	_animated_sprite.play('attack1')
	await _animated_sprite.animation_finished		
	state = MOVE
