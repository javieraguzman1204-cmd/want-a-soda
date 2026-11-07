# Plan maestro de ejecución para cinco integrantes

**Versión 2.0 · 16 de septiembre de 2026.** Construiremos un survival 2D de una sola arena, con identidad salvadoreña, combate automático y progresión por XP. El objetivo es una partida terminable, con estructuras de datos que tengan una función visible y defendible. Este plan desarrolla y corrige el v1 sin borrar el avance existente.

## Resultado y límites

La entrega base tendrá Amado, Colonia, Escopeta/Taser/Machete, Botas/Chaleco/Rancheras, Regia Chola, básico/mediano/mini jefe/CIO, inventario de hasta 5 armas y 5 pasivos, selección de mejoras, pausa, derrota, victoria y reinicio. La arena incorporará seis zonas conectadas para grafo/BFS/DFS y un árbol sencillo de misiones. El límite de slots es capacidad, no obligación de implementar diez equipables antes de CP2.

Se proponen 300 segundos de oleadas, mini jefe a los 180 s y aparición del CIO a los 300 s. El combate del CIO añade hasta 90 s activos; derrotarlo da victoria y agotar ese plazo da derrota. Las pausas y elecciones no consumen tiempo. Llegar a nivel 20 es un límite, no condición para ganar. Estas decisiones resuelven la incompatibilidad entre «partida de cinco minutos» y «jefe que aparece a los cinco minutos».

La versión objetivo amplía a cinco armas y cinco pasivos si la base supera QA. Los cuatro mapas completos, multijugador, backend, ranking en línea y evoluciones quedan fuera de la entrega comprometida. Recortar contenido opcional no elimina requisitos académicos.

## Reparto de responsabilidad

| Persona | Resultado por el que responde | Revisor habitual | Fuera de su implementación principal |
|---|---|---|---|
| Guillermo Córdova | Player, escenas, armas y UI funcionando en Godot | René | Oleadas, inventario y algoritmos puros |
| René Serrano | Enemigos, drops, oleadas y jefes integrados | Guillermo | Controller del jugador y XP |
| Javier Guzmán | Estructuras y algoritmos probados e invocados por el juego | Carlos; René para cola | Animaciones, escenas y datos de balance |
| Carlos Valencia | Arquitectura, contratos, inventario, XP, mejoras, estados y guardado | Javier | Rehacer Player o absorber bugs de todos |
| Roberto Villacorta | Biblia, catálogos de balance, QA, mediciones y evidencia reproducible | Responsable técnico del sistema | Arquitectura paralela o gameplay completo |

Carlos coordina el ensamblaje, pero cada dueño integra y corrige su módulo. Roberto recibe autoridad para priorizar bugs y mantener datos dentro del esquema acordado. Javier implementa la estructura Queue; René responde por su aplicación a oleadas. Javier implementa Stack; Carlos responde por su aplicación al inventario. Carlos implementa árbol/estado; Roberto diseña sus contenidos y Javier revisa sus recorridos.

## Equidad medible

El [backlog](TASK_BREAKDOWN.md) contiene **85 tickets de implementación/producción: 17 por persona y 60 horas estimadas por persona**. A cada una se le asignan además 10 h de revisión/integración cruzada y 10 h de contingencia: **80 h por persona, 400 h de equipo**. No se mide contribución por cantidad de commits ni líneas de código. QA, datos, documentación y defensa cuentan como entregables con aceptación.

Estas horas son una hipótesis inicial, no disponibilidad confirmada. La ventana previa a CP2 requiere aproximadamente 12 h por persona por semana; el resto permite menos carga. En la primera reunión se registrarán horas disponibles. Si alguien dispone de menos tiempo, se redistribuyen tickets y se recorta contenido; no se compensa cargándolo silenciosamente a Carlos.

Cada domingo Roberto compara horas reales/restantes. Una desviación >20%, un bloqueo >24 h o dos tareas críticas atrasadas activa redistribución. El dueño mantiene la responsabilidad; un colaborador puede ejecutar un ticket. No se permite a una persona llevar más de dos tickets en progreso.

## Calendario y salidas

Fechas académicas tomadas del plan v1; falta corroborarlas con el syllabus original. Las fechas internas son propuestas de este paquete.

