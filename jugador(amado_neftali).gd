extends CharacterBody2D

const ActionHistoryStackScript = preload("res://scripts/algorithms/action_history_stack.gd")

var speed = 300.0
var vida = 100 
var vida_maxima = 100 
var bala_escena = preload("res://bala.tscn")
var dano_escopeta: int = 15
var recarga_escopeta: float = 2.0
var historial_build = ActionHistoryStackScript.new()
var ultimo_mensaje_build: String = "Sin mejoras aplicadas"
var elecciones_pendientes: int = 0
const NIVEL_MAXIMO: int = 20

# Variables de XP y Nivel con tu fórmula oficial
var xp_actual = 0
var nivel_actual = 1
var xp_para_siguiente_nivel = 5 # Nivel 1 -> 2 pide 5 XP iniciales

func _ready():
	$BarraVida.max_value = vida_maxima
	$BarraVida.value = vida
	$TimerEscopeta.wait_time = recarga_escopeta
	var menu = get_node_or_null("../MenuNivel")
	if menu:
		menu.mejora_seleccionada.connect(_on_mejora_seleccionada)
		menu.deshacer_solicitado.connect(deshacer_ultima_mejora)
	actualizar_hud_xp()
	actualizar_hud_build()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1:
				aplicar_mejora("dano")
			KEY_2:
				aplicar_mejora("recarga")
			KEY_Z:
				deshacer_ultima_mejora()

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	velocity = direction * speed
	move_and_slide()
	
	# Poder de empuje a los enemigos
	for i in get_slide_collision_count():
		var colision = get_slide_collision(i)
		var cuerpo_chocado = colision.get_collider()
		
		if cuerpo_chocado and cuerpo_chocado.is_in_group("enemigo"):
			cuerpo_chocado.global_position -= colision.get_normal() * (speed * 0.8) * delta

	if direction.length() > 0:
		$AnimatedSprite2D.play("caminar")
		if direction.x != 0:
			$AnimatedSprite2D.flip_h = direction.x < 0
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 0

func recibir_dano(cantidad):
	vida -= cantidad
	$BarraVida.value = vida
	
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.2)
	
	if vida <= 0:
		print("¡Amado Neftalí fue derrotado!")

# --- SISTEMA DE EXPERIENCIA Y FÓRMULA OFICIAL ---
func ganar_xp(cantidad):
	if cantidad <= 0 or nivel_actual >= NIVEL_MAXIMO:
		return
	xp_actual += cantidad
	while nivel_actual < NIVEL_MAXIMO and xp_actual >= xp_para_siguiente_nivel:
		xp_actual -= xp_para_siguiente_nivel
		subir_nivel()
	if nivel_actual >= NIVEL_MAXIMO:
		xp_actual = 0
	actualizar_hud_xp()
	_abrir_mejora_pendiente()

func subir_nivel():
	nivel_actual += 1
	elecciones_pendientes += 1
	# Aplicando tu fórmula exacta: XP necesaria = 5 + 10(n - 1)
	xp_para_siguiente_nivel = 5 + 10 * (nivel_actual - 1)
	
	print("🎉 ¡SUBISTE DE NIVEL! Nivel actual: ", nivel_actual, " | XP requerida: ", xp_para_siguiente_nivel)
	actualizar_hud_xp()

func _abrir_mejora_pendiente() -> void:
	if elecciones_pendientes <= 0 or not is_inside_tree():
		return
	var menu = get_node_or_null("../MenuNivel")
	if menu == null or menu.visible:
		return
	menu.abrir(recarga_escopeta > 0.5)
	_establecer_pausa_mejora(true)

func _on_mejora_seleccionada(tipo: String) -> void:
	if elecciones_pendientes <= 0 or not aplicar_mejora(tipo):
		return
	elecciones_pendientes -= 1
	var menu = get_node_or_null("../MenuNivel")
	if menu == null:
		return
	if elecciones_pendientes > 0:
		menu.abrir(recarga_escopeta > 0.5)
	else:
		menu.hide()
		_establecer_pausa_mejora(false)

