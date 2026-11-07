extends CanvasLayer

## Interfaz de tres opciones basada en el menú de Guillermo Córdova.
## El jugador conserva el único historial y aplica los efectos reales.
signal mejora_seleccionada(tipo: String)
signal deshacer_solicitado

const MEJORAS = [
	{"id": "dano", "nombre": "Escopeta: daño +5", "desc": "Las balas hacen cinco puntos más de daño."},
	{"id": "recarga", "nombre": "Raptor: recarga -0.25 s", "desc": "La escopeta dispara con más frecuencia."},
	{"id": "velocidad", "nombre": "Botas Timberland: velocidad +20%", "desc": "Amado camina más rápido."},
]

var opciones_actuales: Array[Dictionary] = []

func _ready() -> void:
	hide()

func abrir(permitir_recarga: bool = true) -> void:
	opciones_actuales.clear()
	for mejora in MEJORAS:
		if not permitir_recarga and mejora["id"] == "recarga":
			continue
		opciones_actuales.append(mejora.duplicate(true))
	opciones_actuales.shuffle()
	for i in range(3):
		var boton = get_node("VBoxContainer/Boton%d" % (i + 1))
		boton.visible = i < opciones_actuales.size()
		if not boton.visible:
			continue
		boton.get_node("HBoxContainer/VBoxContainer/Titulo").text = opciones_actuales[i]["nombre"]
		boton.get_node("HBoxContainer/VBoxContainer/Desc").text = opciones_actuales[i]["desc"]
	show()
	$VBoxContainer/Boton1.grab_focus()

func seleccionar_mejora(indice: int) -> bool:
	if not visible or indice < 0 or indice >= opciones_actuales.size():
		return false
	mejora_seleccionada.emit(opciones_actuales[indice]["id"])
	return true

func _on_boton_1_pressed() -> void:
	seleccionar_mejora(0)

func _on_boton_2_pressed() -> void:
	seleccionar_mejora(1)

func _on_boton_3_pressed() -> void:
	seleccionar_mejora(2)

func _on_button_pressed() -> void:
	deshacer_solicitado.emit()
