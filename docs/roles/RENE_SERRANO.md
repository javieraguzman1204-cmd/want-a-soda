# Blueprint de René Serrano

**Rol: Enemy & Wave Systems / Gameplay Integration.** Respondes por lo que aparece en la colonia, amenaza a Amado y entrega pickups al morir. Tu subsistema debe funcionar con Player real o doble de prueba.

## Propiedad y contratos

EnemyBase, EnemyRegistry, EnemySpawner, WaveManager, drops/monedas, mediano, mini jefe y CIO. Javier entrega Queue como estructura; tú integras cuándo encolar/desencolar y qué hacer con cada evento. Guillermo conserva Player y ejecutores de armas. Carlos decide el resultado global de la partida.

Leer [contratos](../INTERFACES.md), [algoritmos](../ALGORITHMS_BLUEPRINT.md), [balance](../BALANCE_DESIGN.md) y [baseline](../BASELINE_GODOT.md). Define IDs runtime únicos y señales antes de añadir variantes de enemigo.

## Ruta

| Fase / tickets | Entrega |
|---|---|
| F0 R01–R03 ·6 h | Auditoría, WaveEvent y escena con FakePlayer |
| F1 R04–R08 ·20 h | Base idempotente, FIFO, registro, monedas y CP2 integrado |
| F2 R09–R11 ·12 h | Mediano, mini jefe y CIO con reglas de entrada/salida |
| F3 R12–R14 ·12 h | Spawns válidos en arena, eventos de misión y regresión |
| F4 R15–R17 ·10 h | Estrés, correcciones y defensa |

60 h de producción +10 review +10 reserva. Guillermo revisa escena/combate, Javier la cola, Carlos señales de terminal/estado.

## Diseño del ciclo enemigo

```text
definición válida → instanciar → asignar instance_id/run_id
→ registrar → perseguir/atacar → recibir daño
→ marcar muerto ANTES de notificar
→ retirar registro → emitir enemy_died con datos primitivos
→ crear pickup mediante consumidor único → liberar Node
```

`despawn` por limpieza usa una ruta distinta: no suma bajas, no dropea XP ni completa misión de matar. El sprite/flash actual se conserva. Confirmar `is_instance_valid(player)` al perseguir para no leer un jugador liberado.

## Oleadas

Preparar lista ordenada y cargar Queue. Tick recibe reloj de GameManager, no mantiene su propio cronómetro. Cupo inicial50 regulares; presupuesto5 spawns/frame; evento parcialmente atendido conserva cantidad restante. Probar retrasos si el cupo se llena. Posiciones fuera del viewport más64 px, dentro del mapa y fuera de pared; máximo8 intentos por solicitud y posponer al fallar.

Al habilitar WaveManager desactivar Timer0.5 s y quitar enemigo colocado de prueba. A180 s mini jefe único. A300 s cancelación explícita de pendientes regulares, limpieza administrativa de enemigos previos y CIO en punto validado; si falla spawn reportar error y reintentar, no consumir para siempre el único evento. GameManager inicia plazo90 s cuando confirma creación.

## Jefes

Mini jefe reutiliza daño/muerte/registro y agrega embestida con aviso. CIO reutiliza base y agrega fase por HP y ataque radial. `boss_died` acompaña `enemy_died`, pero solo un consumidor crea drop y solo GameManager decide victoria. Un evento repetido nunca crea segundo jefe ni segunda recompensa.

## Pickups

La muerte suelta XP garantizada por definición. La moneda marca consumida antes de llamar XPSystem y no depende de que queue_free ocurra inmediatamente. Regia cura20 vía HealthComponent y nunca se guarda en inventario. Prueba recoger con vida llena y con varias notificaciones del mismo frame.

## Pruebas y defensa

FIFO con 5 eventos, empate temporal, salto de reloj, pausa, cupo lleno, posición imposible, dos daños letales, moneda doble, mini/CIO una vez, fase2, muerte simultánea jugador/CIO y tres resets. Prueba50/100/200/500 enemigos solo para medición; no conviertas500 en requisito de jugabilidad.

En defensa mostrar frente de cola, hora programada/real, count activo y transición death/despawn. Explicar por qué el contenedor FIFO no decide prioridades y por qué el reloj tiene un solo dueño. Entregar video de 60–90 s que muestre el caso real dentro de la partida.
