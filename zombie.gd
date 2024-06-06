extends CharacterBody2D

@onready var zombi_animation = $AnimatedSprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false
var speed = 250


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		zombi_animation.play("idle")
		zombi_animation.flip_h = true
	
	var player = $"../../Player"
	var diraction = (player.position - self.position).normalized()
	
	if chase == true:
		velocity.x = diraction.x * speed
	else:
		velocity.x = 0
	move_and_slide()

func _on_detector_body_entered(body):
	if body.name == 'Hero':
		chase = true
		zombi_animation.play("chase")
		$Label.visible = true
		
func _on_detector_body_exited(body):
	if body.name == 'Hero':
		zombi_animation.play("idle")
		chase = false 
		$Label.text = 'я так хотел попробовать твою плоть...'

		

