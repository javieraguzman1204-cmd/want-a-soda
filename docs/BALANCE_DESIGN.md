# Balance inicial y catálogo de contenido

**Dueño: Roberto.** Los números siguientes son hipótesis iniciales para playtesting; no son resultados medidos ni valores ya aplicados al prototipo. La autoridad final estará en Resources `.tres`, con versión de balance registrada.

## Curva de poder inicial

| Arma | Daño L1 | Cooldown s | Alcance px | Progresión propuesta L2/L3/L4/L5 |
|---|---:|---:|---:|---|
| Escopeta | 15 | 1.0 | 600 | daño 18 / cooldown0.85 / daño 24 / daño 30 |
| Taser | 10 | 2.0 | 260 | targets2 / targets3 / daño 15 / targets4 |
| Machete | 20 | 1.4 | 110 | daño 25 / alcance130 / cooldown1.1 / daño 35 |

Los cambios son acumulativos al diseñar tablas, pero cada fila de Resource almacena todos los valores finales. Taser L1 max_targets1; radio entre saltos usa range_px. Escopeta velocidad400 px/s y vida máxima de bala2 s; un disparo un impacto salvo nueva especificación de penetración. Machete golpea cada enemigo una vez por activación. Estos números requieren medir densidad y tiempo para matar, no solo DPS teórico.

| Pasivo | Efecto total L1/L2/L3/L4/L5 |
|---|---|
| Botas | speed +8% /16% /24% /32% /40% |
| Chaleco | armor +1 /2 /3 /4 /5; daño entrante positivo mínimo1 |
| Rancheras | attack_speed +10% /20% /30% /40% /50% |
| Bufanda FAS, ampliación | max_hp +10 /20 /30 /40 /50; no cura al equipar |
| Raptor, ampliación | pickup_radius +10% /20% /30% /40% /50% |

| Enemigo | HP | Contacto | Velocidad px/s | XP | Conducta |
|---|---:|---:|---:|---:|---|
| Básico | 15 | 2 | 150 | 1 | Chase, cooldown contacto1 s |
| Mediano | 50 | 6 | 110 | 5 | Chase, cooldown1 s |
| Mini jefe | 250 | 10 | 95 | 20 | Embestida con aviso0.8 s; cooldown ataque4 s |
| CIO | 700 | 12 | 80 | 0 | Ataque radial con aviso1 s, intervalo3 s; fase2 intervalo2 s |

Ataque radial: seis proyectiles de daño 8, velocidad180 px/s, duración3 s; una bala solo golpea una vez. Invulnerabilidad breve global del jugador de 0.4 s tras daño evita que veinte contactos se acumulen en un mismo instante. El cooldown individual del enemigo1 s se conserva. Estas defensas se prueban juntas, sin bloquear curación.

## Oleadas como eventos concretos

En runtime se expande una definición de balance a eventos con ID único y sequence estable, se valida y carga en FIFO. No usar Timer antiguo más esta programación.

| Intervalo activo | Eventos regulares | Total máximo programado |
|---|---|---:|
| 0–59 s | 2 básicos cada2 s; t=0,2,…,58 | 60 básicos |
| 60–119 s | 3 básicos cada2 s; 1 mediano cada10 s desde 60 | 90 básicos +6 medianos |
| 120–179 s | 4 básicos cada2 s; 2 medianos cada10 s desde 120 | 120 básicos +12 medianos |
| 180–239 s | 4 básicos cada2 s; 2 medianos cada8 s desde 180 | 120 básicos +16 medianos |
| 240–299 s | 5 básicos cada2 s; 3 medianos cada8 s desde 240 | 150 básicos +24 medianos |
| 180 s | mini jefe único, después de regulares con mismo tiempo | 1 |
| 300 s | CIO único; cancelar resto de pendientes y limpiar no-jefes | 1 |

Totales regulares programados:540 básicos y 58 medianos; XP potencial regular830, más20 del mini jefe. **No equivale a XP recogida**: hay cupo50, retrasos, muertes pendientes y pickups sin recoger. Es una primera hipótesis; si genera backlog permanente se reduce frecuencia o se aumenta capacidad de daño, no se sube cupo sin medir.

Con la fórmula oficial, XP acumulada para alcanzar nivel L es `5*(L-1)^2`: L5=80, L10=405, L14=845, L20=1805. Esta oleada permite como máximo aproximado nivel 14 si se recoge prácticamente todo, y no busca forzar nivel 20. La demostración del tope20 usa fixture debug, identificado como tal.

## Salud, pickups y dificultad

Regia Chola cura20 y aparece en tienda a 60 y 150 s, con IDs únicos. Al recoger al máximo de vida se consume con mensaje «Vida completa», sin ocupar slots; no multiplica curación por colisiones repetidas. La recompensa de misión puede producir otra Regia. No se requiere drop aleatorio de salud para cerrar MVP.

Spawn fuera del área visible más margen64 px, dentro de límites navegables y sin ocupar pared. La constante700 del prototipo es solo fallback inicial; probar distintos viewport. Si un enemigo no puede aparecer, evento espera y registra retraso. Los jefes usan punto de arena validado y anuncio.

## Protocolo de ajuste

Roberto registra seed, SHA, balance_version, duración, resultado, nivel al minuto1/3/5, daño recibido y motivo percibido de muerte. Hacer cinco runs por configuración y comparar cambiar **una familia** de valores por vez. Metas iniciales: primera elección20–45 s, mini jefe reconocible, CIO vencible en ≤90 s con varias builds, ninguna muerte sin señal visible.

Cambios de números pasan por revisión del consumidor; cambios de comportamiento van a ticket de gameplay. Guardar antes/después y explicación, sin declarar «equilibrado» a partir de una única victoria. Si el backlog de spawn crece >10 s sostenidos, tratarlo como alerta de balance y ejecución.
