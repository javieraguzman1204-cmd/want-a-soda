extends Area2D

var speed = 400.0
var direction = Vector2.ZERO
var dano = 15
var objetivo = null # <--- Nueva variable para saber a quién perseguimos

func _physics_process(delta):
	# La bala avanza en su dirección y rota
	position += direction * speed * delta
	rotation = direction.angle()
	
	# <--- NUEVA LÓGICA DE DISTANCIA --->
	# Verificamos si el bolito todavía existe (por si ya lo matamos)
	if is_instance_valid(objetivo):
		var distancia = global_position.distance_to(objetivo.global_position)
		
		# Si la bala está a menos de 100 píxeles y todavía no se ha animado...
		if distancia < 150 and $AnimatedSprite2D.frame == 0:
			$AnimatedSprite2D.play("default") # ¡Que se abra en pedazos!

func _on_body_entered(body):
	print("💥 La bala chocó físicamente contra: ", body.name)
	
	if body.is_in_group("enemigo"):
		print("🎯 ¡Es un enemigo! Haciendo daño y destruyendo la bala...")
		body.recibir_dano(dano)
		queue_free()
		
func _ready():
	# Si la bala no choca con nada en 2 segundos, se autodestruye para no dar lag
	await get_tree().create_timer(2.0).timeout
	queue_free()