func _establecer_pausa_mejora(activa: bool) -> void:
	var controlador = get_node_or_null("../CheckpointController")
	if controlador != null:
		controlador.establecer_pausa_mejora(activa)
	else:
		get_tree().paused = activa

func obtener_build() -> Dictionary:
	return {
		"dano_escopeta": dano_escopeta,
		"recarga_escopeta": recarga_escopeta,
		"speed": speed,
	}

func aplicar_mejora(tipo: String) -> bool:
	if tipo != "dano" and tipo != "recarga" and tipo != "velocidad":
		ultimo_mensaje_build = "Mejora desconocida: " + tipo
		actualizar_hud_build()
		return false
	if tipo == "recarga" and recarga_escopeta <= 0.5:
		ultimo_mensaje_build = "Recarga ya está en el mínimo"
		actualizar_hud_build()
		return false
	historial_build.push(obtener_build())
	if tipo == "dano":
		dano_escopeta += 5
		ultimo_mensaje_build = "Mejora aplicada: daño +5"
	elif tipo == "recarga":
		recarga_escopeta = maxf(0.5, recarga_escopeta - 0.25)
		$TimerEscopeta.wait_time = recarga_escopeta
		ultimo_mensaje_build = "Mejora aplicada: recarga -0.25 s"
	else:
		speed *= 1.2
		ultimo_mensaje_build = "Mejora aplicada: velocidad +20%"
	actualizar_hud_build()
	return true

func deshacer_ultima_mejora() -> bool:
	var previo: Dictionary = historial_build.pop()
	if previo.is_empty():
		ultimo_mensaje_build = "Undo: historial vacío (sin cambios)"
		actualizar_hud_build()
		return false
	dano_escopeta = int(previo["dano_escopeta"])
	recarga_escopeta = float(previo["recarga_escopeta"])
	speed = float(previo["speed"])
	$TimerEscopeta.wait_time = recarga_escopeta
	ultimo_mensaje_build = "Undo LIFO: build anterior restaurado"
	actualizar_hud_build()
	return true

func actualizar_hud_build() -> void:
	if not is_inside_tree() or get_tree().current_scene == null:
		return
	var texto_build = get_tree().current_scene.get_node_or_null("HUD/PanelCheckpoint/TextoBuild")
	if texto_build:
		texto_build.text = "BUILD — Daño: %d | Recarga: %.2f s | Velocidad: %.0f | Historial: %d\n%s" % [
			dano_escopeta,
			recarga_escopeta,
			speed,
			historial_build._data.size(),
			ultimo_mensaje_build,
		]

func actualizar_hud_xp():
	if not is_inside_tree() or get_tree().current_scene == null:
		return
	var barra_xp = get_tree().current_scene.get_node_or_null("HUD/BarraXP")
	if barra_xp:
		barra_xp.max_value = xp_para_siguiente_nivel
		barra_xp.value = xp_actual
		
	var texto_nivel = get_tree().current_scene.get_node_or_null("HUD/TextoNivel")
	if texto_nivel:
		texto_nivel.text = "Nivel: " + str(nivel_actual)

func _on_timer_escopeta_timeout():
	var enemigos = get_tree().get_nodes_in_group("enemigo")
	if enemigos.size() == 0:
		return 
	
	var enemigo_cercano = enemigos[0]
	var distancia_minima = global_position.distance_to(enemigo_cercano.global_position)
	
	for enemigo in enemigos:
		var distancia = global_position.distance_to(enemigo.global_position)
		if distancia < distancia_minima:
			enemigo_cercano = enemigo
			distancia_minima = distancia
			
	var nueva_bala = bala_escena.instantiate()
	nueva_bala.dano = dano_escopeta
	get_parent().add_child(nueva_bala)
	
	nueva_bala.global_position = global_position
	nueva_bala.direction = global_position.direction_to(enemigo_cercano.global_position)
	nueva_bala.objetivo = enemigo_cercano
