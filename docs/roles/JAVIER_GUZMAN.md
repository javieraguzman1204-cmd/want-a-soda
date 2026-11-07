# Blueprint de Javier Guzmán

**Rol: Algorithms & Gameplay Systems Lead.** Entregas estructuras entendibles, probadas y llamadas por el juego. La complejidad debe corresponder a la implementación completa, incluida búsqueda de candidatos, copias y preparación de datos.

## Propiedad

Queue, Stack, Taser recursivo, búsqueda lineal/binaria, insertion/merge sort, grafo, BFS y DFS; pruebas/contadores correspondientes. Carlos integra Stack y búsqueda; René integra Queue; Guillermo integra el Taser visual y ruta. Carlos implementa el árbol y tú revisas su estructura/recorrido para equilibrar trabajo.

Leer [blueprint de algoritmos](../ALGORITHMS_BLUEPRINT.md), [interfaces](../INTERFACES.md) y [métricas](../METRICS_PLAN.md). Evitar Nodes específicos en las estructuras; aceptar datos o callbacks y probarlos sin cargar la arena.

## Ruta

| Fase / tickets | Entrega |
|---|---|
| F0 J01–J03 ·6 h | Contratos, recursión diseñada y runner de pruebas |
| F1 J04–J08 ·20 h | Cola, pila, cadena, casos límites y evidencia CP2 |
| F2 J09–J11 ·12 h | Dos sorts, dos búsquedas y harness reproducible |
| F3 J12–J14 ·12 h | Grafo, BFS/DFS y revisión del árbol |
| F4 J15–J17 ·10 h | Medición, correcciones y defensa |

60 h de producción +10 review +10 reserva. No se exige que todos los algoritmos tengan escena propia: basta escena de prueba compartida y uso real desde producto.

## Decisiones que debes sostener

Queue circular: explicar head/count, wraparound, crecimiento y amortización. `pop_front` de Array no justifica dequeue O(1). Stack: distinguir push de referencia O(1) amortizado frente a capturar snapshot O(n). Si se descarta el snapshot más viejo con desplazamiento, documentar O(H).

Taser: remaining cuenta impactos totales, visited local, profundidad≤8. Consulta lineal de N candidatos por cada uno de k impactos implica O(kN). Capturar posición antes de liberar objetivo y acumular resultados sin concatenaciones repetidas.

Binaria: IDs ordenados con el mismo comparador usado en búsqueda. Verificar ausencia y extremos; ordenar fuera del tiempo medido de consulta. Sorts: mismo dataset y misma clave `(distance_squared,id)`; medir tiempo y operaciones por separado cuando instrumentar distorsione tiempos.

BFS: cola y parent, visita al encolar; ruta mínima en saltos. DFS: pila/visited y alcanzabilidad, sin prometer distancia mínima. Grafo y árbol no se confunden: árbol tiene un padre por nodo, raíz y ausencia de ciclos.

## Pruebas y entrega a consumidores

Por estructura entregar API, ejemplo mínimo, casos vacíos/límite, runner y tabla de complejidad. Después sentarte30 min con su consumidor y probar llamada real. Si tu algoritmo funciona aislado pero no se invoca en partida, marcar «pendiente de integración», no DONE del requisito.

Antes de benchmark usar tamaños pequeños con salida esperada; luego aleatorios reproducibles. Guardar seed y counts. No optimizar el Taser usando estructuras espaciales antes de medir; el límite 8 y 50 enemigos es suficiente como primera versión.

## Defensa

Preparar un dibujo de Queue, un antes/después de Stack y una cadena con tres objetivos. Después mostrar BFS sobre seis zonas, explicar el orden de visita y comparar con DFS. Usar tus resultados crudos para explicar tendencia y límites; distinguir medición de estimación de memoria.

No eres responsable de todos los bugs de combate que aparezcan mientras se usa un algoritmo. Reproducir con fixture ayuda a determinar si el fallo está en tu módulo o en el adaptador del consumidor.
