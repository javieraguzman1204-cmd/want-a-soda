class_name TaserRecursivo
extends Node2D

const MAX_TARGETS := 8

@export var dano: int = 10
@export var max_targets: int = 3
@export var alcance_salto: float = 360.0

var ultimo_resultado: Array[Node] = []
var profundidad_real: int = 0
var ultimo_objetivo_profundo_id: int = 0
var ultimo_motivo_corte: String = "sin_descarga"

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_T:
		disparar()

func _on_timer_timeout() -> void:
	disparar()

func disparar() -> Array[Node]:
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador == null:
		ultimo_resultado = []
		_reiniciar_analisis()
		ultimo_motivo_corte = "sin_jugador"
		_actualizar_hud("TASER — 0 objetivos (sin jugador)")
		return ultimo_resultado
	var candidatos: Array[Node] = []
	for nodo in get_tree().get_nodes_in_group("enemigo"):
		if is_instance_valid(nodo) and nodo.has_method("recibir_dano"):
			candidatos.append(nodo)
	ultimo_resultado = ejecutar_cadena(jugador.global_position, candidatos)
	_dibujar_cadena(jugador.global_position, ultimo_resultado)
	_actualizar_hud("TASER — %d/%d | prof. %d | fin: %s" % [
		ultimo_resultado.size(), clampi(max_targets, 0, MAX_TARGETS),
		profundidad_real, ultimo_motivo_corte,
	])
	return ultimo_resultado

func ejecutar_cadena(origen: Vector2, candidatos: Array[Node]) -> Array[Node]:
	_reiniciar_analisis()
	var visitados: Dictionary = {}
	var resultado: Array[Node] = []
	var primero := _buscar_mas_cercano(origen, candidatos, visitados)
	_encadenar_recursivo(
		primero,
		candidatos,
		visitados,
		clampi(max_targets, 0, MAX_TARGETS),
		resultado,
		1
	)
	return resultado

## Adaptación recursiva: profundidad realmente alcanzada y objetivo final.
func obtener_objetivo_mas_profundo() -> Node:
	if ultimo_objetivo_profundo_id == 0:
		return null
	return instance_from_id(ultimo_objetivo_profundo_id)

func _reiniciar_analisis() -> void:
	profundidad_real = 0
	ultimo_objetivo_profundo_id = 0
	ultimo_motivo_corte = "sin_objetivo"

func _encadenar_recursivo(
	actual: Node,
	candidatos: Array[Node],
	visitados: Dictionary,
	restantes: int,
	resultado: Array[Node],
	profundidad: int
) -> void:
	if restantes <= 0:
		ultimo_motivo_corte = "limite"
		return
	if actual == null:
		ultimo_motivo_corte = "sin_objetivo"
		return
	if not is_instance_valid(actual):
		ultimo_motivo_corte = "objetivo_invalido"
		return
	var id := actual.get_instance_id()
	if visitados.has(id):
		ultimo_motivo_corte = "visitado"
		return
	visitados[id] = true
	profundidad_real = profundidad
	ultimo_objetivo_profundo_id = id
	var posicion_actual: Vector2 = actual.global_position
	actual.recibir_dano(dano)
	resultado.append(actual)
	# Paso recursivo: buscar el vecino no visitado y resolver el resto.
	var siguiente := _buscar_mas_cercano(posicion_actual, candidatos, visitados)
	if siguiente != null and posicion_actual.distance_to(siguiente.global_position) > alcance_salto:
		ultimo_motivo_corte = "fuera_de_alcance"
		return
	_encadenar_recursivo(siguiente, candidatos, visitados, restantes - 1, resultado, profundidad + 1)

func _buscar_mas_cercano(
	origen: Vector2,
	candidatos: Array[Node],
	visitados: Dictionary
) -> Node:
	var elegido: Node = null
	var distancia_elegida := INF
	for candidato in candidatos:
		if not is_instance_valid(candidato) or visitados.has(candidato.get_instance_id()):
			continue
		var distancia := origen.distance_to(candidato.global_position)
		if distancia < distancia_elegida:
			distancia_elegida = distancia
			elegido = candidato
	return elegido

func _dibujar_cadena(origen: Vector2, objetivos: Array[Node]) -> void:
	if objetivos.is_empty():
		return
	var linea := Line2D.new()
	linea.width = 7.0
	linea.default_color = Color(0.2, 0.9, 1.0, 0.95)
	linea.z_index = 20
	linea.add_point(to_local(origen))
	for objetivo in objetivos:
		if is_instance_valid(objetivo):
			linea.add_point(to_local(objetivo.global_position))
	add_child(linea)
	var tween := linea.create_tween()
	tween.tween_property(linea, "modulate:a", 0.0, 0.35)
	tween.tween_callback(linea.queue_free)
	var objetivo_final := obtener_objetivo_mas_profundo()
	if objetivo_final != null:
		var marca := Line2D.new()
		marca.width = 3.0
		marca.default_color = Color(1.0, 0.9, 0.2, 0.95)
		marca.z_index = 21
		var centro: Vector2 = to_local(objetivo_final.global_position)
		for i in range(17):
			marca.add_point(centro + Vector2.from_angle(TAU * float(i) / 16.0) * 24.0)
		add_child(marca)
		var marca_tween := marca.create_tween()
		marca_tween.tween_property(marca, "modulate:a", 0.0, 0.35)
		marca_tween.tween_callback(marca.queue_free)

func _actualizar_hud(mensaje: String) -> void:
	if not is_inside_tree() or get_tree().current_scene == null:
		return
	var texto = get_tree().current_scene.get_node_or_null("HUD/PanelCheckpoint/TextoTaser")
	if texto:
		texto.text = mensaje
