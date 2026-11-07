# Plan de pruebas y aceptación

**Dueño: Roberto.** Cada owner prueba su módulo; Roberto ejecuta regresión independiente. Todos los casos siguientes comienzan **NOT_RUN**. Esta planificación no certifica ejecución del prototipo ni del juego futuro.

## Niveles de prueba

1. Algoritmo puro con fixtures deterministas: Javier; runner GDScript headless con exit code distinto de 0 al fallar.
2. Sistema con dobles: Carlos inventario/XP/estado, René spawn/enemy, Guillermo salud/UI.
3. Integración en escena: mismo contrato y datos que el juego, incluyendo pause/restart.
4. Partida/export: clon limpio, editor acordado y build en otra máquina; Roberto coordina.

Los comandos del runner se definirán cuando J03 cree el archivo real. Un comando futuro puede usar `godot --headless --path . --script tests/run_tests.gd`; no ejecutarlo como si ese archivo existiera hoy.

## Casos verificables

| ID | Given / acción | Resultado esperado | Dueño | Hito |
|---|---|---|---|---|
| QA-01 | Clon limpio, abrir/importar y ejecutar escena principal | Sin errores de parser; movimiento/disparo/moneda visibles | Guillermo | F0 |
| QA-02 | Cada pareja de capas definida en arquitectura | Solo contactos previstos; no daño propio ni pickup por enemigo | Guillermo | CP2 |
| QA-03 | Jugador HP2 recibe daño 2 y después otro golpe | HP0, una muerte, derrota, combate detenido | Guillermo/Carlos | CP2 |
| QA-04 | Vida90/100 recoge Regia20; repetir callback | HP100 y un consumo; vida llena también consume una vez | René | MVP |
| QA-05 | L1 XP0 recibe6 | L2 XP1, una elección | Carlos | CP2 |
| QA-06 | L1 XP0 recibe23 en un evento | L3 XP3, dos elecciones secuenciales sin reanudar entre ellas | Carlos | CP2 |
| QA-07 | L1 recibe1805 y luego100; otro caso amount negativo | L20,19 elecciones ganadas; siguiente XP no sube; negativo no muta | Carlos | CP2 |
| QA-08 | Cinco armas equipadas; intentar sexta y agregar primer pasivo | Sexta rechazada, pasivo válido, estado ≤5+5 | Carlos | CP2 |
| QA-09 | ID equipado aparece como candidato | Mejora el mismo slot; no crea entrada duplicada | Carlos | CP2 |
| QA-10 | Catálogo fixture con seis armas; todas las adquiribles/maximizadas sin candidato | Heal20 o Continue si HP lleno; no softlock | Carlos/Guillermo | CP2 |
| QA-11 | Doble clic en offer_id; otra oferta con revisión vieja | Solo una elección consumida; stale rechazada y regenerada | Carlos | CP2 |
| QA-12 | Reemplazar pasivo por arma con cinco armas ya presentes | Fallo atómico; objeto viejo permanece; no nueva entrada de historial | Carlos | CP2 |
| QA-13 | Aplicar dos cambios A/B en debug y deshacer dos veces | B→A→original; stats/armas coherentes, XP/HP no se restauran | Javier/Carlos | CP2 |
| QA-14 | Modificar diccionario devuelto por snapshot | Estado real no cambia; pila vacía no rompe | Carlos/Javier | CP2 |
| QA-15 | Cola A/B/C, wraparound y crecimiento | Salida A/B/C; peek no consume; empty devuelve null | Javier | CP2 |
| QA-16 | Eventos empatados, salto de reloj y cupo lleno | FIFO estable, ≤5 spawns/frame, cantidad restante preservada | René | CP2 |
| QA-17 | Pause durante oleada y durante CIO | Tiempo/movimiento/daño congelados; UI operativa; encounter conservado | Guillermo/Carlos | CP2/MVP |
| QA-18 | Taser k=0/1/3/8 con pocos enemigos/ciclo espacial | Casos base, ≤k impactos, ningún ID repetido, daño real | Javier/Guillermo | CP2 |
| QA-19 | Dos ataques letales al enemigo antes de queue_free | Un drop y una baja; no referencias inválidas | René | CP2 |
| QA-20 | Moneda recibe dos body_entered antes de liberarse | XP otorgada exactamente una vez | René | CP2 |
| QA-21 | Reloj cruza180 y 300 s con queue saturada | Un mini jefe/un CIO; limpiar previos sin XP; CIO no queda perdido | René | MVP |
| QA-22 | Matar CIO con jugador vivo; otra run expira90 s | Victoria en primer caso, derrota en segundo | René/Carlos | MVP |
| QA-23 | Jugador/CIO mueren mismo frame; llega XP suficiente | Solo derrota y resumen; no abre mejoras luego | Carlos | MVP |
| QA-24 | Menú/restart tres veces, incluyendo desde LEVEL_UP | Sin enemigos/conexiones/colas/XP viejos; tree despausado | Todos | CP2/final |
| QA-25 | Recalcular mismas botas/Chaleco/Rancheras dos veces | Mismos stats; no multiplicación acumulada; daño 0 aplica0 | Carlos | MVP |
| QA-26 | Machete toca enemigo varios frames por activación | Un impacto por ID; siguiente activación puede golpear | Guillermo | MVP |
| QA-27 | Catálogo ordenado: empty, primero, último, ausente | Lineal/binaria coinciden; precondición orden validada | Javier | F2 |
| QA-28 | Distancias repetidas, lista ordenada/inversa/aleatoria | Insertion/merge mismo orden y desempate por ID | Javier | F2 |
| QA-29 | BFS entrada→salva_cola, origen=destino y aislado | Ruta mínima en saltos; [origen]; []/error según contrato | Javier | CP3 |
| QA-30 | Borrar conexión a zona requerida, validar mapa con DFS | Detecta zona inalcanzable y bloquea iniciar ese mapa | Javier | CP3 |
| QA-31 | Entrar zona/recoger objetivo mientras ruta visible | BFS/UI actualizan ruta al objetivo actual, no al eliminado | Guillermo | CP3 |
| QA-32 | Árbol válido y fixtures con dos padres/ciclo/raíz ausente | Válido carga; inválidos dan error sin iniciar misiones | Carlos/Javier | CP3 |
| QA-33 | Completar padre, repetir evento y activar hijo | Hijo activo; una recompensa; contar desde activación salvo caso miniboss | Carlos | CP3 |
| QA-34 | Matar mini antes de activar su misión | Al activarla consulta flag y completa/recompensa solo una vez | Carlos | CP3 |
| QA-35 | Cambiar flag, visitar zona y reset | UI lee diccionario real; sin HP/XP duplicados; flags reiniciados | Carlos | CP3 |
| QA-36 | Perfil ausente/corrupto/backup válido | Defaults o recuperación, aviso y ningún crash | Carlos | F2/final |
| QA-37 | Perfil de versión futura; simular fallo de escritura | No sobrescribe; error visible, juego sigue; original recuperable | Carlos | F2/final |
| QA-38 | Data inválida: ID repetido, cooldown0, referencia ausente, NaN | Validación precisa antes de iniciar run | Carlos/Roberto | F0/final |
| QA-39 | Estrés50/100/200/500, seed fija y release build | Métricas con contexto, sin considerar500 criterio obligatorio | René/Roberto | Final |
| QA-40 | Export en otra máquina y ventana diferente | Arranca, UI legible, input/audio/datos presentes, loop terminable | Guillermo/Roberto | Final |

