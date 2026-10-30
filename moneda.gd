extends CharacterBody2D


const SPEED = 0.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	$AnimatedSprite2D.play("default")

func _on_señal_colision_body_entered(body: Node2D) -> void:
	if body.name == "Billy" or body.is_in_group("Jugador"):

		Global.monedas_actuales += 1
		var label_monedas = get_tree().get_first_node_in_group("PuntuacionMonedas")
		if label_monedas:
			var total = int(label_monedas.text) + 1
			label_monedas.text = str(total)
		$MonedaAudio.play()
		await get_tree().create_timer(0.08).timeout
		queue_free()
