extends Area2D

var Moneda_Scene = load("res://moneda.tscn")
var random = RandomNumberGenerator.new()

func _ready() -> void:
	random.randomize()
	iniciar_bucle_spawn()

func iniciar_bucle_spawn() -> void:
	while true:
		spawnear_moneda()
		await get_tree().create_timer(2.0).timeout

func spawnear_moneda() -> void:
	var moneda_instance = Moneda_Scene.instantiate()
	
	moneda_instance.global_position = Vector2(
		random.randi_range(0, -520),
		random.randi_range(0, -30)
	)
	
	get_tree().current_scene.add_child(moneda_instance)
