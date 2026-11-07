# Desglose de tareas y reparto de carga

**85 tickets propuestos, sin crear issues remotos.** Identificadores C/G/R/J/O corresponden a personas, no a cuentas de GitHub. Cada fila es una pieza de 2–4 h; si excede4 h se divide. Todos están inicialmente en BACKLOG: ninguna fila afirma código implementado.

Las estimaciones incluyen implementación, documentación breve y prueba propia; las10 h adicionales de revisión/integración y 10 h de contingencia por persona están fuera de estas60 h. La revisión cruzada no se cuenta dos veces como implementación del autor.

F0=baseline (16–20 sep), F1=CP2 (21 sep–4 oct), F2=MVP/búsqueda (5–25 oct), F3=CP3 (26 oct–15 nov), F4=final (16–29 nov). Prioridad predeterminada: F0 P0; F1/F3 P1; F2/F4 P2. Un bug bloqueante siempre pasa a P0. Las fechas de entrega del curso se corroboran según PLAN_MAESTRO.

**Dependencias indican integración final**, no prohibición de comenzar diseño o implementar con dobles. Una aceptación que requiere otro módulo solo se declara terminada cuando ese módulo está integrado. La capacidad de cada fase incluye2 h/persona de review y 2 h/persona de reserva.

## Carlos Valencia

Blueprint: [instrucciones individuales](roles/CARLOS_VALENCIA.md). Revisor: Javier Guzmán. Ámbito de archivos: `scripts/core/, scripts/data/, scripts/systems/`. Los archivos de gameplay ajenos se coordinan con su owner.

| ID | Fase | Horas | Trabajo | Dependencias | Aceptación verificable |
|---|---|---:|---|---|---|
| C01 | F0 | 2 | Arquitectura y contratos | — | Publicar interfaces y resolver fuentes de autoridad; Guillermo revisa adaptadores |
| C02 | F0 | 2 | RunState y composición | C01 | Probar start/pause/resume/restart con FakeClock; una sola transición terminal |
| C03 | F0 | 2 | Esquemas y catálogo mínimo | C01 | Validar IDs/categorías y cargar fixtures de 3 armas/3 pasivos; error legible |
| C04 | F1 | 4 | Inventario transaccional | C03 | Agregar/mejorar/reemplazar sin exceder 5+5; fallo conserva snapshot |
| C05 | F1 | 4 | XP con sobrantes | C02 | 20 XP desde L1 produce L3 XP0 y dos elecciones; tope20 probado |
| C06 | F1 | 4 | Ofertas y consumo único | C04,C05 | Oferta sin duplicados; doble clic y stale_offer no duplican mejora |
| C07 | F1 | 4 | StatsResolver inicial | C03,C04 | Botas/Chaleco/Rancheras derivan stats desde base sin acumular dos veces |
| C08 | F1 | 4 | Integrar Undo académico | C04,C07,J05 | Dos cambios y dos Undo restauran build/stats; HP/XP no retroceden |
| C09 | F2 | 4 | Cerrar progresión y pasivos | C06,C07,G07 | Tres pasivos funcionan; inventario saturado tiene fallback y MAX visible |
| C10 | F2 | 4 | Perfil y recuperación local | C03 | JSON válido, corrupto, backup y versión futura probados sin perder original |
| C11 | F2 | 4 | Integración MVP y catálogo | C09,C10,J10,R11,G10 | Run completa con resumen; UI de catálogo compara búsqueda lineal/binaria |
| C12 | F3 | 4 | WorldState tipado | C11 | Cambian flags y zonas sin duplicar nivel/HP; reset borra run anterior |
| C13 | F3 | 4 | Árbol de misiones | C12,O12 | Un padre/raíz; condición activa hijos y recompensa una vez |
| C14 | F3 | 4 | Integrar CP3 | C13,J13,J14,G13,G14 | Misma escena demuestra ruta, validación, misión y estado sin scripts externos |
| C15 | F4 | 4 | Instrumentación de ciclo | C14 | Mide frame/XP/inventario con run_id y balance_version; sin doble resumen |
| C16 | F4 | 3 | Correcciones de sistemas | C15,O15 | Cerrar bugs de XP/estado/guardado priorizados o registrar cero pendientes críticos |
| C17 | F4 | 3 | Defensa y revisión final | C16,O16 | Explicar arquitectura/datos con demo breve y revisar contrato final |

## Guillermo Córdova

Blueprint: [instrucciones individuales](roles/GUILLERMO_CORDOVA.md). Revisor: René Serrano. Ámbito de archivos: `escenas existentes, scripts/combat/, scripts/ui/, scenes/`. Los archivos de gameplay ajenos se coordinan con su owner.

