# Blueprint de Guillermo Córdova

**Rol: Godot, Gameplay & Engine Lead.** Tu resultado es un juego que se abre, responde y comunica sus reglas visualmente. Conservas movimiento, cámara, sprites y disparo del baseline. No eres dueño de todos los sistemas por conocer el motor.

## Tu territorio

Player, HealthComponent, WeaponController, bala/armas, UI, escenas de aplicación, project.godot, input, capas/máscaras y export. René controla escenas de enemigos/jefes y su conducta; tú les das integración visual y verificas contactos. Carlos controla XP/inventario/estado; consume sus snapshots sin duplicarlos.

Leer [baseline](../BASELINE_GODOT.md), [arquitectura](../PROJECT_ARCHITECTURE.md), [interfaces](../INTERFACES.md) y [biblia](../GAME_BIBLE.md). Firma los puntos del contrato que afectan `_physics_process`, pausa, salud y UI.

## Ruta y entregables

| Fase / tickets | Trabajo concreto | Entrega comprobable |
|---|---|---|
| F0 G01–G03 ·6 h | Editor/escena principal, controles/máscaras, adapters Player | Video baseline y escena reproducible en clon limpio |
| F1 G04–G08 ·20 h | Salud, HUD por señales, Taser visual, mejoras y pausa | CP2 jugable con menús que funcionan pausados |
| F2 G09–G11 ·12 h | Machete, menú/resumen, feedback de jefes/Regia | Tres armas y loop completo visible |
| F3 G12–G14 ·12 h | Arena seis zonas, flechas BFS, panel misiones | Grafo coincide con puertas/caminos y UI responde |
| F4 G15–G17 ·10 h | Perfilado visual, export y defensa | Build ejecutada en otra máquina |

60 h de producción +10 review +10 reserva. Cada fila agrupa tickets de 2–4 h; ver [backlog](../TASK_BREAKDOWN.md).

## Procedimiento técnico

1. Registrar versión exacta; el archivo dice4.7 pero no basta para fijar binario. Conservar configuración GL Compatibility hasta medir otra opción.
2. Seleccionar escena principal mediante editor y añadir acciones move_left/right/up/down, pause e interact_ui. Mantener comportamiento de flechas mientras agregas WASD.
3. Cambiar colisiones con prueba por pareja: bala/enemigo, pickup/jugador, enemigo/jugador, jugador/pared y ataque CIO/jugador.
4. Introducir HealthComponent con HP clamp, i-frames0.4 s y muerte única. Mantener `recibir_dano` como adapter hasta migrar consumidores.
5. Sustituir XP del Player por delegación; retirar las variables antiguas al mismo tiempo. HUD solo dibuja vistas.
6. WeaponController sincroniza ID/nivel de inventario; no reinstancia cinco armas en cada señal si solo cambió un nivel. Ataques se detienen fuera de RUNNING.
7. UI y GameManager procesan durante pausa; mundo/tiempo/proyectiles se congelan. No dejar un Timer de daño procesando mientras el usuario elige.

## Contrato de armas

Reciben stats resueltos, posición del jugador y consulta de enemigos. Escopeta selecciona objetivo válido, crea proyectil y aplica un solo impacto. Taser llama a `RecursiveTaser.chain`; tú dibujas segmentos, Javier decide recorrido. Machete Area2D almacena IDs golpeados durante activación y no daña repetidamente por quedarse dentro.

No modificar `WeaponDefinition` al mejorar; cambiar nivel de instancia y consultar fila. Si muere el objetivo de una bala, esta conserva dirección y expira; no intentar leer un Node liberado.

## Pruebas tuyas

Arranque/F5/F6, flechas/WASD, diagonal normalizada, contacto/máscaras, cámara, vida 0, pausa con proyectil en vuelo, elección múltiple, volver al menú desde mejora y tres reinicios. Probar HUD con distintas dimensiones de ventana y texto largo. En export comprobar que escenas/datos referenciados están incluidos.

Un PR de escena adjunta captura o video y pasos. No mover recursos por estilo mientras se implementa una mecánica. René revisa combate/contactos; Carlos revisa alteraciones de estado/XP.

## Demo y límites

Defender scene tree, diferencia Node/Resource, `_physics_process`, señales y máscara de colisión. Mostrar menú pausado que responde y mundo congelado. No necesitas explicar todos los algoritmos de Javier, pero sí el punto donde los invocas.

Si te faltan datos o APIs, usar FakeCatalog/FakeEnemy y avisar con el ticket. No implementar otra versión de inventario para desbloquear UI. Tu ruta crítica se resuelve con contratos, no absorbiendo C04–C08.
