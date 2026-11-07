# Propuesta INTERFACES v1.1 — para revisión de Carlos

**Estado: PROPUESTA. No edita [`../INTERFACES.md`](../INTERFACES.md) (contrato v1, dueño Carlos).** Redactada por Roberto con IA a partir de la [revisión previa a C02](../reviews/2026-09-16_revision_pre_C02.md). Cada punto se aprueba, rechaza o ajusta por separado; los aprobados se incorporan a INTERFACES v1.1 en un PR de Carlos y se registran en DESIGN_DECISIONS con nombre y fecha. Nada de esto está implementado.

Revisores sugeridos: Carlos (todos), Guillermo (P-1, P-6, P-7 por pausa/escena), Javier (P-8 por OpResult compartido).

## P-1 · Reloj controlable y cierre de frame (resuelve A-1)

Problema: FakeClock se exige en TASK_BREAKDOWN C02, CARLOS_COMMIT_PLAN e INTERFACES §Dobles, pero ninguna firma dice cómo entra el tiempo.

Propuesta:

```text
RunState (RefCounted, sin árbol de escena)
  advance(delta_s: float) -> void      # suma tiempo solo si lifecycle == RUNNING
  resolve_frame() -> OpResult           # aplica a lo sumo UNA transición terminal encolada
GameManager (Node, process_mode = ALWAYS)
  _process(delta): run_state.advance(delta); run_state.resolve_frame()
```

En pruebas no hay Node: se llama `advance` y `resolve_frame` a mano. "Una sola transición terminal por cierre de frame" queda definida como "por llamada a `resolve_frame`".

## P-2 · `start_run(config, seed)` y `run_id` (resuelve A-2, C-1)

Problema: `config` no está definido; `run_id` aparece como `int` en §Convenciones y como `String` en señales, `RunSummary` e `inventory.example.json`.

Propuesta:
- `run_id: String`, formato `"run-<seed>-<n>"` donde `n` es un contador por sesión. Los `int` monotónicos de §Convenciones son `enemy_instance_id` y `pickup_id`.
- `config: Dictionary = {wave_id: StringName, map_id: StringName, balance_version: String}`. Claves desconocidas → `INVALID_ARGUMENT`.
- `seed: int`; lo consume el RNG de partida y se guarda en `RunSummary`.

Cambio de texto en §Convenciones: "ID de ejecución en `int`" → "IDs de instancia (`enemy_instance_id`, `pickup_id`) en `int` monotónico por partida; `run_id` en `String`".

## P-3 · `restart_run()` (resuelve C-2)

Problema: TASK C02, CARLOS_COMMIT_PLAN y la guía exigen "reiniciar"; INTERFACES solo tiene `request_menu()` + `start_run()`.

Propuesta: `restart_run(seed: int = -1) -> OpResult` = `request_menu()` seguido de `start_run(config_anterior, seed)` (con `-1` genera seed nueva). Válido desde LEVEL_UP, PAUSED, VICTORY, DEFEAT y SUMMARY; desde MENU o BOOT → `INVALID_STATE`. Garantiza que el `run_id` anterior queda inactivo antes de crear el nuevo.

## P-4 · `queue_terminal(reason)` (resuelve A-3)

Propuesta de enum y prioridad (mayor gana si hay varias en el mismo frame):

| reason | result | prioridad |
|---|---|---:|
| `DEFEAT_PLAYER_DEAD` | defeat | 3 |
| `DEFEAT_BOSS_TIMEOUT` | defeat | 2 |
| `VICTORY_BOSS_DEAD` | victory | 1 |

Reglas: solo se acepta en RUNNING (en LEVEL_UP/PAUSED el mundo está congelado y no debería llegar; si llega → `INVALID_STATE`). Encolar dos veces la misma razón es idempotente (`OK`). Tras resolver, cualquier `queue_terminal` → `INVALID_STATE`. `resolve_frame` con terminal pendiente descarta aperturas de LEVEL_UP pendientes y emite `run_finished` una sola vez.

