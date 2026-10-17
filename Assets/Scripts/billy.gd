extends CharacterBody2D

var Vidas: int = 3
var esta_parpadeando: bool = false
const TIEMPO_INVENCIBILIDAD = 1.0

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
		else:
			$Animaciones.play("Idle")

	move_and_slide()

# --- FUNCIÓN PARA RECIBIR DAÑO MODIFICADA ---
func recibir_dano(cantidad: int = 1) -> void:
	# 1. Si Billy ya es invencible (está parpadeando), ignoramos el daño
	if esta_parpadeando: return

	Vidas -= cantidad
	print("Vidas de Billy: ", Vidas)
	
	if Vidas <= 0:
		morir()
		return # Salimos rápido si muere para no parpadear

	# 2. Si sobrevive, activamos el parpadeo e invencibilidad
	iniciar_efecto_parpadeo()

func morir() -> void:
	print("¡Billy ha muerto! Reiniciando...")
	get_tree().reload_current_scene()

# --- NUEVAS FUNCIONES PARA EL EFECTO ---
func iniciar_efecto_parpadeo() -> void:
	esta_parpadeando = true
	
	# Creamos un Tween (secuencia de animación por código)
	# 'create_tween()' es el método moderno en Godot 4
	var tween = create_tween()
	
	# Haremos 4 ciclos rápidos de parpadeo (apagar/encender alpha)
	# Esto dura aprox: 4 ciclos * (0.1s apagado + 0.1s encendido) = 0.8s
	for i in range(4):
		# Cambia 'modulate:a' (alpha/transparencia) del sprite a 0.2 (casi transparente) en 0.1s
		tween.tween_property($Animaciones, "modulate:a", 0.2, 0.1)
		# Regresa 'modulate:a' a 1.0 (opaco total) en 0.1s
		tween.tween_property($Animaciones, "modulate:a", 1.0, 0.1)
	
	# Al finalizar la secuencia del tween, ejecuta la función de limpieza
	tween.tween_callback(finalizar_invencibilidad)

func finalizar_invencibilidad() -> void:
	esta_parpadeando = false
	# Aseguramos que la opacidad quede al 100% por si acaso
	$Animaciones.modulate.a = 1.0
