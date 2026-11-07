# Trazabilidad de requisitos académicos

**Dueño: Carlos; evidencia: cada owner, consolidada por Roberto.** Requisitos/fechas provienen del plan v1; verificar contra syllabus/rúbrica original antes de afirmar cumplimiento oficial. Rutas de implementación de esta tabla son **previstas**. Estado inicial: PLANNED, salvo lista Python existente en rama documental; ninguna estructura futura está marcada como integrada.

| Requisito / hito | Uso de juego | Archivo previsto y API | Coste explicado | Owner / integración | Prueba / evidencia prevista |
|---|---|---|---|---|---|
| Listas / CP1→CP2 | Inventario5+5 | scripts/systems/inventory_system.gd: try_add/snapshot | Búsqueda/copia O(n), n≤10 | Carlos | QA08–14; CP1 Python y demo en Godot |
| Pila / CP2 | Undo build académico | scripts/algorithms/action_history_stack.gd: push/pop | Push amortO(1), snapshot O(n), overflow O(H) | Javier / Carlos | QA13–14; antes/después y LIFO |
| Cola / CP2 | Spawns programados | scripts/algorithms/spawn_queue.gd: enqueue/dequeue | Enqueue amortO(1), dequeue O(1) | Javier / René | QA15–17; FIFO programado vs real |
| Recursión / CP2 | Taser encadenado | scripts/algorithms/recursive_taser.gd: chain | O(kN) con consulta lineal; espacioO(k) | Javier / Guillermo | QA18; caso base, profundidad y video |
| Ordenamiento / F2 | Ranking táctico/targeting académico | scripts/algorithms/sorting.gd: insertion_sort/merge_sort | O(n²) vs O(n log n); contar copia | Javier / Guillermo | QA28; panel real y benchmark |
| Búsqueda / F2 | Catálogo consultable | scripts/algorithms/search.gd: linear_by_id/binary_by_id | O(m) vs O(log m); sort previo separado | Javier / Carlos | QA27; resultados iguales y mediciones |
| Grafo / CP3 | Seis zonas de Colonia | scripts/algorithms/map_graph.gd: load/neighbors | EspacioO(V+E) | Javier / Guillermo | Mapa físico↔aristas; QA29–31 |
| BFS / CP3 | Ruta mostrada hacia pickup/zona | scripts/algorithms/graph_search.gd: bfs_path | O(V+E), memoriaO(V) | Javier / Guillermo | QA29/31; ruta mínima en saltos |
| DFS / CP3 | Validación de alcance de arena | scripts/algorithms/graph_search.gd: dfs_reachable | O(V+E), memoriaO(V) | Javier / René | QA30; fixture aislado bloquea mapa |
| Árbol / CP3 | Misiones con padres e hijos | scripts/systems/mission_system.gd: consume_event | RecorridoO(T); índice promedioO(1) | Carlos / Roberto contenido | QA32–34; activar hijo y recompensa |
| Diccionario / CP3 | Flags y zonas visitadas | scripts/systems/world_state.gd: set_flag/visit_zone | PromedioO(1), peorO(n) genérico | Carlos | QA35; antes/después y reset |
| Experimentación / final | Comparación reproducible | tests/performance/ + docs/metrics/ | Tiempo/ops/memoria contextualizados | Javier / Roberto | Crudos, protocolo y reporte |
| Juego/código/defensa / final | Partida y explicación por 5 | Build + repositorio etiquetado | Tradeoffs explicados por dueño | Todos | QA40, demo y cinco guiones |

## Evidencia requerida por fila

Al implementar, añadir SHA, ruta real, nombre de función vigente, lugar exacto donde el juego la invoca, prueba ejecutada, resultado y enlace al archivo/video. Una captura de un script no acredita integración. No borrar la ruta prevista sin sustituirla por la real.

## Paquetes

- [Checkpoint 2](checkpoints/checkpoint2/README.md): pila, cola y recursión con loop jugable.
- [Checkpoint 3](checkpoints/checkpoint3/README.md): mapa/grafo, BFS, DFS, árbol y diccionario.
- [Final](checkpoints/final/README.md): build, pruebas, métricas y defensa.

El Checkpoint1 está entregado según documentos; su reproducción y respaldo en main es trabajo pendiente de F0. Python demuestra listas, pero no acredita aún InventorySystem en Godot. La atribución de notas/porcentajes no se replica como verificada sin syllabus.
