class_name AlgorithmsFixture
extends RefCounted

## Fixture mínimo acordado para pruebas de Queue y Stack (J01)
## Responsable: Javier Guzmán
## Propósito: Permitir pruebas de estructuras de datos antes de integración.

## Retorna un evento falso válido para ingresar en SpawnQueue
static func get_mock_wave_event() -> Dictionary:
	return {
		"time_s": 10.5,
		"sequence": 1,
		"enemy_id": "gordo_bolito",
		"quantity": 3
	}

## Retorna un snapshot falso de inventario para ingresar en ActionHistoryStack
static func get_mock_inventory_snapshot() -> Dictionary:
	return {
		"run_id": "run_12345",
		"weapons": [{"item_id": "shotgun", "level": 1}],
		"passives": []
	}
