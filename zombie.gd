extends CharacterBody2D

@onready var zombie_animation = $AnimatedSprite2D
@onready var label = $Label
@onready var attack_diraction = $AttackDirection

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false
var speed = 250

enum {
	IDLE,
	CHASE,
	ATTACK,
}
var state = 0
var player
var distance 
var damage = 20

func _ready():
	Signals.connect('player_position_update', Callable(self, "_on_player_position_update"))
	
func _physics_process(delta):
	match state:
		IDLE:
			idle_state()
		ATTACK:
			atack_state()
		CHASE:
			chase_state()
			
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	
		
func idle_state():
	velocity.x = 0
	zombie_animation.play("idle")
	
func _on_player_position_update(player_pos):
	player = player_pos
	
func atack_state():
	zombie_animation.play("attack")
	await zombie_animation.animation_finished
	state = CHASE
	
func chase_state():
	distance = (player - position).normalized()
	velocity.x = distance.x * speed
	zombie_animation.play("chase")
	if distance.x <= 0.6:
		zombie_animation.flip_h = true
		attack_diraction.rotation_degrees = 180
	elif distance.x > 0:
		attack_diraction.rotation_degrees = 0
		zombie_animation.flip_h = false

func _on_hitbox_area_entered(area):
	velocity.x = 0
	state = ATTACK
	Signals.emit_signal("enemy_attack", damage)
	print("ZOMBIE deals ", damage, " damage")
	
func _on_hurt_box_area_entered(area):
	print("AAAA")

func _on_detector_area_entered(area):
	state = CHASE

func _on_hurt_box_area_exited(area):
	pass

func _on_detector_area_exited(area):
	state = IDLE
