extends SceneTree

const WaveManagerScript = preload("res://generador_enemigos.gd")
const TaserScript = preload("res://scripts/gameplay/taser_recursivo.gd")
const PlayerScene = preload("res://jugador(amado_neftali).tscn")

var _passed := 0
var _failed := 0

class FakeEnemy extends Node2D:
	var vida := 100
	var impactos := 0

	func recibir_dano(cantidad) -> void:
		vida -= cantidad
		impactos += 1

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	print("=== CHECKPOINT 2: PRUEBAS INTEGRADAS ===")
	_test_wave_fifo()
	_test_build_undo()
	_test_taser_recursivo()
	print("Total: %d | PASAN: %d | FALLAN: %d" % [_passed + _failed, _passed, _failed])
	quit(0 if _failed == 0 else 1)

func _test_wave_fifo() -> void:
	print("\n[Queue] Eventos reales de oleada")
	var mundo := Node2D.new()
	root.add_child(mundo)
	var jugador := Node2D.new()
	jugador.add_to_group("jugador")
	mundo.add_child(jugador)
	var manager = WaveManagerScript.new()
	mundo.add_child(manager)
	# SceneTree._init corre antes del primer frame; preparar explícitamente aquí.
	manager.preparar_oleada_demo()
	_assert("programa cinco eventos", manager.obtener_orden_programado().size() == 5)
	var recibidos: Array[String] = []
	for i in range(5):
		var evento: Dictionary = manager.despachar_siguiente_evento()
		recibidos.append(evento["id"])
	_assert("despacha FIFO W01..W05", recibidos == ["W01", "W02", "W03", "W04", "W05"])
	_assert("genera cinco enemigos reales", mundo.get_tree().get_nodes_in_group("enemigo").size() == 5)
	_assert("cola queda vacía", manager.pendientes() == 0)
	_assert("dequeue vacío no falla", manager.despachar_siguiente_evento().is_empty())
	mundo.free()

func _test_build_undo() -> void:
	print("\n[Stack] Mejoras reales y Undo LIFO")
	var jugador = PlayerScene.instantiate()
	var inicial: Dictionary = jugador.obtener_build()
	_assert("aplica mejora de daño", jugador.aplicar_mejora("dano"))
	_assert("daño cambia realmente", jugador.dano_escopeta == inicial["dano_escopeta"] + 5)
	_assert("aplica mejora de recarga", jugador.aplicar_mejora("recarga"))
	_assert("peek conserva estado previo", jugador.historial_build.peek()["dano_escopeta"] == inicial["dano_escopeta"] + 5)
	_assert("primer Undo restaura recarga", jugador.deshacer_ultima_mejora() and is_equal_approx(jugador.recarga_escopeta, inicial["recarga_escopeta"]))
	_assert("segundo Undo restaura daño", jugador.deshacer_ultima_mejora() and jugador.obtener_build() == inicial)
	_assert("Undo vacío es seguro", not jugador.deshacer_ultima_mejora())
	jugador.free()

func _test_taser_recursivo() -> void:
	print("\n[Recursión] Taser 0/1/3/8, límites y visited")
	var taser = TaserScript.new()
	taser.dano = 10
	taser.max_targets = 3
	taser.alcance_salto = 100.0
	_assert("caso 0 objetivos", taser.ejecutar_cadena(Vector2.ZERO, []).is_empty())
	_assert("cero objetivos reporta profundidad cero", taser.profundidad_real == 0 and taser.obtener_objetivo_mas_profundo() == null and taser.ultimo_motivo_corte == "sin_objetivo")
	var uno := FakeEnemy.new()
	uno.position = Vector2(10, 0)
	var cadena_uno: Array[Node] = taser.ejecutar_cadena(Vector2.ZERO, [uno])
	_assert("caso 1 objetivo", cadena_uno.size() == 1 and uno.vida == 90)
	_assert("un salto marca al objetivo más profundo", taser.profundidad_real == 1 and taser.obtener_objetivo_mas_profundo() == uno)
	var a := FakeEnemy.new()
	var b := FakeEnemy.new()
	var c := FakeEnemy.new()
	a.position = Vector2(10, 0)
	b.position = Vector2(30, 0)
	c.position = Vector2(50, 0)
	var cadena_tres: Array[Node] = taser.ejecutar_cadena(Vector2.ZERO, [a, b, c])
	_assert("caso 3 objetivos", cadena_tres.size() == 3)
	_assert("tres saltos alcanzan profundidad tres", taser.profundidad_real == 3 and taser.obtener_objetivo_mas_profundo() == c and taser.ultimo_motivo_corte == "limite")
	_assert("cada enemigo recibe daño real", a.vida == 90 and b.vida == 90 and c.vida == 90)
	_assert("visited evita repeticiones", a.impactos == 1 and b.impactos == 1 and c.impactos == 1)
	var ocho: Array[Node] = []
	for i in range(8):
		var enemigo := FakeEnemy.new()
		enemigo.position = Vector2(10 + i * 10, 0)
		ocho.append(enemigo)
	taser.max_targets = 8
	var cadena_ocho := taser.ejecutar_cadena(Vector2.ZERO, ocho)
	_assert("caso 8 objetivos", cadena_ocho.size() == 8)
	_assert("profundidad ocho señala el último objetivo", taser.profundidad_real == 8 and taser.obtener_objetivo_mas_profundo() == ocho[7] and taser.ultimo_motivo_corte == "limite")
	var todos_una_vez := true
	for enemigo in ocho:
		todos_una_vez = todos_una_vez and enemigo.impactos == 1
	_assert("ocho objetivos sin repeticiones", todos_una_vez)
	taser.max_targets = 20
	_assert("límite duro de 8", taser.ejecutar_cadena(Vector2.ZERO, ocho).size() == 8)
	taser.max_targets = 0
	_assert("límite cero no impacta", taser.ejecutar_cadena(Vector2.ZERO, ocho).is_empty())
	_assert("descarga nueva reinicia el análisis recursivo", taser.profundidad_real == 0 and taser.obtener_objetivo_mas_profundo() == null and taser.ultimo_motivo_corte == "limite")
	taser.max_targets = 3
	taser.alcance_salto = 5.0
	_assert("fuera de radio corta la cadena", taser.ejecutar_cadena(Vector2.ZERO, [a, b]).size() == 1)
	_assert("corte por alcance conserva la profundidad real", taser.profundidad_real == 1 and taser.obtener_objetivo_mas_profundo() == a and taser.ultimo_motivo_corte == "fuera_de_alcance")
	taser.free()
	uno.free()
	a.free()
	b.free()
	c.free()
	for enemigo in ocho:
		enemigo.free()

func _assert(label: String, condition: bool) -> void:
	if condition:
		print("  OK  ", label)
		_passed += 1
	else:
		print("  FALLO  ", label)
		_failed += 1
