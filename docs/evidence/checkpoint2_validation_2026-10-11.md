# Evidencia de validación — Checkpoint 2 (Godot)

Fecha de ejecución: 11 de octubre de 2026, hora de El Salvador (~18:49).
Motor: Godot 4.7.2 stable, GL Compatibility.
Versión de gameplay probada: merge de `main` `2fbe39a164138776bd70f49586d13971a1f6ebe1` (incluye PR #19).
Proyecto: `mundo.tscn` como escena principal. No se usó Python.

## Comandos y resultados

Desde la raíz del proyecto:

```powershell
godot --headless --editor --path . --quit
godot --headless --path . --script tests/algorithms/test_runner.gd
godot --headless --path . --script tests/checkpoint2/test_runner_checkpoint2.gd
godot --headless --path . --script tests/checkpoint2/test_xp_menu.gd
godot --headless --path . --script tests/checkpoint2/test_wave_schedule.gd
```

La importación y los cuatro runners terminaron con código de salida **0**. Extractos de la consola de esta ejecución (se omitieron líneas intermedias):

```text
SpawnQueue / ActionHistoryStack:
  ✅ T01 Vacío inicial: dequeue=null
  ✅ T02 FIFO: dequeue devuelve A
  ✅ T02 FIFO: dequeue devuelve B
  ✅ T02 FIFO: dequeue devuelve C
  ✅ T06 LIFO: pop devuelve el 3 (último)
  ✅ T06 LIFO: pop devuelve el 2
  ✅ T06 LIFO: pop devuelve el 1 (primero)
  ✅ T08 Límite 64: no excede 64 snapshots
  Total: 25 pruebas | ✅ 25 pasaron | ❌ 0 fallaron

Integración:
  FIFO programado: W01 -> W02 -> W03 -> W04 -> W05
  FIFO ejecutado #1: W01 (spawn)
  FIFO ejecutado #2: W02 (spawn)
  FIFO ejecutado #3: W03 (warning_spawn)
  FIFO ejecutado #4: W04 (spawn)
  FIFO ejecutado #5: W05 (spawn)
  OK  genera cinco enemigos reales
  OK  dequeue vacío no falla
  OK  primer Undo restaura recarga
  OK  segundo Undo restaura daño
  OK  Undo vacío es seguro
  OK  caso 0 objetivos
  OK  caso 1 objetivo
  OK  caso 3 objetivos
  OK  caso 8 objetivos
  OK  ocho objetivos sin repeticiones
  OK  límite duro de 8
  Total: 22 | PASAN: 22 | FALLAN: 0

XP / menú:
  OK enemigo derrotado suelta exactamente una moneda
  OK pickup duplicado solo otorga 1 XP
  OK dos niveles crean dos elecciones
  OK menú visible y juego pausado
  OK primera oferta cambia el daño real
  OK segunda oferta cambia la recarga real
  OK primer Undo revierte solo la recarga
  OK segundo Undo restaura build inicial
  OK Undo no revierte XP o nivel
  OK índice inválido no aplica mejora
  Total: 29 | PASAN: 29 | FALLAN: 0

Programación de oleadas:
  PASS: no ejecuta antes de tiempo
  PASS: sin jugador conserva frente
  PASS: empate conserva secuencia
  PASS: salto de tiempo limita a cinco spawns
  PASS: evento parcial permanece con dos spawns
  PASS: cola vacía no genera
  PASS: cap 50 conserva el evento
  PASS: al liberar espacio reanuda FIFO
  PASS: pausa detiene el reloj de oleadas
  Total: 14 | PASAN: 14 | FALLAN: 0
```

Total: **90/90 assertions**. Los mensajes de Godot sobre `user://logs`, certificados raíz y guardar preferencias del editor provienen del entorno local de ejecución headless; los runners salieron con código 0 y no mostraron fallos de scripts.

## Evidencia visual de una partida

René capturó las cuatro imágenes siguientes en una misma sesión de la versión actual. La captura antigua `checkpoint2_gameplay.png` queda solo como antecedente y no se usa para probar el estado final.

| Archivo | Qué se ve |
|---|---|
| [FIFO, Taser y pausa](checkpoint2_fifo_taser_pause.png) | W01–W05 programados y ejecutados, cola vacía, Taser 3/3 con cadena visible y estado PAUSA. |
| [Menú por XP](checkpoint2_xp_upgrade_menu.png) | Nivel 2, menú de tres mejoras reales abierto y estado MEJORA; incluye botón de Undo. |
| [Mejora de daño](checkpoint2_damage_upgrade.png) | Daño 20 frente a 15 inicial, mensaje «daño +5» e historial con una entrada. |
| [Undo del daño](checkpoint2_damage_undo.png) | Daño restaurado a 15, mensaje «Undo LIFO» e historial vacío. |

Las capturas muestran una mejora y su Undo. La segunda mejora y el orden LIFO de dos cambios están verificados por el runner integrado y el runner de XP/menú, no por esta secuencia de imágenes. Los casos de cola/pila vacía, empate, límite de cinco y capacidad de 50 se demuestran en la consola de pruebas anterior.

## Equivalencias y límites

El profesor aprobó pila de Undo de build, cola FIFO de oleadas y Taser recursivo como sustituciones de las mecánicas Python originales. La prueba integrada demuestra efectos reales en el juego y los casos vacíos. No demuestra salas, turnos rotatorios ni inventario equipable; esas diferencias se declaran en el README.

## Validación posterior: profundidad recursiva

La primera ejecución de este documento corresponde al merge `2fbe39a` y conserva su total histórico de **90/90**. En la rama posterior `feature/checkpoint2-recursion-evidence`, basada en `main` `0f466c7`, se añadieron seis assertions sobre profundidad real, objetivo final, reinicio del análisis y motivo de corte. El runner integrado pasó de **22/22 a 28/28**; los otros tres conservaron 25/25, 29/29 y 14/14. Total nuevo: **96/96**. La importación y el smoke test de la escena terminaron con código de salida 0.

Extractos de la nueva consola:

```text
  OK  cero objetivos reporta profundidad cero
  OK  un salto marca al objetivo más profundo
  OK  tres saltos alcanzan profundidad tres
  OK  profundidad ocho señala el último objetivo
  OK  descarga nueva reinicia el análisis recursivo
  OK  corte por alcance conserva la profundidad real
Total: 28 | PASAN: 28 | FALLAN: 0
```

[Captura de profundidad 3 y objetivo final marcado](checkpoint2_recursion_depth.png): René comprobó visualmente el HUD «3/3 | prof. 3 | fin: limite» y el anillo amarillo sobre el último enemigo. Esta captura pertenece a la rama posterior, no a la ejecución original de 90 pruebas.
