# Blueprint de Roberto Villacorta

**Rol: Product, QA, Game Data & Evidence Lead.** Tu resultado es que el equipo construya el alcance acordado, tenga datos coherentes y pueda demostrar con evidencia que funciona. No eres solo quien toma capturas al final.

## Propiedad

Biblia, backlog/calendario, valores de catálogos, árbol de contenido, casos QA, datasets, mediciones, regresión y paquete de evidencias. Puedes escribir fixtures y pequeños scripts de prueba sin asumir sistemas centrales. Carlos mantiene esquema/contratos; tú editas valores dentro de ellos y solicitas cambios estructurales con ejemplo.

Leer [biblia](../GAME_BIBLE.md), [balance](../BALANCE_DESIGN.md), [pruebas](../TEST_PLAN.md), [trazabilidad](../CHECKPOINT_TRACEABILITY.md) y [métricas](../METRICS_PLAN.md).

## Ruta

| Fase / tickets | Entrega |
|---|---|
| F0 O01–O03 ·6 h | Syllabus/disponibilidad, prioridades y reproducción baseline |
| F1 O04–O08 ·20 h | Datos mínimos, casos límite, QA, evidencia y ensayo CP2 |
| F2 O09–O11 ·12 h | Balance de 300 s, cinco playtests en QA y datasets |
| F3 O12–O14 ·12 h | Zonas/misiones, regresión y evidencia CP3 |
| F4 O15–O17 ·10 h | Experimentos, regresión final y paquete/ensayo |

60 h de producción +10 review +10 reserva. Cada owner entrega su pseudocódigo/pruebas; tú verificas completitud y coherencia. No transcribir85 tareas manualmente si se utiliza backlog.json para preparar el tablero.

## Trabajo con datos

Preparar filas completas de cada nivel de arma/pasivo. Validar IDs, unidades y rangos; separar «valor propuesto» de «valor probado». Para cambiar daño/cooldown crear PR de datos con hipótesis, seed de prueba y resultado observado. No cambiar scripts de combate para equilibrar un número.

Misiones: raíz única, condición y recompensa verificables; asignar parent_id. Zonas: pasos físicos que Guillermo implementará, aristas simétricas y un fixture desconectado para prueba. Los nombres visibles mantienen el tono del juego sin alterar IDs.

## Cómo reportar un bug

Registrar ID, prioridad, SHA/build/editor/SO, seed, pasos mínimos, esperado, observado, frecuencia, captura/video y owner probable. Si no puedes ejecutar por falta de módulo, estado BLOCKED; si no ejecutaste, NOT_RUN. Nunca convertir una revisión de código en PASS del juego.

Ejemplo: «QA-06: iniciar L1, conceder23 XP en fixture; esperado L3 XP3 y 2 elecciones; observado XP0; reproducible3/3». El owner de XP es Carlos. Tú retestas el commit de corrección y enlazas el resultado.

## Evidencia y métricas

Cada checkpoint tiene índice con SHA, fecha, editor, pasos y enlaces. Grabar demo de producto y demo académica identificando debug. Guardar salidas crudas y condiciones de benchmark; no llenar celdas con tiempos plausibles ni presentar memoria estimada como medida.

Playtest: cinco partidas por configuración principal. Registrar primera mejora, nivel a 1/3/5 min, arma/build, resultado y causa de muerte percibida. Si una prueba usa tiempo acelerado o XP artificial, etiquetarlo. Meta: reproducibilidad, no maquillar porcentaje de victoria.

## Coordinación y defensa

Revisar carga semanal por horas y bloqueos; levantar sobrecarga antes de freeze. Si hay riesgo, recortar ampliaciones y reasignar piezas. Congelar contenido en fechas internas y priorizar regressions.

Defensa: explicar una decisión de balance con datos antes/después, cómo detectaste un bug, cómo se reproduce, qué evidencia corresponde al SHA y qué límites tienen los experimentos. Ensayar abrir build en otra máquina y preparar copia local del video por si falla conexión.
