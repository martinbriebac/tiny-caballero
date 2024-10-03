extends CharacterBody2D

const SPEED = 100.0

var animation_state = ""
var is_attacking = false

func _ready():
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_AnimatedSprite2D_animation_finished"))

func _physics_process(delta):
	var input_vector = Vector2.ZERO

	if is_attacking:
		velocity *= 0.5
	else:
		input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		input_vector = input_vector.normalized()
		velocity = input_vector * SPEED
		move_and_slide()
	
	if not is_attacking:
		if input_vector != Vector2.ZERO:
			velocity = input_vector * SPEED
			if input_vector.x > 0:
				animation_state = "walk"
				$AnimatedSprite2D.scale.x = 1
			elif input_vector.x < 0:
				animation_state = "walk"
				$AnimatedSprite2D.scale.x = -1
			elif input_vector.y > 0:
				animation_state = "walk"
			elif input_vector.y < 0:
				animation_state = "walk_up"
			else:
				animation_state = "idle"
				$AnimatedSprite2D.scale.x = 1
			$AnimatedSprite2D.animation = animation_state
		else:
			velocity = Vector2.ZERO
			$AnimatedSprite2D.animation = "idle"
			$AnimatedSprite2D.scale.x = 1
	
	if Input.is_action_just_pressed("ui_accept") and not is_attacking:
		is_attacking = true
		$AnimatedSprite2D.animation = "attack_melee"


func _on_AnimatedSprite2D_animation_finished():
	print("Animation finished")
	if is_attacking and $AnimatedSprite2D.animation == "attack_melee":
		is_attacking = false
		$AnimatedSprite2D.play("idle")

	move_and_slide()