| ID | Fase | Horas | Trabajo | Dependencias | Aceptación verificable |
|---|---|---:|---|---|---|
| G01 | F0 | 2 | Registrar baseline y editor | — | Abrir mundo, grabar60 s y registrar versión exacta; F5 configurado |
| G02 | F0 | 2 | Inputs y colisiones | G01 | WASD/flechas, pausa y tabla de máscaras comprobados con cada contacto |
| G03 | F0 | 2 | Adaptadores Player | G01,C01 | recibir_dano/ganar_xp tienen punto de delegación sin reescribir animación |
| G04 | F1 | 4 | Salud y muerte única | G03,C02 | HP0 emite una muerte y detiene daño; i-frames y heal con límites |
| G05 | F1 | 4 | HUD desacoplado | G03,C05 | Barra/nivel/HP reaccionan a snapshots; no buscan ruta desde Player |
| G06 | F1 | 4 | Ejecutor visual Taser | J06,R06 | Cadena aplica daño real y dibuja impactos sin repetir objetivo |
| G07 | F1 | 4 | UI de mejoras | G05,C06 | Selecciona una opción, funciona pausada, maneja1–3 candidatos/fallback |
| G08 | F1 | 4 | Pausa y cierre de slice | G04,G06,G07,R08 | Pausar congela mundo; morir/reiniciar no duplica señales; debug CP2 termina |
| G09 | F2 | 4 | Machete y sincronización de armas | G08,C07 | Área golpea una vez por objetivo/ataque; cambiar build no duplica ejecutores |
| G10 | F2 | 4 | Menú y resumen | G08,C10 | Jugar/opciones/resultado/reintentar accesibles;3 reinicios sin estado viejo |
| G11 | F2 | 4 | Visuales de jefes y Regia | R10,R11,G09 | Telegraphs/barras legibles; Regia cura por contacto; MVP presentable |
| G12 | F3 | 4 | Arena con seis zonas | G11,O12 | Una escena con pasos físicos que coinciden con MapDefinition |
| G13 | F3 | 4 | Ruta BFS visible | G12,J13 | Ruta cambia al entrar zona/recoger objetivo; inaccesible se comunica |
| G14 | F3 | 4 | UI de misiones y estado | G12,C13 | Progreso/hijos/recompensa y flags visibles en juego y panel académico |
| G15 | F4 | 4 | Perfilado visual y rendimiento | G13,G14,O15 | Localizar coste de escenas/proyectiles y medir antes/después de un cambio |
| G16 | F4 | 3 | Export reproducible | G15,O16,C16,R16,J16 | Build en otra máquina abre y completa smoke; editor/templates documentados |
| G17 | F4 | 3 | Defensa de engine | G16 | Explicar árbol, colisiones y ciclo de frame con recorrido de 3 min |

## René Serrano

Blueprint: [instrucciones individuales](roles/RENE_SERRANO.md). Revisor: Guillermo Córdova. Ámbito de archivos: `scripts/waves/, Enemy/pickups y escenas de enemigos`. Los archivos de gameplay ajenos se coordinan con su owner.

| ID | Fase | Horas | Trabajo | Dependencias | Aceptación verificable |
|---|---|---:|---|---|---|
| R01 | F0 | 2 | Auditar ciclo Enemy y spawner | — | Documentar muerte/drop/contacto y transición del Timer a cola |
| R02 | F0 | 2 | Contrato WaveEvent y posiciones | R01,C01 | Fixture ordenado y reglas de cupo/posición revisadas con Javier |
| R03 | F0 | 2 | Escena de prueba de enemigos | R01,G01 | FakePlayer permite probar persecución/daño/drop sin resto de sistemas |
| R04 | F1 | 4 | EnemyBase y muerte idempotente | R03,C03 | Un enemigo recibe2 daños letales en frame y produce1 muerte/drop |
| R05 | F1 | 4 | WaveManager con FIFO | R02,J04,C02 | Despacha por tiempo/sequence, presupuesto5 y cupo50; Timer viejo desactivado |
| R06 | F1 | 4 | Registro y targeting | R04 | IDs únicos, consultas limpian muertos; Taser no retiene Nodes liberados |
| R07 | F1 | 4 | Monedas y XP única | R04,C05 | Drop1/5/20 y pickup consumido una vez; sin XP por muerte directa |
| R08 | F1 | 4 | Integración CP2 de oleadas | R05,R06,R07,J07 | Escenario real reproduce FIFO/pausa/reinicio y no tiene generador duplicado |
| R09 | F2 | 4 | Enemigo mediano y escalado | R08,O09 | Definición configurable reutiliza base; más HP/daño con mismos contratos |
| R10 | F2 | 4 | Mini jefe con aviso | R09 | A180 s aparece una vez; embestida visible; kill20 XP y flag; despawn no recompensa |
| R11 | F2 | 4 | CIO y fin de oleadas | R10,C02 | A300 s único, limpieza sin XP, fase2 y plazo90 s; spawn garantizado |
| R12 | F3 | 4 | Spawns sobre arena final | R11,G12 | Posiciones válidas en seis zonas; no aparece en paredes ni encima del jugador |
| R13 | F3 | 4 | Eventos de jefe y misiones | R11,C12,C13 | Muerte/despawn diferencian flags; evento duplicado no duplica recompensa |
| R14 | F3 | 4 | Regresión CP3 de enemigos | R12,R13,J14 | Arena válida, BFS y combate coexisten; no fugas al reiniciar |
| R15 | F4 | 4 | Estrés de oleadas y registro | R14 | Probar50/100/200/500 en debug; medir atraso/limpieza sin prometer500 jugables |
| R16 | F4 | 3 | Correcciones de combate enemigo | R15,O15 | Resolver bugs priorizados con prueba y comparar medición |
| R17 | F4 | 3 | Defensa de oleadas y jefes | R16 | Mostrar FIFO vivo, ciclo único de muerte y reglas de bosses |

