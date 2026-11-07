# Acuerdo de trabajo del equipo

Cada integrante responde por un subsistema y entrega pequeñas piezas integradas. Este acuerdo es una propuesta para adoptar en la primera reunión; no modifica permisos ni protecciones de GitHub por sí mismo.

## Git y documentación

`main` debe mantenerse ejecutable. Ramas de trabajo desde main, una por ticket o conjunto pequeño: `feature/C04-inventory`, `fix/R04-double-death`, `docs/blueprints-equipo`. El nombre no impone dueño de cuenta; usar el responsable del ticket.

La rama `cmvalencia13` contiene material académico y no comparte el contenido Godot de main. No fusionar resolviendo todos los archivos a favor de una sola rama. Incorporar selectivamente Word/diagrama a `docs/checkpoints/checkpoint1/`, Python a `academic_reference/checkpoint1/` y plan v1 a `docs/references/`. Actualizar el README para enlazar documentos vigentes e históricos. Antes, verificar que el historial no contenga cambios nuevos respecto a los SHA auditados.

Versionar `.gd`, `.tscn`, `.tres`, `.uid`, arte fuente y documentación. Ignorar `.godot/`, exportaciones temporales y perfiles `user://`. Los metadatos `.import` ya existentes se conservan hasta que Guillermo confirme política compatible con el editor. No mover assets y cambiar comportamiento en el mismo PR.

## Ciclo de un ticket

1. Roberto o el dueño lo prepara en READY: objetivo, archivos, dependencia, caso de aceptación y horas.
2. El dueño confirma contrato; si falta consumidor usa fixture y registra integración pendiente.
3. Trabaja en rama, ejecuta prueba de módulo y prueba mínima del juego.
4. Abre PR con cambio concreto, reproducción, evidencia y efectos sobre datos/contratos.
5. Un compañero revisa; corrección vuelve al dueño, no automáticamente a Carlos.
6. Merge después de aceptación y smoke. Roberto actualiza evidencia; Carlos audita contratos cuando cambien.

Tablero: BACKLOG, READY, IN_PROGRESS, REVIEW, BLOCKED, DONE. Máximo dos tickets en progreso por persona. Un ticket de >4 h se divide conservando su ID como padre. Las estimaciones de este paquete son punto de partida, no cuotas de productividad.

## Definition of Ready

Owner y reviewer nombrados; API o propuesta adjunta; dependencias conocidas; archivos permitidos; aceptación observable; fixture disponible si falta otro módulo. «Hacer enemigos» no es un ticket listo.

## Definition of Done

Cumple aceptación, pasa pruebas relevantes y smoke de integración, no añade errores de parser, tiene evidencia del mismo SHA, documentación de interfaz actualizada si cambia, revisión de otro integrante e integración en main. Un módulo aislado puede estar «listo para integrar», pero no DONE del sistema.

QA no queda únicamente en Roberto: cada owner ejecuta y adjunta pruebas propias. Roberto hace regresión independiente, balance y consolidación. Carlos revisa contratos compartidos, no todos los cambios cosméticos. Revisores de referencia: Guillermo↔René, Carlos↔Javier; Roberto solicita al owner técnico según el caso. Rotar un revisor secundario por checkpoint para compartir conocimiento.

## Ritmo

Actualización breve diaria en el tablero: terminado, siguiente, bloqueo. Dos ventanas de integración semanales de 30 min con los dueños afectados; reunión semanal de 20 min de prioridades. Estas actividades consumen las horas reservadas, no se suman sin registrarse.

Bloqueo >24 h: explicar API/recurso que falta y proponer fixture. Desviación >20%: dividir/reestimar y reasignar carga. No esperar dos semanas para subir una feature gigante. En freeze solo bugs, documentación y pruebas.

## IA y explicación técnica

Se usa para inspección, diseño, implementación acotada y revisión. Cada persona entiende y puede explicar el código que entrega. Las reglas académicas de uso se corroboran con el syllabus/profesor; no se usa el plan secundario para afirmar permiso durante evaluaciones.

Prompt de trabajo común:

```text
Lee docs/README.md, docs/INTERFACES.md, docs/DATA_SCHEMA.md y mi blueprint.
Ticket: [ID y objetivo]. Primero inspecciona archivos actuales.
Puedes editar: [rutas del owner]. Coordina cualquier cambio ajeno antes de hacerlo.
Mantén estas firmas: [contrato]. Usa este fixture: [entrada].
Aceptación: [casos]. No marques como ejecutado lo que solo revisaste.
Implementa una pieza, explica cambios y evidencia. Si cambia una interfaz,
actualiza documentación y consumidores de forma controlada.
```

## Entrega y conflictos

Etiqueta solo el SHA verificado: checkpoint-2, checkpoint-3 y final-v1.0 como nombres propuestos. Registrar editor, export target y evidencia. Un conflicto `.tscn` se resuelve con su owner en el editor y se prueba; no elegir automáticamente «ours/theirs». Las plantillas `.github/` están preparadas localmente, sin issues ni PR remotos creados por este paquete.
