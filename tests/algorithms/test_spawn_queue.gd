extends SceneTree

# Pruebas de validación de J04: Cola Circular
func _init():
	print("--- Iniciando pruebas de SpawnQueue (J04) ---")
	var queue = SpawnQueue.new()
	var all_passed = true
	
	# Prueba 1: Vacío
	if not queue.is_empty() or queue.size() != 0 or queue.dequeue() != null:
		print("❌ FALLO: Estado vacío incorrecto")
		all_passed = false
		
	# Prueba 2: FIFO básico
	queue.enqueue(1)
	queue.enqueue(2)
	queue.enqueue(3)
	if queue.size() != 3 or queue.peek() != 1 or queue.dequeue() != 1 or queue.dequeue() != 2:
		print("❌ FALLO: Comportamiento FIFO incorrecto")
		all_passed = false
		
	# Prueba 3: Wraparound (dar la vuelta)
	queue.enqueue(4)
	queue.enqueue(5)
	queue.enqueue(6)
	queue.enqueue(7) # Aquí debería haber redimensionado y dado la vuelta correctamente
	if queue.dequeue() != 3 or queue.dequeue() != 4:
		print("❌ FALLO: Error al dar la vuelta (Wraparound)")
		all_passed = false
		
	# Prueba 4: Limpiar
	queue.clear()
	if not queue.is_empty() or queue.size() != 0:
		print("❌ FALLO: Error al limpiar (clear)")
		all_passed = false

	if all_passed:
		print("✅ TODAS LAS PRUEBAS DE J04 PASARON EXITOSAMENTE")
	else:
		print("❌ ALGUNAS PRUEBAS FALLARON")
		
	quit(0 if all_passed else 1)
