class_name WaveManager
extends Node

signal estado_cola_cambio(programados: Array, ejecutados: Array, pendientes: int)

const SpawnQueueScript = preload("res://scripts/algorithms/spawn_queue.gd")
const ENEMIGO_ESCENA = preload("res://enemigo(gordo_bolito).tscn")
const MAX_SPAWNS_PER_FRAME := 5
const MAX_ACTIVE_ENEMIES := 50

@export var radio_spawn: float = 260.0

var _cola = SpawnQueueScript.new()
var _programados: Array[String] = []
var _ejecutados: Array[String] = []
var _tiempo_s := 0.0
var _ultimo_evento := "—"
var _ultimo_evento_data: Dictionary = {}

func _ready() -> void:
	preparar_oleada_demo()

func _process(delta: float) -> void:
	avanzar_tiempo(delta)

func preparar_oleada_demo() -> void:
	var eventos: Array[Dictionary] = [
		{"id": "W01", "sequence": 1, "time_s": 1.0, "type": "spawn", "count": 1, "angle": 0.00},
		{"id": "W02", "sequence": 2, "time_s": 2.0, "type": "spawn", "count": 1, "angle": 0.55},
		{"id": "W03", "sequence": 3, "time_s": 2.0, "type": "warning_spawn", "count": 1, "angle": 1.10, "message": "¡Oleada en camino!"},
		{"id": "W04", "sequence": 4, "time_s": 3.0, "type": "spawn", "count": 1, "angle": 2.75},
		{"id": "W05", "sequence": 5, "time_s": 4.0, "type": "spawn", "count": 1, "angle": 3.40},
	]
	programar_eventos(eventos)

## Rechaza eventos fuera de orden para preservar FIFO por (time_s, sequence).
func programar_eventos(eventos: Array[Dictionary]) -> bool:
	var vistos := {}
	var tiempo_anterior := -1.0
	var secuencia_anterior := -1
	for evento in eventos:
		if not evento.has_all(["id", "sequence", "time_s", "type", "count", "angle"]):
			return false
		var id := str(evento["id"])
		var secuencia := int(evento["sequence"])
		var tiempo := float(evento["time_s"])
		var tipo := str(evento["type"])
		if id.is_empty() or vistos.has(id) or secuencia <= 0 or tiempo < 0.0 or int(evento["count"]) < 1:
			return false
		if tipo != "spawn" and tipo != "warning_spawn":
			return false
		if tiempo < tiempo_anterior or (tiempo == tiempo_anterior and secuencia <= secuencia_anterior):
			return false
		vistos[id] = true
		tiempo_anterior = tiempo
		secuencia_anterior = secuencia
	_cola.clear()
	_programados.clear()
	_ejecutados.clear()
	_tiempo_s = 0.0
	_ultimo_evento = "—"
	_ultimo_evento_data.clear()
	for evento in eventos:
		var pendiente := evento.duplicate(true)
		pendiente["remaining"] = int(evento["count"])
		_cola.enqueue(pendiente)
		_programados.append(str(evento["id"]))
	_emitir_estado()
	print("FIFO programado: ", " -> ".join(_programados))
	return true

func avanzar_tiempo(delta: float) -> int:
	_tiempo_s += maxf(delta, 0.0)
	return procesar_eventos_pendientes()

func procesar_eventos_pendientes() -> int:
	var generados := 0
	while generados < MAX_SPAWNS_PER_FRAME and _procesar_un_spawn(false):
		generados += 1
	return generados

## Punto de prueba: ejecuta un spawn sin esperar el reloj.
func despachar_siguiente_evento() -> Dictionary:
	var completados := _ejecutados.size()
	if not _procesar_un_spawn(true):
		return {}
	if _ejecutados.size() > completados:
		return _ultimo_evento_data.duplicate(true)
	return {}

func _procesar_un_spawn(ignorar_tiempo: bool) -> bool:
	if _cola.is_empty() or not is_inside_tree():
		return false
	var evento: Dictionary = _cola.peek()
	if not ignorar_tiempo and float(evento["time_s"]) > _tiempo_s:
		return false
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador == null or get_tree().get_nodes_in_group("enemigo").size() >= MAX_ACTIVE_ENEMIES:
		return false # Se reintentará sin perder el evento.
	var nuevo_enemigo = ENEMIGO_ESCENA.instantiate()
	var direccion := Vector2.from_angle(float(evento["angle"]))
	nuevo_enemigo.global_position = jugador.global_position + direccion * radio_spawn
	get_parent().add_child(nuevo_enemigo)
	evento["remaining"] = int(evento["remaining"]) - 1
	if int(evento["remaining"]) == 0:
		_cola.dequeue()
		_ejecutados.append(str(evento["id"]))
		_ultimo_evento_data = evento.duplicate(true)
		_ultimo_evento = "%s: %s" % [evento["id"], evento.get("message", "enemigo generado")]
		print("FIFO ejecutado #%d: %s (%s)" % [evento["sequence"], evento["id"], evento["type"]])
	_emitir_estado()
	return true

func obtener_orden_programado() -> Array[String]:
	return _programados.duplicate()

func obtener_orden_ejecutado() -> Array[String]:
	return _ejecutados.duplicate()

func pendientes() -> int:
	return _cola.size()

func obtener_frente() -> Dictionary:
	return {} if _cola.is_empty() else _cola.peek().duplicate(true)

func obtener_tiempo_s() -> float:
	return _tiempo_s

func contar_eventos_de_tipo(tipo: String) -> int:
	var cantidad := 0
	for evento in _cola.snapshot():
		if evento["type"] == tipo:
			cantidad += 1
	return cantidad

func _emitir_estado() -> void:
	estado_cola_cambio.emit(_programados.duplicate(), _ejecutados.duplicate(), _cola.size())
	if not is_inside_tree() or get_tree().current_scene == null:
		return
	var texto = get_tree().current_scene.get_node_or_null("HUD/PanelCheckpoint/TextoCola")
	if texto:
		var ejecutados_texto := "—" if _ejecutados.is_empty() else " → ".join(_ejecutados)
		var frente := obtener_frente()
		var siguiente := "—" if frente.is_empty() else "%s a %.1f s (%d restante)" % [frente["id"], frente["time_s"], frente["remaining"]]
		texto.text = "FIFO — Programados: %s\nEjecutados: %s | Pendientes: %d\nSiguiente: %s | Último: %s" % [
			" → ".join(_programados), ejecutados_texto, _cola.size(), siguiente, _ultimo_evento,
		]
