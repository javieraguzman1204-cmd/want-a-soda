extends CharacterBody2D

var speed = 115.0
var vida = 30
var dano = 2
var attack_cooldown = 0.0 
var player = null
var derrotado := false

# Precargamos la escena de la moneda de un centavo
var moneda_escena = preload("res://moneda_xp.tscn")

func _ready():
	player = get_tree().get_first_node_in_group("jugador")

func _physics_process(delta):
	if derrotado:
		return
	if attack_cooldown > 0:
		attack_cooldown -= delta

	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
		
		if direction.x != 0:
			$AnimatedSprite2D.flip_h = direction.x < 0
		$AnimatedSprite2D.play("default")
		
		for i in get_slide_collision_count():
			var colision = get_slide_collision(i)
			var cuerpo_chocado = colision.get_collider()
			
			if cuerpo_chocado and cuerpo_chocado.is_in_group("jugador") and attack_cooldown <= 0:
				cuerpo_chocado.recibir_dano(dano)
				attack_cooldown = 1.0

func recibir_dano(cantidad):
	if derrotado:
		return
	vida -= cantidad
	
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.2)
	
	if vida <= 0:
		derrotado = true
		# DD-013: cada enemigo derrotado suelta exactamente un centavo (1 XP).
		var nueva_moneda = moneda_escena.instantiate()
		nueva_moneda.global_position = global_position
		# Collision callbacks run while physics queries are flushing.
		get_tree().current_scene.call_deferred("add_child", nueva_moneda)
		queue_free()
