extends SceneTree

## Runner de pruebas J03 — Javier Guzmán
## Ejecuta todos los casos de prueba de los algoritmos y reporta resultados.
## Salida: 0 si todo pasa, 1 si alguna prueba falla.
## Uso desde consola: godot --headless --script tests/algorithms/test_runner.gd

var _passed: int = 0
var _failed: int = 0

func _init():
	print("╔══════════════════════════════════════════════╗")
	print("║     RUNNER DE PRUEBAS — Javier Guzmán       ║")
	print("╚══════════════════════════════════════════════╝")
	print("")

	_run_suite_spawn_queue()
	_run_suite_action_history_stack()

	_report_final()

# ─────────────────────────────────────────────
# SUITE 1: SpawnQueue (Cola Circular Dinámica)
# ─────────────────────────────────────────────
func _run_suite_spawn_queue() -> void:
	print("📦 SpawnQueue")
	var q = SpawnQueue.new()

	# T01: Vacío inicial
	_assert("T01 Vacío inicial: is_empty=true",       q.is_empty())
	_assert("T01 Vacío inicial: size=0",              q.size() == 0)
	_assert("T01 Vacío inicial: peek=null",           q.peek() == null)
	_assert("T01 Vacío inicial: dequeue=null",        q.dequeue() == null)

	# T02: FIFO básico
	q.enqueue("A")
	q.enqueue("B")
	q.enqueue("C")
	_assert("T02 FIFO: size=3",                      q.size() == 3)
	_assert("T02 FIFO: peek devuelve A sin sacar",   q.peek() == "A" and q.size() == 3)
	_assert("T02 FIFO: dequeue devuelve A",          q.dequeue() == "A")
	_assert("T02 FIFO: dequeue devuelve B",          q.dequeue() == "B")
	_assert("T02 FIFO: dequeue devuelve C",          q.dequeue() == "C")
	_assert("T02 FIFO: queda vacía",                 q.is_empty())

	# T03: Wraparound y crecimiento
	for i in range(10):
		q.enqueue(i)
	var orden_correcto = true
	for i in range(10):
		if q.dequeue() != i:
			orden_correcto = false
	_assert("T03 Wraparound/crecimiento: orden FIFO correcto tras 10 elementos", orden_correcto)

	# T04: Clear
	q.enqueue("X")
	q.enqueue("Y")
	q.clear()
	_assert("T04 Clear: is_empty=true tras clear",   q.is_empty())
	_assert("T04 Clear: size=0 tras clear",          q.size() == 0)
	_assert("T04 Clear: peek=null tras clear",       q.peek() == null)
	print("")

# ─────────────────────────────────────────────
# SUITE 2: ActionHistoryStack (Pila LIFO)
# ─────────────────────────────────────────────
func _run_suite_action_history_stack() -> void:
	print("📚 ActionHistoryStack")
	var s = ActionHistoryStack.new()

	# T05: Vacío inicial
	_assert("T05 Vacío inicial: is_empty=true",              s.is_empty())
	_assert("T05 Vacío inicial: pop devuelve {}",            s.pop().is_empty())
	_assert("T05 Vacío inicial: peek devuelve {}",           s.peek().is_empty())

	# T06: LIFO básico
	s.push({"id": 1})
	s.push({"id": 2})
	s.push({"id": 3})
	_assert("T06 LIFO: pop devuelve el 3 (último)",         s.pop()["id"] == 3)
	_assert("T06 LIFO: pop devuelve el 2",                  s.pop()["id"] == 2)
	_assert("T06 LIFO: pop devuelve el 1 (primero)",        s.pop()["id"] == 1)
	_assert("T06 LIFO: queda vacía",                        s.is_empty())

	# T07: Copia profunda (Deep Copy)
	var original = {"armas": ["escopeta"]}
	s.push(original)
	original["armas"].append("machete") # Mutamos el original DESPUÉS del push
	var recuperado = s.pop()
	_assert("T07 Deep Copy: snapshot no se contamina con cambios posteriores",
			recuperado["armas"].size() == 1 and recuperado["armas"][0] == "escopeta")

	# T08: Límite de 64
	s.clear()
	for i in range(70):
		s.push({"id": i})
	_assert("T08 Límite 64: no excede 64 snapshots",         s._data.size() == 64)
	_assert("T08 Límite 64: el más antiguo que queda es id=6", s._data[0]["id"] == 6)

	# T09: Clear
	s.clear()
	_assert("T09 Clear: is_empty=true tras clear",           s.is_empty())
	print("")

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────
func _assert(label: String, condition: bool) -> void:
	if condition:
		print("  ✅ " + label)
		_passed += 1
	else:
		print("  ❌ FALLO: " + label)
		_failed += 1

func _report_final() -> void:
	print("══════════════════════════════════════════════")
	print("  Total: %d pruebas | ✅ %d pasaron | ❌ %d fallaron" % [_passed + _failed, _passed, _failed])
	print("══════════════════════════════════════════════")
	if _failed == 0:
		print("🎉 TODAS LAS PRUEBAS PASARON")
		quit(0)
	else:
		print("⚠️  EXISTEN PRUEBAS FALLIDAS — Revisar antes de hacer commit")
		quit(1)
