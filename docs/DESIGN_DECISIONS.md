# Registro de decisiones de diseño

**Fecha: 16 sep 2026.** Estado inicial de todas las decisiones de diseño: **propuesta**, salvo OBS que significa observación de fuentes. Al acordarlas, registrar nombre, fecha y PR. No se atribuye aprobación a integrantes ausentes.

| ID | Decisión | Razón y cambio frente a v1 | Validación / responsable |
|---|---|---|---|
| DD-001 | Conservar Godot en main; incorporar referencias de cmvalencia13 selectivamente | Las ramas contienen entregables distintos | Guillermo + Carlos |
| DD-002 | Editor exacto pendiente; OBS: proyecto declara 4.7 y GL Compatibility | La etiqueta no prueba instalación ni autoriza downgrade | Guillermo: ejecutar/importar/exportar |
| DD-003 | Una arena, seis zonas lógicas | Permite grafo real sin cuatro mapas completos | Guillermo + Javier |
| DD-004 | Ataque automático | Ya existe TimerEscopeta y targeting | Guillermo |
| DD-005 | Nivel máximo 20; XP sobrante y múltiples subidas | Resuelve contradicción 20/25 y bug de XP | Carlos |
| DD-006 | 300 s de oleadas + hasta 90 s de jefe; mini jefe 180 s | Aparecer al minuto 5 requiere tiempo posterior | Roberto + René |
| DD-007 | Tres armas/tres pasivos comprometidos; cinco/cinco objetivo ampliado | Limita carga sin cambiar capacidad 5+5 | Equipo |
| DD-008 | Catálogos .tres; runtime en memoria; perfil JSON | Un juego local no necesita servidor SQL; cambios de balance editables | Carlos |
| DD-009 | Definición inmutable separada de nivel/HP mutable | Evita recursos compartidos que modifican todos los enemigos/armas | Carlos |
| DD-010 | Lifecycle separado de encounter | Pausa/level-up no deben olvidar si estaba activo un boss | Carlos + Guillermo |
| DD-011 | Cola FIFO ordenada por time_s y sequence; sin prioridad mutable | Priority del v1 contradice FIFO si reordena eventos vencidos | Javier + René |
| DD-012 | Undo solo en pausa académica, de cambios de build | Restaura inventario/estadísticas, no mundo, vida ni XP | Javier + Carlos |
| DD-013 | Drop XP garantizado; pickup otorga una sola vez | Reproducibilidad y correspondencia 1/5/20 del Word | Roberto + René |
| DD-014 | Ganar requiere matar CIO; muerte simultánea es derrota | Evita victory timer y carreras entre señales | Carlos + René |
| DD-015 | Árbol de misiones de un padre; perfil guarda historial | Un árbol no se convierte en grafo de requisitos múltiples | Carlos + Roberto |
| DD-016 | BFS para ruta mostrada, DFS para validar arena | Uso real de ambos algoritmos sin inventar varios mapas | Javier |
| DD-017 | Búsqueda binaria en catálogo, diccionario para lookup runtime | Comparación académica visible sin forzar cada consulta a usar binaria | Javier + Carlos |
| DD-018 | Ranking por distancia para panel táctico/debug y targeting con fallback | Integración comprobable; nearest lineal puede seguir en producción | Javier + Guillermo |
| DD-019 | GameManager y UI procesan durante pausa; mundo pausa | Evita menú que no responde o daño durante selección | Guillermo |
| DD-020 | 80 h por integrante incluyendo QA/revisión/reserva | Equidad por esfuerzo y resultado, pendiente disponibilidad | Roberto |
| DD-021 | Calendario/rúbrica del v1 pendientes de fuente primaria | Syllabus no localizado; no certificar semanas ni pesos | Roberto |
| DD-022 | README CP1 queda histórico y se acompaña de fe de erratas | No reescribir retroactivamente lo entregado | Roberto |

## Procedimiento para cambiar una decisión

Crear una entrada con problema concreto, alternativa, coste, contratos afectados, propuesta de prueba y dueño. Cambios de datos sin cambio de esquema los revisa el dueño del consumidor; cambios de API requieren revisión de Carlos y del consumidor. Registrar la decisión en Git y actualizar los tickets afectados antes de merge. No mantener dos reglas vigentes con nombres distintos.