## P-5 · `get_run_view()` (resuelve A-4)

```text
RunView = {
  run_id: String, lifecycle: int, encounter: int,
  elapsed_s: float, survival_s: float, boss_elapsed_s: float,  # -1 si el CIO no ha aparecido
  result: StringName  # &"" mientras la partida está activa
}
```

Es una copia de lectura; modificarla no afecta al estado.

## P-6 · `encounter` y plazo del CIO (resuelve A-5)

Propuesta:
- `notify_boss_spawned(kind: StringName) -> OpResult` (`miniboss` → MINI_BOSS, `final_boss` → FINAL_BOSS; fija `boss_spawn_time`). Lo llama GameRun al recibir `boss_spawned`.
- `notify_boss_died(kind) -> OpResult`: `miniboss` → vuelve a NORMAL; `final_boss` → `queue_terminal(VICTORY_BOSS_DEAD)`.
- El plazo de 90 s lo evalúa `advance()`: si `encounter == FINAL_BOSS` y `boss_elapsed_s >= 90` → `queue_terminal(DEFEAT_BOSS_TIMEOUT)`. Coherente con la tabla de autoridad ("Reloj, lifecycle, encounter y resultado: GameManager").

## P-7 · Señales sin EventBus (resuelve A-6)

Problema: EventBus se propone como autoload; C02 no puede tocar `project.godot`.

Propuesta: `RunState` declara `run_state_changed(run_id, lifecycle)`, `encounter_changed(run_id, encounter)` y `run_finished(run_id, result, summary)` como señales propias. Cuando exista EventBus (ticket de Guillermo para autoloads), GameRun las reenvía; ningún consumidor se conecta directamente a `RunState`. Mismo criterio para `xp_changed`/`levels_gained` en XPSystem e `inventory_changed` en InventorySystem.

## P-8 · `OpResult` como clase (resuelve A-8)

Propuesta: `scripts/core/op_result.gd`, `class_name OpResult extends RefCounted` con `ok: bool`, `code: StringName`, `message: String`, `value: Variant` y constructores estáticos `OpResult.ok(value = null)` y `OpResult.fail(code, message)`. Lista de códigos sin cambios. Es el primer archivo de C02 porque todos los sistemas lo usan.

## P-9 · Arranque sin catálogo (resuelve A-7)

`RunState.new(catalog_ok: bool)`: `true` → arranca en MENU; `false` → se queda en BOOT y `start_run` devuelve `INVALID_STATE`. Así C02 se prueba sin C03.

## P-10 · Inventario y XP (resuelve A-9, A-10, A-12)

- `InventorySystem.new(catalog)` y `reset(run_id: String)`; `restore(snapshot)` rechaza `run_id` distinto con `INVALID_ARGUMENT`.
- `XPSystem.new()` y `reset(run_id: String)`; `add_xp(amount)` con `amount` no entero o negativo → `INVALID_ARGUMENT` sin mutar.
- `xp_required_for_level(n)` = XP para pasar de `n` a `n+1` = `5 + 10*(n-1)`; `xp_required_for_level(20)` = 0.

## P-11 · DataCatalog (resuelve C-3, A-11)

- `load_from_dict(data: Dictionary, source_name: String) -> OpResult` como núcleo; `load_and_validate()` en producción lee `.tres` y delega. Los fixtures JSON solo alimentan pruebas.
- `value` de un fallo: `Array[ValidationError]` con `{source: String, path: String, value: Variant, rule: String}`.
- Añadir `get_wave(id)`, `get_map(id)`, `get_missions()` a la tabla de API.
- Carga en un contenedor temporal; solo se sustituye el catálogo activo si no hay errores.

## Fuera de esta propuesta

Ticket nuevo para Guillermo (no es contrato): "AppRoot, autoloads EventBus/DataCatalog y `run/main_scene`", 2 h, dependencia de integración de C02/C03. Sin él, C02/C03 quedan "listos para integrar", no DONE.
