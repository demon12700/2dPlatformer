extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if Input.is_action_just_pressed("scroll_up") or Input.is_action_pressed("Zoom_laptop+"):
		zoom += Vector2(0.1, 0.1)
	elif Input.is_action_just_pressed("scroll_down") or Input.is_action_pressed("Zoom_laptop-") :
		zoom -= Vector2(0.1, 0.1)
		zoom = zoom.clamp(Vector2(0.2, 0.2), Vector2(5.0, 5.0))
