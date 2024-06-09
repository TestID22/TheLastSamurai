extends CharacterBody2D

@onready var zombi_animation = $AnimatedSprite2D
@onready var collison = $AttackDirection/AttackRange/CollisionShape2D

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
var diraction
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
			
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		zombi_animation.flip_h = true
	

	move_and_slide()

	
func atack_state():
	zombi_animation.play("attack")
	await zombi_animation.animation_finished
	state = IDLE
	
func idle_state():
	zombi_animation.play("idle")

func _on_player_position_update(player_pos):
	player = player_pos
	
func chase_state():
	diraction = (player - self.position).normalized()
	if diraction.x < 0:
		zombi_animation.flip_h = true
	else:
		zombi_animation.flip_h = false

func _on_detector_body_entered(body):
	print("CHASE MODE IS ACTIVATED")


func _on_hitbox_area_entered(area):
	state = ATTACK
	Signals.emit_signal("enemy_attack", damage)
	print("ZOMBIE DEALS ", damage, " damage")