Las pruebas de cinco/seis armas usan catálogo sintético etiquetado como fixture aunque el MVP tenga tres armas. No afirmar prueba de capacidad llena sin ese fixture.

## Smoke antes de merge

Desde menú: jugar → moverse → matar → recoger → subir/elegir → pausar/reanudar → morir → reiniciar. Probar el sistema modificado con su caso límite. Al existir jefes: usar escenario debug para victoria/derrota, y una run normal en cada candidato de release. Los atajos se registran.

## Criterios por prioridad

P0: no abre, crashea, corrompe estado, no puede terminar/reiniciar. P1: requisito del checkpoint ausente o mecánica crítica falla. P2: defecto con alternativa que no invalida entrega. P3: detalle visual menor. No entregar con P0/P1 abiertos del alcance comprometido. P2 requiere riesgo explícito y acuerdo del equipo, no un PASS inventado.

## Registro de ejecución

Por caso: ID, SHA/build, fecha, tester, plataforma/editor, seed, estado PASS/FAIL/BLOCKED/NOT_RUN, observado, evidencia y bug asociado. Roberto mantiene `docs/checkpoints/<hito>/test_results.md`; cada owner añade sus casos. Capturas/video deben corresponder al SHA probado. Repetir solo pruebas afectadas por nuevos cambios y smoke, no ejecutar la suite completa sin motivo en cada edición de documento.
