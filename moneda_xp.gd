extends Area2D

var valor_xp = 1 # Moneda de un centavo = 1 XP
var recogida := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if recogida or not body.is_in_group("jugador"):
		return
	if body.has_method("ganar_xp"):
		recogida = true
		body.ganar_xp(valor_xp)
		queue_free()
