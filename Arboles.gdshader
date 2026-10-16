shader_type canvas_item;

uniform float velocidad : hint_range(0.0, 10.0) = 2.0;
uniform float fuerza : hint_range(0.0, 5.0) = 1.0;
uniform float frecuencia : hint_range(0.0, 10.0) = 2.0;

void vertex() {
	// Solo deformamos la parte superior de las texturas (UV.y cercano a 0)
	// para que la base del pasto se quede pegada al suelo.
	float factor_altura = 1.0 - UV.y;
	
	// Calculamos el movimiento en X usando una onda seno
	float movimiento = sin(TIME * velocidad + VERTEX.x * frecuencia) * fuerza * factor_altura;
	
	VERTEX.x += movimiento;
}