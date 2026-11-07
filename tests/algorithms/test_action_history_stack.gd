extends SceneTree

# Pruebas de validación de J05: Pila de Snapshots
func _init():
	print("--- Iniciando pruebas de ActionHistoryStack (J05) ---")
	var stack = ActionHistoryStack.new()
	var all_passed = true
	
	# Prueba 1: Vacío inicial
	if not stack.is_empty() or not stack.pop().is_empty() or not stack.peek().is_empty():
		print("❌ FALLO: Estado vacío incorrecto")
		all_passed = false
		
	# Prueba 2: Copia profunda (Deep Copy)
	var original_snapshot = {"armas": ["escopeta"]}
	stack.push(original_snapshot)
	# Mutamos el original añadiendo machete
	original_snapshot["armas"].append("machete") 
	
	var popped = stack.pop()
	# El snapshot extraído de la pila NO debe tener el machete
	if popped["armas"].size() != 1 or popped["armas"][0] != "escopeta":
		print("❌ FALLO: No se hizo copia profunda (Deep Copy)")
		all_passed = false
		
	# Prueba 3: LIFO básico (Último en entrar, primero en salir)
	stack.push({"id": 1})
	stack.push({"id": 2})
	stack.push({"id": 3})
	if stack.pop()["id"] != 3 or stack.pop()["id"] != 2 or stack.pop()["id"] != 1:
		print("❌ FALLO: Comportamiento LIFO incorrecto")
		all_passed = false
		
	# Prueba 4: Límite de 64 elementos
	stack.clear()
	for i in range(70):
		stack.push({"id": i}) # Empujamos 70
		
	# Deben quedar exactamente 64. Los IDs del 0 al 5 (los 6 más viejos) debieron borrarse.
	# El más viejo que sobrevive debe ser el ID 6.
	if stack._data.size() != 64:
		print("❌ FALLO: El límite de 64 no funciona (tamaño actual: %d)" % stack._data.size())
		all_passed = false
	elif stack._data[0]["id"] != 6:
		print("❌ FALLO: No se borró el elemento más antiguo al exceder el límite")
		all_passed = false

	if all_passed:
		print("✅ TODAS LAS PRUEBAS DE J05 PASARON EXITOSAMENTE")
	else:
		print("❌ ALGUNAS PRUEBAS FALLARON")
		
	quit(0 if all_passed else 1)
