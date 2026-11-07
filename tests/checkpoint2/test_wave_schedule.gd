extends SceneTree

const WaveManagerScript = preload("res://generador_enemigos.gd")
const QueueScript = preload("res://scripts/algorithms/spawn_queue.gd")

var _passed := 0
var _failed := 0

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	print("=== CHECKPOINT 2: EVENTOS FIFO PROGRAMADOS ===")
	var queue = QueueScript.new()
	queue.enqueue({"id": "A"})
	queue.enqueue({"id": "B"})
	var copia: Array = queue.snapshot()
	copia[0]["id"] = "CAMBIO"
	_assert("snapshot no consume ni altera la cola", queue.size() == 2 and queue.peek()["id"] == "A")
	queue.dequeue()
	queue.enqueue({"id": "C"})
	_assert("snapshot respeta wraparound", [queue.snapshot()[0]["id"], queue.snapshot()[1]["id"]] == ["B", "C"])

	var mundo := Node2D.new()
	root.add_child(mundo)
	var manager = WaveManagerScript.new()
	mundo.add_child(manager)
	var eventos: Array[Dictionary] = [
		{"id": "A", "sequence": 1, "time_s": 1.0, "type": "spawn", "count": 1, "angle": 0.0},
		{"id": "B", "sequence": 2, "time_s": 1.0, "type": "warning_spawn", "count": 1, "angle": 0.0, "message": "Aviso"},
		{"id": "C", "sequence": 3, "time_s": 2.0, "type": "spawn", "count": 7, "angle": 0.0},
	]
	_assert("acepta eventos ordenados", manager.programar_eventos(eventos))
	_assert("cuenta tipos sin consumir", manager.contar_eventos_de_tipo("warning_spawn") == 1 and manager.pendientes() == 3)
	_assert("no ejecuta antes de tiempo", manager.avanzar_tiempo(0.9) == 0)
	_assert("sin jugador conserva frente", manager.avanzar_tiempo(0.2) == 0 and manager.obtener_frente()["id"] == "A")
	var jugador := Node2D.new()
	jugador.add_to_group("jugador")
	mundo.add_child(jugador)
	_assert("empate conserva secuencia", manager.procesar_eventos_pendientes() == 2 and manager.obtener_orden_ejecutado() == ["A", "B"])
	_assert("salto de tiempo limita a cinco spawns", manager.avanzar_tiempo(10.0) == 5)
	_assert("evento parcial permanece con dos spawns", manager.pendientes() == 1 and manager.obtener_frente()["remaining"] == 2)
	_assert("siguiente frame completa evento", manager.procesar_eventos_pendientes() == 2 and manager.obtener_orden_ejecutado() == ["A", "B", "C"])
	_assert("cola vacía no genera", manager.procesar_eventos_pendientes() == 0)
	mundo.free()

	var mundo_cap := Node2D.new()
	root.add_child(mundo_cap)
	var jugador_cap := Node2D.new()
	jugador_cap.add_to_group("jugador")
	mundo_cap.add_child(jugador_cap)
	var manager_cap = WaveManagerScript.new()
	mundo_cap.add_child(manager_cap)
	for i in range(50):
		var enemigo := Node2D.new()
		enemigo.add_to_group("enemigo")
		mundo_cap.add_child(enemigo)
	_assert("cap 50 conserva el evento", manager_cap.avanzar_tiempo(10.0) == 0 and manager_cap.pendientes() == 5)
	mundo_cap.get_children().back().free()
	_assert("al liberar espacio reanuda FIFO", manager_cap.procesar_eventos_pendientes() == 1 and manager_cap.obtener_orden_ejecutado() == ["W01"])
	paused = true
	var tiempo_pausado: float = manager_cap.obtener_tiempo_s()
	await create_timer(0.05).timeout
	_assert("pausa detiene el reloj de oleadas", is_equal_approx(manager_cap.obtener_tiempo_s(), tiempo_pausado))
	paused = false
	mundo_cap.free()

	print("Total: %d | PASAN: %d | FALLAN: %d" % [_passed + _failed, _passed, _failed])
	quit(0 if _failed == 0 else 1)

func _assert(nombre: String, condicion: bool) -> void:
	if condicion:
		_passed += 1
		print("PASS: ", nombre)
	else:
		_failed += 1
		push_error("FAIL: " + nombre)