## Javier Guzmán

Blueprint: [instrucciones individuales](roles/JAVIER_GUZMAN.md). Revisor: Carlos Valencia; René revisa Queue. Ámbito de archivos: `scripts/algorithms/, tests/algorithms/, tests/performance/`. Los archivos de gameplay ajenos se coordinan con su owner.

| ID | Fase | Horas | Trabajo | Dependencias | Aceptación verificable |
|---|---|---:|---|---|---|
| J01 | F0 | 2 | Especificar Queue y Stack | C01 | APIs con vacío/tipos/complejidad y fixture mínimo acordados |
| J02 | F0 | 2 | Diseñar Taser recursivo | R02 | max_targets incluye primero; query/hit callbacks y casos base definidos |
| J03 | F0 | 2 | Preparar runner de pruebas | J01 | Una prueba exitosa y otra fallida generan salida/exit code reproducibles |
| J04 | F1 | 4 | Cola circular dinámica | J01,J03 | FIFO/vacío/wrap/growth verificados; O(1) amortizado documentado |
| J05 | F1 | 4 | Stack de snapshots | J01,J03 | LIFO y copia profunda; límite 64 y coste de overflow documentados |
| J06 | F1 | 4 | Taser puro e integración de daño | J02,R06 | 0/1/3/8 objetivos; visited por descarga; coste O(kN) y referencias válidas |
| J07 | F1 | 4 | Pruebas CP2 completas | J04,J05,J06 | Casos límites y secuencias reproducibles pasan en runner |
| J08 | F1 | 4 | Documentar y defender CP2 | J07,R08,C08,G06 | Pseudocódigo coincide con código; evidencia usa invocación real del juego |
| J09 | F2 | 4 | Dos algoritmos de ordenamiento | J08 | Insertion/merge coinciden en datos aleatorios/ordenados/repetidos; panel consume ranking |
| J10 | F2 | 4 | Búsqueda lineal y binaria | J09,C03 | Orden por ID, ausentes/extremos/empty devuelven mismo resultado |
| J11 | F2 | 4 | Harness de benchmarks | J09,J10,O11 | Seeds y n configurables; tiempos/operaciones sin incluir preparación ni logs |
| J12 | F3 | 4 | Modelo de grafo validado | J11,O12 | Adyacencia simétrica, IDs válidos; fixture desconectado rechazado |
| J13 | F3 | 4 | BFS para ruta en arena | J12 | Ruta mínima en saltos, origen=destino y unreachable probados |
| J14 | F3 | 4 | DFS y revisión del árbol | J12,C13 | Alcanzabilidad real y detección de ciclos/raíz del árbol verificadas |
| J15 | F4 | 4 | Experimentos finales de algoritmos | J13,J14,O15 | Resultados crudos y complejidad comparados; sin resultados inventados |
| J16 | F4 | 3 | Revisión técnica y casos límite | J15,O16 | Vacíos/reinicio/referencias/overflow sin fallos; corregir desviaciones |
| J17 | F4 | 3 | Defensa de estructuras | J16 | Explicar código, costes y tradeoffs sin depender de leer slides |

## Roberto Villacorta

Blueprint: [instrucciones individuales](roles/ROBERTO_VILLACORTA.md). Revisor: Owner técnico del sistema afectado. Ámbito de archivos: `docs/, data/ de contenido, fixtures y evidencias`. Los archivos de gameplay ajenos se coordinan con su owner.

