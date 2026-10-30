extends CharacterBody2D

func _ready() -> void:
	# Iniciamos la cuenta regresiva de 30 segundos al arrancar la partida
	iniciar_temporizador_partida()

func iniciar_temporizador_partida() -> void:
	# Espera 30 segundos exactos sin congelar el juego
	await get_tree().create_timer(30.0).timeout
	
	# Llamamos directamente a tu función morir() para acabar la partida
	morir()


var Vidas: int = 3
var esta_parpadeando: bool = false
const TIEMPO_INVENCIBILIDAD = 1.0
var muerto :bool = false

var SPEED = 150.0
const JUMP_VELOCITY = -380.0

func _physics_process(delta: float) -> void:
	if muerto:
		return
	
	var direction := Input.get_axis("ui_left", "ui_right")

	if not is_on_floor():
		velocity += get_gravity() * delta
		$Animaciones.play("Jump")

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AudioSaltar.play()

	if direction:
		velocity.x = direction * SPEED
		$Animaciones.flip_h = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if is_on_floor():
		if direction:
			$Animaciones.play("Walking")
			if not $AudioCaminar.playing:
				$AudioCaminar.play()
		else:
			$Animaciones.play("Idle")

	move_and_slide()

# --- FUNCIÓN PARA RECIBIR DAÑO ---
func recibir_dano(cantidad: int = 1) -> void:
	if esta_parpadeando: return

	Vidas -= cantidad
	print("Vidas de Billy: ", Vidas)
	if not $"AudioDaño".playing:
		$"AudioDaño".play()
	
	if Vidas <= 0:
		morir()
		return
	iniciar_efecto_parpadeo()

func morir() -> void:
	if Global.monedas_actuales > Global.record_monedas:
		Global.record_monedas = Global.monedas_actuales
		print("¡Nuevo récord guardado: ", Global.record_monedas)
	Global.monedas_actuales = 0
	muerto = true
	if not $AudioMuerte/Muerte2.playing:
		$AudioMuerte/Muerte2.play()
	if not $AudioMuerte.playing:
		$AudioMuerte.play()
	$Animaciones.play("Death")

	print("¡Billy ha muerto! Reiniciando...")
	await get_tree().create_timer(2.48).timeout
	get_tree().reload_current_scene()

# --- Funcion de Invencibilidad ---
func iniciar_efecto_parpadeo() -> void:
	esta_parpadeando = true
	
	var tween = create_tween()
	
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
