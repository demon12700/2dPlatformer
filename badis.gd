extends CharacterBody2D

var direccion: int = 1
const SPEED = 25.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_wall():
		direccion *= -1
		$Animaciones.flip_h = (direccion > 0)
	
	velocity.x = direccion * SPEED
	$Animaciones.flip_h = (direccion > 0)
	move_and_slide()
	
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jugador"):
		if body.has_method("recibir_dano"):
			body.recibir_dano(1)
