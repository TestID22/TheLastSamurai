extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var _animated_sprite = $AnimatedSprite2D


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		_animated_sprite.play("jump")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	print(direction)
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			_animated_sprite.play("run")
			
	elif direction == 0 and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		velocity.x == 0
		_animated_sprite.play("atack1")
	else:
		if velocity.y == 0:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			_animated_sprite.play("idle")
		
	if direction == -1: 
		_animated_sprite.flip_h = true
	if direction == 1: 
		_animated_sprite.flip_h = false
		
	move_and_slide()

