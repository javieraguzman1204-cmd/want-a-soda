# Blueprint de Carlos Valencia

**Rol: Architecture, Data & Integration Lead.** Tu resultado es que el juego tenga reglas únicas, progresión correcta y módulos que se conecten sin duplicar estado. Este paquete ya deja redactada tu base documental; falta que el equipo la revise y que implementes los servicios por tickets.

## Lo que entregas

| Entregable | Documento o ruta prevista | Se acepta cuando |
|---|---|---|
| Arquitectura y composición | PROJECT_ARCHITECTURE, core/game_manager | Iniciar/reiniciar monta módulos sin estado anterior |
| Contratos | INTERFACES | Productor y consumidor prueban la misma firma |
| Datos y catálogo | DATA_ARCHITECTURE, DATA_SCHEMA, scripts/data | IDs/campos inválidos se detectan antes de jugar |
| Inventario | systems/inventory_system.gd | 5+5, upgrades, rechazo atómico y snapshots |
| XP | systems/xp_system.gd | Sobrante, subidas múltiples, tope20 y elecciones correctas |
| Selección | systems/level_up_system.gd | Oferta válida, consumo único y fallback |
| Efectos | systems/stats_resolver.gd | Recalcular no acumula buffs ni crea copias de armas |
| Estados y misiones | world_state.gd, mission_system.gd | Grafo/árbol/diccionario tienen efecto real |
| Perfil | systems/profile_store.gd | Guardado/recuperación y versiones probados |
| Integración y defensa | CHECKPOINT_TRACEABILITY + evidencias | Cada requisito tiene código, llamada y prueba |

Rutas relativas a `scripts/` donde corresponda. La biblia de producto la mantiene Roberto; tú mantienes su coherencia con datos/contratos, sin escribir cada pieza de arte o cada evidencia por él.

## Orden de trabajo

**F0 — C01–C03, 6 h:** revisar baseline con Guillermo; fijar GameManager/EventBus; construir catálogo mínimo y validación. No crear un backend. En la primera reunión confirmar lifecycle/encounter, quién escribe HP/XP, prefijos e IDs, y cómo se adaptan los métodos existentes.

**F1 — C04–C08, 20 h:** inventario → XP → selección → resolución de stats → Undo. Estos servicios se prueban primero con FakeCatalog y UI simple. Entregar PRs separados; Guillermo puede conectar UI mientras completas la siguiente pieza.

**F2 — C09–C11, 12 h:** cerrar pasivos y casos de saturación; implementar perfil local; integrar búsqueda de Javier y loop completo con CIO de René. No convertirte en autor de los jefes al integrar.

**F3 — C12–C14, 12 h:** WorldState, árbol de misiones con contenido de Roberto e integración con grafo/UI. La propiedad del recorrido BFS/DFS sigue siendo de Javier.

**F4 — C15–C17, 10 h:** instrumentar ciclo, corregir tus bugs y preparar defensa. Añadir 10 h totales de review/integración cruzada y 10 h de contingencia a lo largo del proyecto:80 h previstas.

## Especificación de inventario

Guardar `weapons` y `passives` como listas de `{item_id,level}`, no nombres visibles. Al reset construir shotgun L1 y generar revisión nueva dentro del run. `try_add` rechaza repetido; `try_upgrade` sube una entrada existente; el generador de ofertas elige cuál invocar.

```text
try_replace(old_id, new_id):
    validar IDs, categoría, estado y presencia
    candidate = copia(snapshot)
    quitar old_id de candidate
    insertar new_id L1 solo si respeta capacidad y unicidad
    validar candidate completo
    si inválido: retornar error sin tocar estado
    commit(candidate)
```

Reemplazo/soltar existen como herramienta académica, no como mecánica gratuita del jugador. No trasladar el bug de CP1 donde se elimina primero y luego falla la inserción. La lista debe seguir demostrando búsqueda/recorrido aunque el catálogo use diccionario.

## Especificación de XP

```text
add_xp(amount):
    validar entero amount >= 0 y run activo
    total_collected_xp += amount
    si level == 20: emitir vista MAX y retornar sin elecciones
    current_xp += amount
    gained = []
    mientras level < 20 y current_xp >= required(level):
        current_xp -= required(level)
        level += 1
        earned_choices += 1
        gained.append(level)
    si level == 20: current_xp = 0
    emitir vista final
    si gained no vacío: emitir levels_gained una sola vez con la lista
```

