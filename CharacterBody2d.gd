extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var _animated_sprite = $AnimatedSprite2D

signal health_changed (new_health)

enum {
	IDLE,
	MOVE,
	JUMP,
	ATTACK1,
	ATTACK2,
	ATTACK3,
	SLIDE,
	DAMAGE,
	DEATH
}
#variables
var state = MOVE
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var player_pos 
var max_health = 1000
var current_health 

func _ready():
	Signals.connect("enemy_attack", Callable(self, "_on_damage_recieved"))
	current_health = max_health
	
func _physics_process(delta):
	match state:
		MOVE:
			move_state()
		ATTACK1:
			attack_state()
		ATTACK2:
			pass
		JUMP:
			pass
		DAMAGE:
			damage_state()
		DEATH:
			death_state()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	
	player_pos = self.position
	Signals.emit_signal("player_position_update", player_pos)


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
		
	if Input.is_action_just_pressed('attack'):
		state = ATTACK1
	
	
func attack_state():
	velocity.x = 0 
	_animated_sprite.play('attack1')
	await _animated_sprite.animation_finished
	state = MOVE
	
func damage_state():
	velocity.x = 0 
	_animated_sprite.play("damage")
	await _animated_sprite.animation_finished
	state = MOVE
			
func _on_damage_recieved(enemy_damage):
	current_health -= enemy_damage
	if current_health < 0:
		current_health = 0;
		state = DEATH
	else:
		state = DAMAGE
	emit_signal('health_changed', current_health)	
	print("Current Health: ",current_health)
	
		
func death_state():
	velocity.x = 0
	_animated_sprite.play("death")
	_animated_sprite.animation_finished
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://MainMenu.tscn")
