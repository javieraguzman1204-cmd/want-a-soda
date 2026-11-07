extends SceneTree

const WorldScene = preload("res://mundo.tscn")
const EnemyScene = preload("res://enemigo(gordo_bolito).tscn")

var _passed := 0
var _failed := 0

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	print("=== CHECKPOINT 2: XP, MENÚ Y UNDO ===")
	var mundo = WorldScene.instantiate()
	root.add_child(mundo)
	current_scene = mundo
	var jugador = mundo.get_node("Jugador(Amado Neftali)")
	var menu = mundo.get_node("MenuNivel")
	var controlador = mundo.get_node("CheckpointController")
	var texto_estado = mundo.get_node("HUD/PanelCheckpoint/TextoEstado")
	jugador.actualizar_hud_xp()
	jugador.actualizar_hud_build()
	var build_inicial: Dictionary = jugador.obtener_build()

	# DD-013: derrota y pickup garantizados, sin duplicar XP por dos señales.
	var enemigo = EnemyScene.instantiate()
	enemigo.global_position = Vector2(10000, 10000)
	mundo.add_child(enemigo)
	enemigo.recibir_dano(enemigo.vida)
	enemigo.recibir_dano(1)
	await process_frame
	var monedas: Array[Node] = []
	for hijo in mundo.get_children():
		if hijo.get_script() != null and hijo.get_script().resource_path == "res://moneda_xp.gd":
			monedas.append(hijo)
	_assert("enemigo derrotado suelta exactamente una moneda", monedas.size() == 1)
	if monedas.size() == 1:
		monedas[0]._on_body_entered(jugador)
		monedas[0]._on_body_entered(jugador)
		_assert("pickup duplicado solo otorga 1 XP", jugador.xp_actual == 1)

	jugador.ganar_xp(19)
	_assert("20 XP alcanzan nivel 3", jugador.nivel_actual == 3)
	_assert("no se pierden ni duplican XP", jugador.xp_actual == 0)
	_assert("dos niveles crean dos elecciones", jugador.elecciones_pendientes == 2)
	_assert("menú visible y juego pausado", menu.visible and paused)
	_assert("HUD indica pausa de mejora", texto_estado.text.contains("MEJORA"))
	_assert("las tres ofertas corresponden a mejoras reales", _ids(menu) == ["dano", "recarga", "velocidad"])
	_assert("índice inválido no aplica mejora", not menu.seleccionar_mejora(-1) and jugador.obtener_build() == build_inicial)
	var tecla_p := InputEventKey.new()
	tecla_p.keycode = KEY_P
	tecla_p.pressed = true
	controlador._unhandled_input(tecla_p)
	_assert("P no omite una elección pendiente", paused and menu.visible)

	menu.get_node("VBoxContainer/Boton%d" % (_indice(menu, "dano") + 1)).pressed.emit()
	_assert("primera oferta cambia el daño real", jugador.dano_escopeta == build_inicial["dano_escopeta"] + 5)
	_assert("sigue abierta la segunda elección", jugador.elecciones_pendientes == 1 and menu.visible and paused)
	menu.get_node("VBoxContainer/Boton%d" % (_indice(menu, "recarga") + 1)).pressed.emit()
	_assert("segunda oferta cambia la recarga real", is_equal_approx(jugador.recarga_escopeta, build_inicial["recarga_escopeta"] - 0.25))
	_assert("terminadas las elecciones se reanuda", jugador.elecciones_pendientes == 0 and not menu.visible and not paused)
	_assert("HUD vuelve a EN JUEGO", texto_estado.text.contains("EN JUEGO"))
	_assert("dos mejoras crean dos entradas de historial", jugador.historial_build._data.size() == 2)
	_assert("primer Undo revierte solo la recarga", jugador.deshacer_ultima_mejora() and is_equal_approx(jugador.recarga_escopeta, build_inicial["recarga_escopeta"]) and jugador.dano_escopeta == build_inicial["dano_escopeta"] + 5)
	_assert("segundo Undo restaura build inicial", jugador.deshacer_ultima_mejora() and jugador.obtener_build() == build_inicial)
	_assert("Undo no revierte XP o nivel", jugador.nivel_actual == 3 and jugador.xp_actual == 0)

	jugador.ganar_xp(26)
	_assert("XP sobrante se conserva", jugador.nivel_actual == 4 and jugador.xp_actual == 1 and jugador.elecciones_pendientes == 1)
	menu.seleccionar_mejora(_indice(menu, "velocidad"))
	_assert("velocidad modifica movimiento real", is_equal_approx(jugador.speed, build_inicial["speed"] * 1.2))
	jugador.ganar_xp(34)
	_assert("siguiente nivel abre de nuevo el menú", jugador.nivel_actual == 5 and menu.visible and paused)
	menu.get_node("VBoxContainer/Button").pressed.emit()
	_assert("botón Undo restaura velocidad", jugador.obtener_build() == build_inicial)
	_assert("botón Undo no consume elección", jugador.elecciones_pendientes == 1 and menu.visible and paused)
	menu.seleccionar_mejora(_indice(menu, "dano"))
	_assert("se puede elegir tras Undo", jugador.dano_escopeta == build_inicial["dano_escopeta"] + 5 and not paused)
	jugador.deshacer_ultima_mejora()
	for i in range(6):
		jugador.aplicar_mejora("recarga")
	_assert("recarga tiene mínimo de 0.5 s", is_equal_approx(jugador.recarga_escopeta, 0.5))
	jugador.ganar_xp(45)
	_assert("menú no ofrece recarga sin efecto", _ids(menu) == ["dano", "velocidad"] and not menu.get_node("VBoxContainer/Boton3").visible)
	menu.seleccionar_mejora(_indice(menu, "velocidad"))
	_assert("opción disponible aún aplica mejora", jugador.speed > build_inicial["speed"] and not paused)

	var jugador_cap = preload("res://jugador(amado_neftali).tscn").instantiate()
	jugador_cap.ganar_xp(10000)
	_assert("nivel máximo es 20", jugador_cap.nivel_actual == 20 and jugador_cap.xp_actual == 0)
	jugador_cap.free()

	paused = false
	print("Total: %d | PASAN: %d | FALLAN: %d" % [_passed + _failed, _passed, _failed])
	quit(0 if _failed == 0 else 1)

func _ids(menu) -> Array[String]:
	var ids: Array[String] = []
	for opcion in menu.opciones_actuales:
		ids.append(opcion["id"])
	ids.sort()
	return ids

func _indice(menu, tipo: String) -> int:
	for i in range(menu.opciones_actuales.size()):
		if menu.opciones_actuales[i]["id"] == tipo:
			return i
	return -1

func _assert(label: String, condition: bool) -> void:
	if condition:
		print("  OK  ", label)
		_passed += 1
	else:
		print("  FALLO  ", label)
		_failed += 1