| ID | Fase | Horas | Trabajo | Dependencias | Aceptación verificable |
|---|---|---:|---|---|---|
| O01 | F0 | 2 | Confirmar fuentes y calendario | — | Conseguir syllabus/rúbrica y horas por integrante; registrar pendientes si no llega |
| O02 | F0 | 2 | Biblia y backlog revisados | O01,C01 | Alcance/IDs/decisiones revisados; tareas con owner y aceptación |
| O03 | F0 | 2 | Matriz QA y baseline | O02,G01 | Reproducir60 s y registrar bugs con SHA/pasos/resultado |
| O04 | F1 | 4 | Datos para slice CP2 | O02,C03 | Tres armas/pasivos y oleada corta con valores completos y válidos |
| O05 | F1 | 4 | Casos límite CP2 | O03,J03 | Fixtures XP20, inventario5+5 y doble muerte preparados con expected |
| O06 | F1 | 4 | QA integrado CP2 | O04,O05,G08,C08,R08 | Probar loop/stack/queue/taser y registrar pass/fail/blocked por SHA |
| O07 | F1 | 4 | Evidencia y trazabilidad CP2 | O06,J08 | Video/pseudocódigo/tabla tienen enlaces y mismo commit; fallos visibles |
| O08 | F1 | 4 | Ensayo y paquete CP2 | O07 | Otro compañero repite demo; build/evidencia identificados y pendientes resueltos |
| O09 | F2 | 4 | Balance de 300 s y bosses | O08 | Definiciones regulares/boss/pasivos completas y validadas; protocolo de cinco playtests listo |
| O10 | F2 | 4 | QA del MVP | O09,C11,G11,R11 | Cinco playtests; victory/defeat/Regia/tres armas/pasivos y resets reproducidos |
| O11 | F2 | 4 | Datasets y protocolo métricas | O10 | n10/100/1000/10000 con seed; metadata hardware y medición definidas |
| O12 | F3 | 4 | Contenido de zonas y misiones | O11 | Seis zonas/aristas y árbol de un padre con recompensas y fixtures aprobados |
| O13 | F3 | 4 | QA integrado CP3 | O12,C14,R14 | BFS/DFS/tree/dictionary producen efectos reales; caso de mapa inválido |
| O14 | F3 | 4 | Evidencia y ensayo CP3 | O13 | Demo repetible y trazabilidad completa sin afirmar pruebas pendientes |
| O15 | F4 | 4 | Recoger métricas y balance final | O14,J11,R15 | Ejecutar harness y runs; reportar mediana/p95/operaciones con datos crudos |
| O16 | F4 | 3 | Regresión final independiente | O15,C15,G14 | Smoke y casos críticos en release candidate; bugs con prioridad/owner |
| O17 | F4 | 3 | Paquete y ensayo de entrega | O16,G16,C17,R17,J17 | Build final del mismo SHA tras correcciones; retest afectado/smoke, métricas/video y cinco guiones completos |

## Capacidad y ampliaciones

| Persona | F0 | F1 | F2 | F3 | F4 | Implementación | Review | Reserva | Total |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|

| Carlos Valencia | 6 | 20 | 12 | 12 | 10 | 60 | 10 | 10 | 80 |
| Guillermo Córdova | 6 | 20 | 12 | 12 | 10 | 60 | 10 | 10 | 80 |
| René Serrano | 6 | 20 | 12 | 12 | 10 | 60 | 10 | 10 | 80 |
| Javier Guzmán | 6 | 20 | 12 | 12 | 10 | 60 | 10 | 10 | 80 |
| Roberto Villacorta | 6 | 20 | 12 | 12 | 10 | 60 | 10 | 10 | 80 |

Total equipo:300 h de producción,50 h de review y 50 h de reserva =400 h. La igualdad numérica no garantiza dificultad idéntica: revisar capacidad semanal y reestimar con horas reales. Roberto no sustituye cinco autores; cada owner entrega su evidencia y él consolida.

Ampliaciones sin horas comprometidas: Garrafón, Caña Rica, Bufanda y Raptor. Solo convertirlas en tickets de 2–4 h tras MVP/CP3 verdes, nueva estimación y capacidad libre. Si no caben, mantener tres armas/tres pasivos. No sacrificar mediciones, pruebas o defensa por contenido extra.

## Registro semanal de capacidad

Cada persona registra horas disponibles, reales, restantes y bloqueos. Roberto actualiza esta tabla en la reunión; valores reales empiezan pendientes. Si una dependencia amenaza el freeze, implementar un adaptador pequeño o reasignar una pieza; no borrar la aceptación para marcar DONE.

El archivo [backlog.json](backlog.json) contiene las mismas85 tareas para preparar el tablero sin transcribir. No contiene assignees de cuentas sin verificar ni publica issues automáticamente.
