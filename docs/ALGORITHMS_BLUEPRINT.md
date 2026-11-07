# Blueprint de estructuras de datos y algoritmos

**Dueño: Javier.** Cada estructura se implementa en GDScript y se invoca desde la partida. Una demo Python puede complementar evidencia, pero no sustituye la integración. El profesor debe confirmar qué algoritmos específicos y uso de librerías permite la rúbrica.

## Lista de inventario

Carlos implementa dos arrays de hasta cinco entradas; ID único y nivel por entrada. Buscar/capacidad/reemplazo validan antes de mutar. `n` es cantidad de equipados: búsqueda O(n), copia de snapshot O(n), memoria O(n). Aunque n≤10 en el producto, se explica la complejidad parametrizada. El inventario de CP1 queda como antecedente, con sus diferencias registradas.

## Cola de spawn

Javier implementa cola circular dinámica: buffer, head, count y crecimiento al duplicar capacidad. `enqueue` al final O(1) amortizado; `peek`/`dequeue` O(1); crecimiento O(n) ocasional; memoria O(capacidad). Limpiar devuelve referencias y resetea índices. No usar `Array.pop_front()` declarando O(1): desplaza elementos. [Referencia Array de Godot](https://docs.godotengine.org/en/stable/classes/class_array.html).

René ordena/valida una vez eventos por `(time_s,sequence)` al cargar. Un FIFO no es una priority queue. Dos eventos al mismo tiempo mantienen el orden de sequence. WaveManager solo inspecciona el frente cuando no tiene evento parcialmente despachado:

```text
si no existe evento_actual y frente.time_s <= reloj:
    evento_actual = dequeue()
    pendientes = evento_actual.quantity
mientras presupuesto_frame > 0 y pendientes > 0 y hay_cupo:
    resultado = try_spawn(evento_actual.enemy_id)
    si fallo_posicion: detener hasta próximo frame
    pendientes -= 1
    presupuesto_frame -= 1
si pendientes == 0: liberar evento_actual
```

Puede continuar con otro evento vencido en el mismo frame sin exceder presupuesto total5. Cada intento busca hasta 8 posiciones válidas fuera del área visible y dentro del mapa; si no encuentra pospone. Debug registra tiempo programado y real para medir atraso. En final_boss se cancelan pendientes regulares y se procesa CIO una sola vez mediante su evento dedicado. No saltarlo silenciosamente por cupo lleno.

Pruebas: vacía, 1, 5 FIFO, wraparound, crecimiento, empates, reloj que salta varios eventos, pause/restart, cupo lleno y boss único. René prueba estas condiciones en escena; Javier prueba el contenedor sin Godot visual.

## Pila de historial

Array con push_back/pop_back: push O(1) amortizado, pop O(1) para la referencia; capturar/restaurar estado cuesta O(n) por build. No llamar O(1) a todo Undo. Carlos registra snapshot previo de cada modificación confirmada. La pila no contiene escenas ni recursos mutables compartidos.

Uso real: pausa académica → panel build → aplicar dos mejoras de prueba → deshacer dos veces → observar regreso en orden inverso. Snapshot incluye run_id y arrays; no HP/XP. Cambios inválidos no crean entradas. Restaurar vuelve a calcular stats y armas, como define INTERFACES.

Límite inicial64 snapshots, más que las19 elecciones normales. Al superar64 en debug se elimina el más antiguo: coste O(H) en ese caso, documentado. No hacer afirmaciones de O(1) estricto con esta política. La memoria es O(H*n). Pila vacía deshabilita botón; nueva partida la vacía.

## Taser recursivo

`max_targets` cuenta impactos totales, **incluido el primero**; no mezclarlo con «saltos adicionales». `visited` es diccionario/conjunto de instance_id local a una descarga. Límite duro8 para impedir profundidad sin control.

```text
chain(id, remaining, visited):
    si remaining <= 0 o id inválido/muerto o id en visited: retornar []
    visited.agregar(id)
    aplicar_daño(id)
    next = vecino_válido_más_cercano_no_visitado(id, radio)
    retornar [id] + chain(next, remaining-1, visited)
```

La consulta conserva posición del impacto antes de que se destruya el enemigo. Empates se resuelven por instance_id. El registro excluye enemigos muertos y confirma validez inmediatamente antes de daño. El resultado contiene segmentos/IDs que el visual puede dibujar incluso si murió un objetivo.

Con N enemigos consultados linealmente y k impactos: **O(kN)** tiempo y O(k) pila/visited, sin contar construir el array por concatenaciones. Implementar acumulador para evitar coste O(k²) de copiar resultados en cada retorno. O(k) solo sería correcto si encontrar el próximo objetivo costara O(1), lo cual aquí no se promete. La recursión explica la propagación limitada; una alternativa iterativa sería viable y debe poder discutirse en defensa.

Pruebas: cero targets, ID inválido, uno, tres, N<k, enemigos equidistantes, ciclo espacial A-B-C, muerte durante descarga, fuera de radio. Aceptación visual: HP cambia y no se repite enemigo dentro de una descarga.

## Búsqueda y ordenamiento

Búsqueda lineal del inventario O(n). Catálogo completo ordenado por ID: búsqueda lineal O(m) vs binaria O(log m), memoria extra O(1) para versión iterativa. Preparar catálogo tiene coste de ordenamiento O(m log m), mostrado por separado. UI debug «Catálogo» consulta ambas y muestra que dan el mismo resultado; el servicio real usa el índice por ID del DataCatalog para lookup promedio O(1).

Ordenamiento: implementar insertion sort y merge sort sobre TargetView `(distance_squared, instance_id)`. Insertion: mejor O(n) ya ordenado, peor O(n²), extra O(1) si in-place; si API copia entrada añadir O(n) memoria. Merge: O(n log n), extra O(n). Documentar la variante implementada. La API devuelve copia; no ordenar el registro vivo de enemigos.

Integración: panel táctico/debug muestra los cinco primeros y modo académico permite a Escopeta elegir el primero de la lista ordenada. Modo normal puede conservar nearest lineal O(n). No ordenar cada frame para un único mínimo. Actualizar ranking a 5 Hz o al disparo; medir antes de aumentar frecuencia. Consistencia: nearest lineal y ranking devuelven mismo ID salvo empate, donde ambos usan el menor ID.

## Grafo, BFS y DFS

Lista de adyacencia `Dictionary[zone_id,Array[zone_id]]` de seis zonas reales. Aristas bidireccionales sin pesos; registrar cada dirección. Espacio O(V+E). No confundir ruta mínima por cantidad de aristas con ruta más corta en píxeles.

BFS usa SpawnQueue genérica o un Queue reutilizable que Javier extrae sin introducir dependencia de WaveEvent. API de Queue acepta Variant con consumidores que validan tipo. Marca visited al encolar; parent permite reconstruir ruta. Origen=destino devuelve [origen]; destino inaccesible devuelve []; desconocido devuelve error antes del recorrido. Tiempo O(V+E) y memoria adicional O(V), aparte del grafo.

DFS usa stack de IDs y visited; itera vecinos en orden definido. Se invoca al validar mapa y desde panel de exploración; detecta zonas obligatorias aisladas. O(V+E), espacio O(V) si evita apilar indefinidamente duplicados marcando al programar visita. No se utiliza DFS para prometer ruta mínima.

BFS muestra una flecha/polilínea hacia pickup especial o Salva Cola, recalculada al cambiar de zona/objetivo. DFS con fixture de una arista eliminada debe reportar zona inaccesible y bloquear mapa inválido. Ambos usan datos del mismo mapa visible.

## Árbol de misiones y diccionario

Carlos implementa nodos con un padre, raíz única, children y estado. Roberto diseña condiciones/recompensas; Javier revisa validación de ciclos y recorrido. Recorrer árbol O(T); lookup de misión por ID promedio O(1) con diccionario, peor O(T) en un modelo hash adverso. No llamar árbol a un grafo con varios padres.

WorldState almacena flags y zonas; acceso/actualización por clave promedio O(1), peor O(n) según colisiones/implementación, memoria O(n). La evidencia muestra clave, valor antes y después de matar mini jefe/visitar zona. No se necesita implementar una tabla hash propia salvo rúbrica expresa; documentar que se usa Dictionary de Godot.

## Evidencia por algoritmo

Entregar propósito, entrada/salida, pseudocódigo, caso normal/vacío/límite, prueba integrada, complejidad con variables, medición cuando corresponda y limitaciones. Cada implementación debe tener un archivo de pruebas ejecutable y una ruta de invocación desde el juego, ambos anotados en CHECKPOINT_TRACEABILITY.