`required(1)=5`, `required(2)=15`. Casos que tú debes demostrar: amount0 no cambia nivel;6 XP deja L2 XP1;20 XP deja L3 XP0;23 XP deja L3 XP3;1805 XP desde inicio deja L20 y 19 elecciones; valor negativo rechaza. No procesar un level-up por cada frame ni borrar sobrante. XP visual se otorga solo en recolección.

## Selección de mejora

Elegibles: equipados por debajo de máximo, y objetos no equipados cuya categoría tenga espacio. Sin repetidos, sampling sin reemplazo con RNG de partida. Si hay1–2, mostrarlos; si0, heal/continue. La UI nunca construye efectos por su cuenta.

Cada oferta lleva offer_id, run_id y revisión del inventario. La operación de elegir valida los tres, aplica exactamente una mejora, consume una elección y emite la siguiente oferta o reanuda. Botón se deshabilita al enviar; aun así el servicio rechaza segunda confirmación. Si falló el commit, no consume elección ni empuja historial.

Los snapshots de pila restauran build y stats. Mantenerlos separados de perfil guardado y de estado completo de partida; Undo no reabre monedas ni mata/revive enemigos.

## State, guardado y árbol

GameManager decide pausa y resultado; los demás notifican hechos. Resolver eventos terminales del frame antes de abrir ofertas. La fase de jefe sigue activa al volver de pausa. Al reiniciar destruir GameRun y crear estado limpio; filtrar eventos de run antiguo.

WorldState almacena claves previstas, no copias de todos los servicios. MissionSystem valida árbol y deduplica eventos; si mini jefe murió antes de activar su misión, consultar flag al activarla. ProfileStore guarda solo primitivas, valida versión y usa backup. Especificación completa en [datos](../DATA_ARCHITECTURE.md).

## Qué coordinar y qué delegar al owner

- Con Guillermo: adapters del Player, UI pausada, health/stats y un único punto de conexión de escenas.
- Con René: muerte/drop único, tiempos de jefes, flags y cupo de spawn.
- Con Javier: API de snapshots, Queue genérica, búsquedas y contrato del grafo; revisar complejidad sin reescribir sus módulos.
- Con Roberto: datos válidos, cinco playtests, requisitos/rúbrica y cobertura de QA. Roberto mantiene el tablero y el informe, cada autor su evidencia.

No debes absorber animación, balance de cada arma, QA de todos ni implementar SQL por llamar «base de datos» al catálogo. Cuando una integración falla, identificar contrato y devolver corrección a su dueño. Solo cambiar código ajeno en PR coordinado.

## Puerta de revisión de tus PR

Invariantes verificadas, errores no mutan, snapshots no comparten estado, un evento por operación, UI actualizada por señales, reset independiente y complejidad explicable. Javier revisa algoritmos; Guillermo revisa cualquier interacción con escenas/pausa. Adjuntar el caso numérico de XP y el caso de inventario lleno.

## Guion de defensa

En3 minutos: mostrar diagrama de autoridades; recoger XP y elegir mejora; enseñar rechazo de sexto slot; hacer Undo académico y explicar qué restaura; abrir una entrada del diccionario y enseñar JSON de perfil. Explicar por qué no hay backend, por qué Resource no contiene current_level, cuánto cuesta copiar inventario y cómo impides doble evento.

## Primer ticket para trabajar con IA

```text
Ticket C04. Lee docs/INTERFACES.md y docs/DATA_SCHEMA.md y el inventario de CP1.
Implementa InventorySystem y pruebas con FakeCatalog. Solo scripts/systems/
inventory_system.gd y tests/systems/inventory. No cambies player ni escenas.
Dos arrays, IDs únicos, shotgun L1, límites5+5, replace atómico y snapshot aislado.
Devuelve OpResult; prueba rechazo sin mutación. Explica diferencia con CP1.
```

No iniciar C04 sin tener C03 mínimo. Copia la ruta real del archivo académico cuando se incorpore a main; no inventar que ya fue integrado.
