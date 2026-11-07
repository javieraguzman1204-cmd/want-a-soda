# Plan de experimentación y rendimiento

**Responsables: Javier diseña/instrumenta; Roberto ejecuta/consolida; cada owner optimiza su módulo.** No hay mediciones realizadas como parte de este paquete. Las metas son propuestas y deben fijarse con la máquina de referencia.

## Experimentos

| Experimento | Comparación | Tamaños | Verificar antes de medir |
|---|---|---|---|
| A Búsqueda | Lineal vs binaria | 10,100,1000,10000 | Mismo catálogo/consultas; aciertos y ausentes; sort previo excluido y reportado |
| B Ordenamiento | Insertion vs merge | 10,100,1000,10000 | Misma entrada aleatoria, ordenada, inversa, repetidos; salida correcta |
| C Eventos | Cola vs escanear todos los eventos por tick | 10,100,1000,10000 | Mismos timestamps/ticks/cantidad despachada y sin coste de instanciar escenas |
| D Grafos | BFS/DFS | V10/100/1000/10000; E≈2V | Componentes y objetivos conocidos; no atribuir equivalencia de rutas |
| E Diccionario | Lookup ID vs recorrido lineal | 10,100,1000,10000 | Claves iguales y misma mezcla hit/miss; opcional si calendario apretado |
| F Juego | Runtime con población controlada | 50,100,200,500 | Misma escena, build, seed y cámara;500 solo estrés |

Casos grandes de O(n²) pueden exceder tiempo disponible: establecer límite de ejecución, registrar TIMEOUT y tamaño; no borrar filas ni inventar extrapolación como medición. Para grafos grandes usar DFS iterativo; no depender de profundidad de recursión ilimitada.

## Protocolo

1. Registrar SHA, Godot exacto, OS, CPU/RAM/GPU, resolución, renderer, editor/export y modo debug/release.
2. Dataset generado con seed fija20260916; registrar seed, tamaño, distribución y versión del generador. Repetir con al menos tres seeds cuando sea viable.
3. Separar generación, copia, ordenamiento previo, carga de escenas y escritura de archivo del tramo cronometrado. Registrar costes excluidos en otra columna o experimento.
4. Hacer5 iteraciones de calentamiento y 30 medidas por algoritmo/tamaño/distribución. Operaciones rápidas se repiten en lote y se reporta tiempo por consulta, sin precisión falsa cuando el reloj no alcanza.
5. Medir tiempo con reloj monotónico del motor; contar comparaciones, enqueues, visitas o swaps con una definición por experimento. Si los contadores afectan tiempo, una pasada para operaciones y otra para tiempo.
6. Reportar mediana, p95 (nearest rank: elemento ceil(0.95*n) de datos ordenados) y mínimo/máximo. Mantener crudos, incluso outliers; explicar interrupciones.
7. Memoria: distinguir incremento observado con herramienta de perfilado de una **estimación teórica**. Informar método/unidad; no llamar «bytes reales» a una fórmula del número de elementos.
8. Repetir mismo protocolo tras una optimización y comprobar resultado correcto; no presentar mejora si cambió dataset o build sin indicarlo.

## Medición del juego

Después de 30 s de calentamiento, registrar120 s por escenario de población fija con tres repeticiones. Medir frame_ms, conteos activos, tiempo de spawner, atraso de eventos y crecimiento de memoria. Una run normal completa sirve de complemento porque la población varía. Registrar si vsync está activo.

Meta propuesta para la máquina del laboratorio:50 enemigos activos, p95 de frame≤33.3 ms, sin crecimiento sostenido tras tres reinicios. Aspiración60 FPS se evalúa aparte. No prometer500 enemigos a 60 FPS ni fijar un presupuesto para una máquina todavía no registrada.

La pausa se excluye del análisis de combate y se identifica en datos. Comparar tiempos con y sin captura de video; grabar puede alterar resultados. Reportar projectile_count para explicar por qué dos escenarios con el mismo número de enemigos difieren.

## Archivos a producir cuando se midan

`docs/metrics/raw_results.csv`, `summary_results.csv`, `performance_report.md`, `environment.md` y gráficas. No se crean resultados ficticios en este paquete.

Esquema de fila:

```text
experiment,algorithm,sha,godot_version,build_mode,hardware_id,seed,
n,edges,distribution,repetition,elapsed_us,operations,
memory_value,memory_unit,memory_method,status,notes
```

Reporte: pregunta, hipótesis, método, controles, tabla/gráfico, interpretación, relación con Big-O y limitaciones. Gráficos con unidades, leyenda y tamaños reales; eje logarítmico solo si está identificado. La diferencia entre O(n) y O(log n) se explica con tendencia y preparación, no solo con una barra favorable.
