# Plan de commits de Carlos Valencia

**Preparado el 16 de septiembre de 2026.** Este plan descompone C01–C17 del [backlog](../TASK_BREAKDOWN.md). Es una secuencia de trabajo propuesta; un push no equivale a revisión, merge ni ticket terminado.

## Punto de partida y reglas

- Base de código: `origin/main` en `40827d8`, que contiene `AGENTS.md` y el prototipo Godot.
- Fuente de los blueprints: `origin/cmvalencia13` en `1fc90ae`. Sus documentos se incorporan a `docs/`; el Python, Word, diagrama y evidencia de Checkpoint 1 permanecen históricos en esa rama y no se editan aquí.
- Primer PR: `docs/blueprints-v2` hacia `main`. Carlos y Guillermo revisan arquitectura/adaptadores; Javier revisa los contratos algorítmicos. Los documentos quedan como propuesta hasta esa revisión.
- Después del PR documental, usar una rama `feature/CNN-descripcion` desde `main` actualizado por ticket. Si un ticket debe empezar antes de un merge, declarar explícitamente la base del PR y rebasar solo la rama propia, sin reescribir `main` ni `cmvalencia13`.
- Cada commit incluye su prueba y una nota de interfaz si cambia el contrato. Hacer push de la rama del ticket; Roberto integra tras revisión y smoke. Mantener como máximo dos tickets propios en progreso.
- Usar títulos de commit cortos en español. No versionar `.godot/`, builds, perfiles ni archivos temporales; respetar el `.gitignore` de `main`.
- No cambiar escenas, Player, enemigos, algoritmos de Javier ni entregables académicos dentro de estos commits. Coordinar adaptadores y wiring con sus dueños.

## Secuencia propuesta

| Orden | Rama / ticket | Contenido de un commit revisable | Prueba y condición de integración |
|---:|---|---|---|
| 0 | `docs/blueprints-v2` / base y C01 propuesto | Mover los blueprints v2 y fixtures de `cmvalencia13` a `docs/`, publicar autoridad de estado e interfaces sin tocar CP1 | Enlaces/JSON válidos; Guillermo revisa Player/pausa y Javier APIs compartidas antes de dar C01 por aceptado |
| 1 | `feature/C02-run-state` | `scripts/core/` con ciclo, reloj y `run_id`; sin cambiar `project.godot` | FakeClock: iniciar, pausar, reanudar, reiniciar y una sola resolución terminal |
| 2 | `feature/C03-data-catalog` | Definiciones, validación e índice por ID en `scripts/data/` | Fixtures de 3 armas/3 pasivos, IDs duplicados y categorías inválidas; mensaje con archivo/campo/regla |
| 3 | `feature/C04-inventory` | Inventario con dos listas, transacciones, revisión y snapshots | 5+5, Escopeta L1, rechazo sin mutación, replace atómico; FakeCatalog; requiere C03 |
| 4 | `feature/C05-xp` | XP y elecciones ganadas en `scripts/systems/` | Casos 0, 6, 20, 23 y 1805 XP; negativo rechazado; requiere C02 |
| 5 | `feature/C06-level-up` | Ofertas y consumo único | Sin duplicados, 0–3 opciones, doble clic y oferta obsoleta; requiere C04/C05 |
| 6 | `feature/C07-stats` | Resolver puro de pasivos/armas | Recalcular dos veces da el mismo resultado; requiere C03/C04 |
| 7 | `feature/C08-undo` | Acoplar Stack de Javier al commit de build | Dos cambios/dos Undo, sin revertir HP/XP; requiere J05 y C04/C07 |
| 8 | `feature/C09-progression` | Cerrar pasivos, saturación y fallback | Tres pasivos integrados, 5+5 y MAX visible; requiere UI G07 |
| 9 | `feature/C10-profile` | Perfil JSON versionado con backup/recuperación | Principal válido, corrupto, backup y versión futura sin sobrescritura; requiere C03 |
| 10 | `feature/C11-mvp-integration` | Conectar catálogo y resumen al ciclo completo | Run terminable y búsqueda UI; depende de J10, R11, G10 y C09/C10 |
| 11 | `feature/C12-world-state` | Flags y zonas de la partida | Solo claves permitidas; reiniciar borra flags; requiere C11 |
| 12 | `feature/C13-missions` | Árbol y progreso/recompensa idempotentes | Raíz/padre únicos, evento duplicado sin premio doble; requiere contenido O12 |
| 13 | `feature/C14-cp3-integration` | Conectar estado, misiones, grafo y UI | Una escena demuestra BFS, DFS, misión y diccionario; requiere J13/J14/G13/G14 |
| 14 | `feature/C15-lifecycle-metrics` | Medición con `run_id` y versión de balance | Un resumen por partida, muestras reproducibles; requiere C14 |
| 15 | `fix/C16-systems` | Bugs priorizados de los sistemas de Carlos | Prueba que reproduce cada bug y retest; depende de QA O15 |
| 16 | `docs/C17-defense` | Trazabilidad, demo y explicación técnica final | SHA de build/evidencia coinciden; revisión de contratos y demo de 3 minutos |

Cuando una fila exceda cuatro horas, dividirla en commits de implementación y prueba conservando la misma rama/ticket. Las dependencias de otros dueños se prueban con fixtures mientras llegan, pero la integración no se declara terminada hasta conectar el módulo real. Las fechas del curso y la versión exacta del editor siguen pendientes de comprobación según el plan maestro.
