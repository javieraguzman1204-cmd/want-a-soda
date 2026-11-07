# Auditoría de fuentes y estado del proyecto

Consulta realizada el 16 de septiembre de 2026. Repositorio privado: [RobertoJVE/want-a-soda](https://github.com/RobertoJVE/want-a-soda). El conector GitHub devolvió 404; se obtuvo acceso de lectura mediante la sesión local de GitHub CLI.

**Actualización al incorporar estos documentos:** `origin/main` avanzó a `40827d8` y ahora contiene `AGENTS.md` (añadido en `6022b1f`). La tabla siguiente conserva los SHA de la auditoría original; la frase sobre ausencia de `AGENTS.md` se refiere solo a esos SHA.

## Fuentes inspeccionadas

| Fuente | Referencia | Resultado |
|---|---|---|
| Rama main | `f963ed9d1cac782f8a6a4343e555d959e21895e5` | README, 5 scripts GDScript, 6 escenas, project.godot y configuración Git leídos |
| Rama cmvalencia13 | `008bbbfb27c9e438541d116f74fb9fc2c1aa2ba6` | Plan maestro, README, Word de Checkpoint 1, diagrama PNG, Python y evidencia leídos |
| Plan adjunto local | `PLAN_MAESTRO_WANT_A_SODA_EDA.md`, v1.0 | Texto idéntico al de cmvalencia13; 100 secciones más resumen |
| Checkpoint 1 local | `Avance1_Want a Soda/Checkpoint1 Want a Soda EstructuraDeDatos.docx` | Contenido textual extraído; archivo idéntico al remoto; diagrama inspeccionado |
| README/Python/evidencia locales | Carpeta `Avance1_Want a Soda` | Coinciden con la rama documental |
| Issue 1 | [filosofia codex cmv](https://github.com/RobertoJVE/want-a-soda/issues/1) | Cuerpo: «prompts de planifiacion.»; no aporta reglas técnicas adicionales |
| Syllabus original/rúbrica | No localizado | No verificado; el plan v1 es una fuente secundaria |
| Ejecución del juego | No realizada en esta revisión | La auditoría es estática; no se afirma que el build haya pasado QA |

En las ramas consultadas no hay AGENTS.md ni otra documentación de diseño. El ZIP local es una copia de entrega; no se toma como versión superior a los archivos descomprimidos que coinciden con GitHub. Los archivos de importación de imágenes y UID son metadatos del motor, no documentos de reglas de juego.

## Hallazgos que cambian la planificación

1. `main` tiene Godot y `cmvalencia13` tiene documentación/Python; no se debe sustituir una rama por otra. La incorporación de referencias será selectiva, con Python en `academic_reference/checkpoint1/` y el Word/diagrama en `docs/checkpoints/checkpoint1/`.
2. `project.godot` declara `config/features = ["4.7", "GL Compatibility"]`, pero no `run/main_scene`. Esto no demuestra qué binario usa el equipo ni compatibilidad con otra versión. Guillermo debe registrar versión/build y configurar la escena principal en el editor.
3. `subir_nivel()` pone XP a cero y `ganar_xp()` usa un único `if`: se pierde sobrante y no procesa subidas múltiples. Se debe restar cada umbral con un bucle.
4. La muerte del jugador solo imprime texto; no detiene el combate ni abre resumen. Hace falta cierre de partida.
5. El enemigo puede recibir varios daños antes de `queue_free()`; falta protección contra doble muerte y doble drop.
6. La moneda puede recibir más de una notificación antes de liberarse; se necesita una marca de consumida antes de otorgar XP.
7. Los drops actuales son de 1 XP con probabilidad 75%. El Checkpoint 1 asigna 1/5/20 XP por categoría; se propone drop garantizado para hacer el balance reproducible.
8. El generador usa un Timer cada 0.5 s sin límite de población: 600 spawns en 300 s si nada lo detiene. No hay oleadas temporales ni jefes.
9. Disparo cada 2 s, bala de 15 de daño y enemigo de 15 HP: es una base de prueba, no un balance final. El pseudocódigo usa otros números y combate por turnos; no debe portarse literalmente.
10. El README de Checkpoint 1 menciona `inventario_final_final.py`, pero `main.py` importa `inventario.py`. También afirma una discrepancia de Caña Rica que el Word actual ya no tiene: ambos la incluyen como arma.
11. `reemplazar_objeto()` elimina el objeto viejo antes de saber si cabe el nuevo, e ignora el resultado de `agregar_objeto()`. El inventario Godot debe validar y confirmar de forma atómica.
12. El diagrama usa nivel ≤25 y aumenta nivel por muerte; el texto del Word usa XP y nivel 20. La versión 2 adopta XP y máximo 20, pendiente de acuerdo de producto.

## Jerarquía documental propuesta

La rúbrica original confirmada determina requisitos académicos. Las decisiones acordadas en [DESIGN_DECISIONS](DESIGN_DECISIONS.md) determinan el diseño vigente; la biblia define reglas; los contratos/esquemas especifican integración. El código describe lo implementado, no convierte un bug en regla. Los documentos v1 y Checkpoint 1 se conservan como historia.

No se afirma que el profesor haya aprobado las recomendaciones nuevas. Fechas, ponderaciones y restricciones de IA mencionadas por el plan v1 deben cotejarse con el syllabus original.

## Referencias técnicas consultadas

- [Godot Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html): separación entre nodos de comportamiento y recursos de datos; recursos compartidos.
- [Godot Pause y process mode](https://docs.godotengine.org/en/stable/tutorials/scripting/pausing_games.html): mantener operativa la UI durante pausa.
- [Godot Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html): persistencia local con FileAccess/JSON.
- [Godot Array](https://docs.godotengine.org/en/stable/classes/class_array.html): operaciones de arrays, duplicación y coste de extracción por el frente.

Las páginas `stable` respaldan conceptos; las firmas concretas se verificarán contra el editor fijado por Guillermo antes de implementar.
