# Blueprints de Want a Soda Amado y peligroso

**Versión 2.0 · 16 de septiembre de 2026 · Propuesta de ejecución para cinco personas.**

Este paquete convierte el plan original y el avance real del repositorio en instrucciones de trabajo. Define qué construir, quién responde por cada sistema, qué datos intercambiar y cómo demostrar que funciona. Los diseños descritos son trabajo futuro; su presencia en estos documentos no implica que estén implementados.

## Ruta de lectura

1. Todos: [Plan maestro](PLAN_MAESTRO.md), [Biblia del juego](GAME_BIBLE.md) y [Acuerdo de trabajo](TEAM_WORKFLOW.md).
2. Programadores: [Arquitectura](PROJECT_ARCHITECTURE.md), [Contratos](INTERFACES.md), [Arquitectura de datos](DATA_ARCHITECTURE.md) y [Esquemas](DATA_SCHEMA.md).
3. Cada integrante: su blueprint y sus tickets en [Desglose de tareas](TASK_BREAKDOWN.md).
4. Antes de integrar: [Plan de pruebas](TEST_PLAN.md); antes de entregar: [Trazabilidad académica](CHECKPOINT_TRACEABILITY.md).

## Documentos del equipo

| Documento | Para qué sirve | Responsable de mantenerlo |
|---|---|---|
| [Plan maestro](PLAN_MAESTRO.md) | Alcance, calendario, reparto, hitos y orden de implementación | Carlos |
| [Biblia del juego](GAME_BIBLE.md) | Identidad, reglas, experiencia del jugador y contenido | Roberto |
| [Auditoría de fuentes](SOURCE_AUDIT.md) | Qué se leyó, qué existe y qué falta verificar | Roberto |
| [Baseline Godot](BASELINE_GODOT.md) | Punto de partida y migración sin perder el prototipo | Guillermo |
| [Arquitectura general](PROJECT_ARCHITECTURE.md) | Escenas, componentes, estados y dependencias | Carlos |
| [Interfaces](INTERFACES.md) | Métodos, señales, errores y orden de eventos | Carlos |
| [Arquitectura de datos](DATA_ARCHITECTURE.md) | Catálogos, estado, guardado y validación | Carlos |
| [Esquemas de datos](DATA_SCHEMA.md) | Campos, tipos, invariantes y relaciones | Carlos |
| [Decisiones de diseño](DESIGN_DECISIONS.md) | Diferencias con el plan anterior y decisiones pendientes | Carlos |
| [Sistemas académicos](ALGORITHMS_BLUEPRINT.md) | Pilas, colas, recursión, búsqueda, grafos y complejidad | Javier |
| [Balance inicial](BALANCE_DESIGN.md) | Valores de arranque y experimentos de jugabilidad | Roberto |
| [Desglose de tareas](TASK_BREAKDOWN.md) | Tickets estimados, dependencias y aceptación | Roberto |
| [Acuerdo de trabajo](TEAM_WORKFLOW.md) | Git, revisión, integración y uso de IA | Carlos |
| [Plan de pruebas](TEST_PLAN.md) | Casos verificables y criterios de salida | Roberto |
| [Trazabilidad](CHECKPOINT_TRACEABILITY.md) | Requisito → implementación prevista → evidencia | Carlos |
| [Métricas](METRICS_PLAN.md) | Experimentos reproducibles sin resultados inventados | Roberto |
| [Riesgos](RISK_REGISTER.md) | Señales de alerta y respuesta | Roberto |

## Blueprints individuales

- [Carlos Valencia — arquitectura, datos y progresión](roles/CARLOS_VALENCIA.md).
- [Guillermo Córdova — Godot, jugador y combate](roles/GUILLERMO_CORDOVA.md).
- [René Serrano — enemigos, oleadas y jefes](roles/RENE_SERRANO.md).
- [Javier Guzmán — estructuras de datos y algoritmos](roles/JAVIER_GUZMAN.md).
- [Roberto Villacorta — producto, balance, QA y evidencias](roles/ROBERTO_VILLACORTA.md).

## Qué está preparado y qué queda por validar

Preparado: documentos de planificación, contratos propuestos, ejemplos JSON y plantillas locales de issue/PR. No se modificó el gameplay ni se crearon publicaciones, issues o PR en GitHub.

El equipo debe registrar la versión exacta del editor que abre el proyecto, su disponibilidad semanal y la rúbrica/calendario oficial. El syllabus original no está en las dos ramas revisadas ni en la carpeta de trabajo; sus fechas y requisitos se toman del plan adjunto y siguen pendientes de corroboración. El paquete permite avanzar mientras se confirman, sin presentarlos como verificados.

Las instrucciones futuras de estos documentos describen el trabajo del equipo. No son evidencia de aprobación por los cinco integrantes ni autorización para ejecutar automáticamente comandos o publicar cambios.
