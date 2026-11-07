extends Node

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_actualizar_estado("EN JUEGO")

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	if event.keycode == KEY_P:
		var menu = get_tree().current_scene.get_node_or_null("MenuNivel")
		if menu != null and menu.visible:
			return
		get_tree().paused = not get_tree().paused
		_actualizar_estado("PAUSA" if get_tree().paused else "EN JUEGO")
	elif event.keycode == KEY_R:
		get_tree().paused = false
		get_tree().reload_current_scene()

func establecer_pausa_mejora(activa: bool) -> void:
	get_tree().paused = activa
	_actualizar_estado("MEJORA" if activa else "EN JUEGO")

func _actualizar_estado(estado: String) -> void:
	if get_tree().current_scene == null:
		return
	var texto = get_tree().current_scene.get_node_or_null("HUD/PanelCheckpoint/TextoEstado")
	if texto:
		texto.text = "Estado: %s | P pausa | R reinicia estructuras" % estado