| Fase | Ventana | Horas por persona: trabajo + revisión + reserva | Salida comprobable |
|---|---|---|---|
| F0 Base | 16–20 sep | 6 + 2 + 2 = 10 | Baseline registrado, contratos y datos acordados; cada módulo tiene prueba mínima aislada |
| F1 CP2 | 21 sep–4 oct | 20 + 2 + 2 = 24 | Loop corto terminable, stack sobre inventario real, cola visible, Taser recursivo; congelamiento 2 oct |
| Entrega CP2 | 5–9 oct | Usa cierre de F1/reserva | Demostración, trazabilidad y etiqueta sobre SHA probado |
| F2 MVP y búsqueda | 5–25 oct | 12 + 2 + 2 = 16 | MVP de 300 s + CIO, tres armas/pasivos, búsqueda y ordenamiento; 12–18 oct sin feature obligatoria |
| F3 CP3 | 26 oct–15 nov | 12 + 2 + 2 = 16 | Zonas/grafo, ruta BFS, validación DFS, misiones/árbol y diccionario; congelamiento 13 nov |
| Entrega CP3 | 16–20 nov | Usa cierre de F3/reserva | Recorrido reproducible de las cinco estructuras |
| F4 Final | 16–29 nov | 10 + 2 + 2 = 14 | Mediciones, correcciones, export y ensayo; freeze 27 nov |
| Final | 30 nov–4 dic | Entrega; reserva restante | Build probado en otra máquina, métricas y defensa de todos |

Si el profesor cambia una fecha, se conserva la secuencia de dependencias y se recalculan las ventanas. El calendario no presupone que el equipo ya esté en la semana de colas.

## Primeras 72 horas

1. Guillermo abre una copia limpia, registra editor, ejecuta `mundo.tscn` y graba el baseline. Configura F6/F5 de forma reproducible; no mueve todo el proyecto.
2. Carlos presenta contratos y esquemas de este paquete. Revisa con Guillermo la adaptación de `ganar_xp()`/`recibir_dano()`; registra decisiones aún no acordadas.
3. René documenta el ciclo del enemigo y define eventos de spawn. Prepara una escena de prueba que no depende del Player final.
4. Javier implementa contratos mínimos de Queue/Stack y sus casos vacíos, sin escena de combate.
5. Roberto obtiene syllabus/disponibilidad, prepara la matriz de pruebas y registra discrepancias. Revisa la biblia y convierte tickets locales en el tablero cuando el equipo lo acuerde.

En una reunión de 45 minutos se resuelven editor, alcance, calendario y APIs. Los prototipos pueden avanzar con dobles de prueba; la integración de una interfaz compartida requiere que sus dos consumidores la revisen.

## Orden de implementación y dependencias

1. Conservar SHA del baseline y confirmar editor/escena inicial.
2. Reunir referencias académicas selectivamente sin reemplazar Godot.
3. Acordar contratos, IDs, resultado de errores y esquema de datos.
4. Crear estado de partida y conexión de señales.
5. Adaptar salud/muerte del jugador y ciclo idempotente del enemigo.
6. Implementar Queue y SpawnService con datos de prueba.
7. Integrar WaveManager y desactivar el Timer antiguo.
8. Crear inventario y recomposición de efectos con dobles de armas.
9. Separar XP, conservar sobrantes y procesar subidas múltiples.
10. Integrar elecciones, UI, pausa y Stack/Undo académico.
11. Integrar Taser recursivo y prueba de daño real.
12. Cerrar CP2 con pruebas y evidencia del mismo SHA.
13. Completar Machete, pasivos, Regia y mini jefe/CIO.
14. Integrar catálogo consultable y ranking de enemigos; comparar algoritmos.
15. Instalar seis zonas conectadas, grafo y BFS/DFS.
16. Activar árbol de misiones y WorldState con guardado local.
17. Cerrar CP3 sin añadir mapas extra.
18. Medir, balancear, corregir y exportar.
19. Ensayar demo/defensa y etiquetar la entrega probada.

Ruta crítica CP2: C02/C03 → C04/C05/C06 → G05/G07; J04 → R05; J06 → G06; J05 → C08. Los IDs completos y dependencias están en el backlog. Ninguna integración debe esperar a que un compañero termine todo su subsistema: se usan contratos y fixtures desde F0.

## Criterios de salida

**CP2:** la misma partida demuestra movimiento, daño, drop, XP, selección, reinicio, LIFO, FIFO y casos base recursivos. Victoria provisional mediante final del escenario de prueba solo en debug, claramente identificada; no se presenta como CIO terminado.

**MVP:** recorrido normal completo de 300 s y CIO, tres armas y tres pasivos, curación, dos enemigos regulares, mini jefe, victoria/derrota. No requiere nivel 20 ni inventario lleno.

**CP3:** BFS produce una ruta que se muestra al jugador; DFS detecta zonas desconectadas en la validación; árbol habilita una misión/recompensa; diccionario cambia con eventos de juego y se consulta desde UI. No basta un script suelto.

**Final:** todo lo anterior pasa desde clon/build limpio, sin errores bloqueantes, con artefacto de entrega, métricas reales, archivos de evidencia y cinco explicaciones individuales ensayadas.

## Gestión de cambios

Un cambio de API actualiza primero INTERFACES y DATA_SCHEMA, identifica consumidores y añade migración. Una idea de producto entra al backlog con coste y criterio de aceptación. Si amenaza un checkpoint, pasa a opcional. Los conflictos de alcance se resuelven con Roberto y el dueño afectado; Carlos decide coherencia técnica, no todas las decisiones de contenido.
