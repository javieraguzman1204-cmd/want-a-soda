class_name SpawnQueue
extends RefCounted

## Especificación J01 / Implementación J04: Cola circular dinámica
## Responsable: Javier Guzmán
## Uso: Manejo FIFO de eventos de oleada (WaveManager).

var _buffer: Array = []
var _head: int = 0
var _count: int = 0

## Agrega un evento al final de la cola.
## Complejidad: O(1) amortizado. Si se llena, duplica capacidad O(n).
func enqueue(event: Variant) -> void:
	# Si la cola está llena (o no tiene capacidad inicial), crecer.
	if _count == _buffer.size():
		_grow()
		
	# Calcular la posición del final (tail) usando módulo (wrap-around)
	var tail: int = (_head + _count) % _buffer.size()
	_buffer[tail] = event
	_count += 1

## Devuelve el evento en el frente de la cola sin sacarlo.
## Complejidad: O(1). Devuelve null si está vacía.
func peek() -> Variant:
	if _count == 0:
		return null
	return _buffer[_head]

## Saca y devuelve el evento en el frente de la cola (wraparound).
## Complejidad: O(1). Devuelve null si está vacía. No usa pop_front().
func dequeue() -> Variant:
	if _count == 0:
		return null
		
	var event = _buffer[_head]
	_buffer[_head] = null # Importante: Liberar la referencia para el Garbage Collector
	_head = (_head + 1) % _buffer.size()
	_count -= 1
	
	return event

## Retorna true si no hay elementos en la cola.
## Complejidad: O(1)
func is_empty() -> bool:
	return _count == 0

## Retorna la cantidad actual de elementos.
## Complejidad: O(1)
func size() -> int:
	return _count

## Copia los elementos pendientes en orden FIFO sin consumirlos.
## Complejidad: O(n) tiempo y espacio; los diccionarios se copian en profundidad.
func snapshot() -> Array:
	var elementos: Array = []
	for i in range(_count):
		elementos.append(_buffer[(_head + i) % _buffer.size()])
	return elementos.duplicate(true)

## Limpia la cola, liberando referencias y reseteando índices.
## Complejidad: O(1)
func clear() -> void:
	_buffer = [] # Al reasignar un array vacío, Godot limpia las referencias viejas
	_head = 0
	_count = 0

## Metodo interno para duplicar la capacidad de la cola
func _grow() -> void:
	var old_capacity: int = _buffer.size()
	var new_capacity: int = 4 if old_capacity == 0 else old_capacity * 2
	
	var new_buffer: Array = []
	new_buffer.resize(new_capacity)
	
	# Copiar los elementos de forma ordenada al nuevo buffer
	for i in range(_count):
		var old_index = (_head + i) % old_capacity
		new_buffer[i] = _buffer[old_index]
		
	_buffer = new_buffer
	_head = 0
