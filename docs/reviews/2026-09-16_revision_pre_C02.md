# Revisión técnica previa a C02 (16 sep 2026)

**Tipo: revisión de trabajo, solo lectura.** Producida con IA (Fable 5.1) a petición de Roberto siguiendo la guía de uso por etapas. No modifica código ni certifica que el juego funcione. Base auditada: `origin/main` en `2dcfc5b` (docs/ del PR #2) y código Godot idéntico en `RjVE`.

Cada hallazgo se etiqueta como **PROBLEMA** (algo incorrecto o incompleto hoy), **DECISIÓN PROPUESTA** (elección que alguien debe aprobar) o **NO EXISTE AÚN** (ruta/código previsto, no error).

## 0. Estado verificado

- `main` = `RjVE` + carpeta `docs/` (35 archivos). Fuera de `docs/` no difiere nada; el prototipo Godot es el mismo en ambas.
- `docs/` es idéntico en contenido a los `.md` planos de `cmvalencia13` (TEST_PLAN, BALANCE_DESIGN, backlog.json comparados). `cmvalencia13` conserva además el Python de CP1.
- NO EXISTE AÚN en `main`: `scripts/`, `tests/`, `data/`, `scenes/`, `academic_reference/`, `docs/checkpoints/checkpoint1/`, `.github/`, `addons/`.
- Entorno del revisor: sin binario de Godot en PATH y sin `.godot/` (el clon nunca se abrió en el editor).

## 1. Contradicciones entre documentos

| # | Contradicción | Etiqueta |
|---|---|---|
| C-1 | `run_id`: INTERFACES §Convenciones dice "ID de ejecución en `int` monotónico"; las señales, `RunSummary`, `InventoryState` e `inventory.example.json` (`"demo-001"`) lo usan como `String`. | PROBLEMA → DECISIÓN: `run_id: String`; los `int` son `enemy_instance_id`/`pickup_id`. |
| C-2 | API de C02: la guía de Fable pide `pause` y `restart`; INTERFACES define `request_pause()` y no tiene `restart` (solo `request_menu()` + `start_run()`); TASK_BREAKDOWN y CARLOS_COMMIT_PLAN exigen "reiniciar". | PROBLEMA → DECISIÓN: añadir `restart_run()`. |
| C-3 | Fuente del catálogo: DATA_ARCHITECTURE fija `.tres` como autoridad; TASK C03 y la guía piden "cargar fixtures" JSON y a la vez "no convertir fixtures en catálogo de producción". | DECISIÓN: `DataCatalog.load_from_dict(dict, source_name)` como núcleo; JSON en pruebas y `.tres` en producción alimentan el mismo método. |
| C-4 | `catalog.fixture.json` no tenía `enemies`, pero INTERFACES exige `get_enemy(id)`, `wave.fixture.json` referencia 4 enemigos y la validación #4 de DATA_ARCHITECTURE exige "enemigos conocidos". | PROBLEMA (corregido en este mismo cambio: se añadió `enemies` al fixture). |
| C-5 | PROJECT_ARCHITECTURE pone EventBus/DataCatalog como autoloads y GameManager en un `AppRoot`; C02/C03 prohíben tocar `project.godot` y escenas (de Guillermo). | PROBLEMA: C02/C03 se pueden probar aislados pero no integrar; no existe ticket G para AppRoot/autoloads/`main_scene`. |
| C-6 | TEST_PLAN dice del runner "no ejecutarlo como si existiera"; J03 lo crea; la guía exige "no marcar terminado sin ejecutar pruebas". | PROBLEMA: C02 depende de J03 o de un runner mínimo propio; TASK_BREAKDOWN no lista esa dependencia. |
| C-7 | Ownership de C02–C05: AGENTS.md, INTERFACES y CARLOS_COMMIT_PLAN los asignan a Carlos en ramas `feature/CNN-*`; la guía pone a Fable (dirigido por Roberto) a implementarlos. | PROBLEMA de proceso: dos actores posibles sobre el mismo ticket (RISK04/RISK05). |
| C-8 | Escopeta: BALANCE/catálogo cooldown L1 = 1.0 s; `TimerEscopeta` = 2.0 s. | Ya diagnosticado (SOURCE_AUDIT #9). |
| C-9 | AGENTS.md describe un árbol sin `docs/`, reparte trabajo entre Claude Code/Codex sin mencionar Fable. | PROBLEMA menor: desactualizado tras el PR #2. |
| C-10 | Rutas tratadas como destino inmediato: `academic_reference/checkpoint1/`, `docs/checkpoints/checkpoint1/`, `docs/references/`. | NO EXISTE AÚN. |

Verificado como consistente: la fórmula XP `5+10(n-1)` y sus casos (6→L2 XP1; 20→L3 XP0; 23→L3 XP3; 1805→L20 con 19 elecciones) coinciden en GAME_BIBLE, BALANCE_DESIGN, CARLOS_VALENCIA y TEST_PLAN. El código actual usa la misma fórmula pero pierde el sobrante (SOURCE_AUDIT #3).

## 2. APIs insuficientemente definidas (bloquean C02–C05)

| # | Hueco | Decisión propuesta |
|---|---|---|
| A-1 | Reloj/FakeClock: se nombra en 4 docs, no tiene interfaz. | `RunState` puro (RefCounted) con `advance(delta_s)` y `resolve_frame()`; `GameManager` (Node, `process_mode = ALWAYS`) llama `advance` solo en RUNNING. FakeClock = llamar `advance` a mano. |
| A-2 | `start_run(config, seed)`: `config` sin definir. | `{wave_id, map_id, balance_version}`; `seed: int`; `run_id` derivado. |
| A-3 | `queue_terminal(reason)`: sin enum ni prioridad. | `DEFEAT_PLAYER_DEAD > DEFEAT_BOSS_TIMEOUT > VICTORY`; una resolución por `resolve_frame()`; en estado terminal → `INVALID_STATE`. |
| A-4 | `get_run_view()`: dice "tiempo" sin campos. | `{run_id, lifecycle, encounter, elapsed_s, survival_s, boss_elapsed_s, result}`. |
| A-5 | `encounter`: quién lo cambia, si vuelve a NORMAL al morir el mini jefe, quién evalúa los 90 s del CIO. | `notify_boss_spawned(kind)` / `notify_boss_died(kind)`; MINI_BOSS→NORMAL al morir; el plazo lo evalúa `advance()`. |
| A-6 | Las 16 señales viven en un EventBus autoload que no existe y C02 no puede registrar. | C02 emite señales en su propio objeto; el bus las reenvía cuando exista. |
| A-7 | BOOT→MENU requiere "catálogo válido" → acopla C02 a C03. | `RunState.new(catalog_ok: bool)`. |
| A-8 | `OpResult` sin decidir si es Dictionary o clase; C02 fija precedente. | `scripts/core/op_result.gd` (RefCounted, `OpResult.ok(v)` / `OpResult.fail(code, msg)`). |
| A-9 | `InventorySystem.reset()` sin `run_id` pero `restore()` lo valida; inyección del catálogo. | `reset(run_id)`; constructor recibe catálogo (FakeCatalog en pruebas). |
| A-10 | `XPSystem.add_xp`: emisión, `amount` float, campos de `get_view()`. | Señales propias; no entero → `INVALID_ARGUMENT`; view = XPState + `next_required`. |
| A-11 | `DataCatalog`: `load_and_validate()` sin fuente; faltan `get_wave/get_map/get_missions`; error sin estructura. | Ver C-3; `ValidationError {source, path, value, rule}`; construir en temporal y hacer swap. |
| A-12 | `xp_required_for_level(level)`: "de n a n+1" vs "para alcanzar n". | Documentar: `xp_required_for_level(1) == 5` = coste L1→L2. |

Texto completo de las decisiones en [`../proposals/INTERFACES_v1.1_propuesta.md`](../proposals/INTERFACES_v1.1_propuesta.md).

## 3. Dependencias reales de C02–C05

Declaradas y correctas: C02←C01, C03←C01, C04←C03, C05←C02. No declaradas pero reales:

1. C01 no tiene aceptación registrada ("Guillermo revisa adaptadores"); DESIGN_DECISIONS sigue con 22 entradas en *propuesta*. El merge del PR #2 no lo cierra.
2. Cerrar A-1…A-8 en INTERFACES antes de escribir C02.
3. Runner + binario Godot (J03 o runner mínimo; versión exacta que fije G01).
4. `enemies` en el fixture (hecho en este cambio; falta escena real para tres de ellos).
5. C05 puede desacoplarse de C02 (XPSystem solo necesita `run_id: String`); C04 puede empezar con FakeCatalog.
6. Integración: G03/G04/G05 y un ticket G inexistente para AppRoot + autoloads + `main_scene`.
7. Humana: acuerdo Carlos↔Roberto sobre quién implementa C02–C05.

## 4. Archivos de `RjVE` que pueden romperse al integrar C02–C05

| Archivo | Qué choca | Dueño |
|---|---|---|
| `jugador(amado_neftali).gd` | Dueño actual de `vida`, `xp_actual`, `nivel_actual`; `subir_nivel()` pone XP a 0; `actualizar_hud_xp()` busca `HUD/BarraXP` por ruta; `recibir_dano` solo imprime al morir. `ganar_xp`/`recibir_dano` deben sobrevivir como adaptadores. | Guillermo |
| `jugador(amado_neftali).tscn` | `TimerEscopeta` 2.0 s vs catálogo 1.0 s. | Guillermo |
| `moneda_xp.gd` | Llama `body.ganar_xp(1)`; DD-013 pide 1/5/20 garantizados y consumo único. Señal conectada solo por código (sin doble conexión en el `.tscn`). | René |
| `enemigo(gordo_bolito).gd` | `recibir_dano(dano)`; drop 75 % aleatorio; sin guard de doble muerte. | René |
| `generador_enemigos.gd` + `mundo.tscn` | Timer 0.5 s sin cupo; enemigo precolocado; `mundo.tscn` pasaría a ser hijo de `GameRun`. | René / Guillermo |
| `hud.tscn` | Nodos accedidos por ruta desde Player. | Guillermo |
| `bala.gd` | `dano = 15` hardcodeado. Nuevo, verificar en editor: `_ready()` hace `await timer` y luego `queue_free()`; si la bala ya fue liberada por impacto cae sobre instancia liberada. P3. | Guillermo |
| `project.godot` | Autoloads y `main_scene` no existen; ningún ticket C puede tocarlo. | Guillermo |
| `AGENTS.md`, `README.md` | Desactualizados respecto a `docs/`. | Roberto |
| Archivos `.uid` | Scripts creados fuera del editor no tendrán `.uid` hasta importar el proyecto; TEAM_WORKFLOW pide versionarlos. | Quien implemente |

## 5. Riesgos y recomendaciones (ordenados)

1. **P0 — No hay forma de ejecutar pruebas en el entorno del revisor.** → Instalar el binario exacto que fije G01; runner mínimo `tests/run_tests.gd` (SceneTree, `godot --headless --path . --script tests/run_tests.gd`, sin addons); coordinar con Javier (J03).
2. **P0 — Doble autoría de C02–C05** (C-7). → Acuerdo escrito: Carlos implementa, o delega a Roberto+Fable con Carlos como revisor obligatorio.
3. **P1 — Contratos en "propuesta"** (C01 sin aceptación). → Aprobar INTERFACES v1.1 (Carlos + Guillermo) antes de C02.
4. **P1 — Sin ticket de integración** (C-5). → Crear `G0x AppRoot, autoloads y main_scene` (2 h, Guillermo).
5. **P1 — Fixture sin enemies** (C-4). → Corregido aquí; faltan escenas reales para medium/miniboss/CIO.
6. **P2 — `RjVE` atrasada respecto a `main`.** → Resuelto (fast-forward, solo `docs/`).
7. **P2 — Bugs del prototipo ya diagnosticados** (SOURCE_AUDIT #3–#8) no bloquean C02–C05 puros pero sí el CP2 integrado.
8. **P3 — `run_id` ambiguo** (C-1).
9. **P3 — AGENTS.md/README desactualizados.**
10. **P3 — `bala.gd` await tras free** (verificar).

## 6. Plan por commits pequeños

Prerrequisitos: riesgos 1–3 resueltos; rama `feature/C02-run-state` desde `main`. Cada commit lleva su prueba.

**Commit 0 (docs, Carlos):** INTERFACES v1.1 con A-1…A-8, C-1, C-2; entrada en DESIGN_DECISIONS con nombre/fecha.

**C02 — `feature/C02-run-state`**
1. `scripts/core/op_result.gd` + `tests/run_tests.gd` + `tests/systems/test_op_result.gd`.
2. `scripts/core/run_state.gd`: enums, `run_id`, `advance(delta)`, transiciones MENU→RUN_INIT→RUNNING→PAUSED↔RUNNING, `request_menu`; pruebas start/pause/resume/restart.
3. `queue_terminal` + `resolve_frame` + `run_finished`; muerte y XP mismo frame → una transición; muerte+CIO mismo frame → DEFEAT.
4. `encounter` + plazo 90 s del CIO.
5. `scripts/core/game_manager.gd` (Node delgado, sin autoload, sin tocar `project.godot`).

**C03 — `feature/C03-data-catalog`**
1. `scripts/data/*_definition.gd` construibles desde Dictionary.
2. Validador con `ValidationError`; pruebas: ID duplicado, categoría inválida, niveles vacíos, cooldown 0, HP 0, referencia desconocida, campo desconocido, NaN.
3. `data_catalog.gd`: `load_from_dict`, índices, `list_items_sorted()`, getters; carga fallida sin estado parcial.
4. Pruebas `get_enemy` y referencias de `wave.fixture.json`.

**C04 — `feature/C04-inventory`**: FakeCatalog + `reset(run_id)`/`try_add`/`try_upgrade`/`revision`; `try_replace` atómico + `snapshot`/`restore`; pruebas QA-08/09/12/14 + nota de diferencias con CP1.

**C05 — `feature/C05-xp`**: bucle de umbrales, tope 20, `earned_choices`, `get_view()`; pruebas 0/6/20/23/1805+100/negativo/float; señales propias.

Después: revisión cruzada (guía §8) antes de C06.

## 7. Cruce con SOURCE_AUDIT

- Ya diagnosticado: XP pierde sobrante (#3), muerte del jugador solo imprime (#4), doble muerte/drop (#5), doble notificación de moneda (#6), drop 75 % vs 1/5/20 (#7), spawner sin cupo (#8), cooldown/daño de prueba (#9), `reemplazar_objeto` no atómico en CP1 (#11), `main_scene` ausente (#2).
- Nuevo aquí: C-1, C-2, C-4, C-5, C-6, C-7, C-9; A-1…A-12; ausencia de Godot/runner en el entorno; `.uid` faltantes; `bala.gd` await tras free.

## 8. `RjVE` y `main`

`RjVE` era ancestro estricto de `main`; se adelantó por fast-forward (solo entró `docs/`). Las ramas de ticket deben salir de `main` actualizado según CARLOS_COMMIT_PLAN.
