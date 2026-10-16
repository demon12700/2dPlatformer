extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -380.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")

	if not is_on_floor():
		velocity += get_gravity() * delta
		$Animaciones.play("Jump")

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if direction:
		velocity.x = direction * SPEED
		$Animaciones.flip_h = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if is_on_floor():
		if direction:
			$Animaciones.play("Walking")
			print (direction)
		else:
			$Animaciones.play("Idle")

	move_and_slide()
