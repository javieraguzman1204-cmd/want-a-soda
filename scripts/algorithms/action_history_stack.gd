class_name ActionHistoryStack
extends RefCounted

## Especificación J01 / Implementación J05: Pila de historiales (Snapshots)
## Responsable: Javier Guzmán
## Uso: Almacenar estados del inventario para la función Undo académico.
## Límite: 64 snapshots máximo.

var _data: Array = []
const MAX_SNAPSHOTS: int = 64

## Agrega un snapshot haciendo una copia profunda del estado.
## Complejidad: O(1) amortizado para el push, O(n) por la copia del build.
## Si excede los 64 elementos, elimina el más antiguo (coste O(H) documentado).
func push(snapshot: Dictionary) -> void:
	# Hacer una copia profunda (deep copy) duplicando de forma recursiva
	# Esto previene que los cambios futuros arruinen la foto del pasado
	var copy = snapshot.duplicate(true)
	
	_data.push_back(copy)
	
	# Si excedemos el límite, eliminamos el más antiguo (índice 0)
	# Esto tiene un coste de O(H) donde H es el límite máximo (64)
	if _data.size() > MAX_SNAPSHOTS:
		_data.pop_front()

## Extrae y devuelve el snapshot más reciente (LIFO).
## Complejidad: O(1). Devuelve un diccionario vacío si no hay historial.
func pop() -> Dictionary:
	if _data.is_empty():
		return {}
	return _data.pop_back()

## Devuelve el snapshot más reciente sin extraerlo.
## Complejidad: O(1). Devuelve un diccionario vacío si no hay historial.
func peek() -> Dictionary:
	if _data.is_empty():
		return {}
	return _data.back()

## Retorna true si el historial está vacío (deshabilita botón Undo).
## Complejidad: O(1)
func is_empty() -> bool:
	return _data.is_empty()

## Vacía el historial completamente (ej. al reiniciar partida).
## Complejidad: O(1)
func clear() -> void:
	_data.clear()
