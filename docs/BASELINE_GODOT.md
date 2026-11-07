# Baseline de Godot y plan de conservación

**Dueño: Guillermo.** Auditoría estática del SHA `f963ed9`; la ejecución/importación/exportación queda pendiente. No se cambió ningún archivo de juego durante la creación de este paquete.

## Escena actual

```text
Mundo (mundo.tscn)
├── Enemigo(gordo_bolito) [enemigo]
│   ├── CollisionShape2D
│   └── AnimatedSprite2D
├── Jugador(Amado Neftali) [jugador]
│   ├── CollisionShape2D
│   ├── Camera2D
│   ├── AnimatedSprite2D
│   ├── BarraVida
│   └── TimerEscopeta (2.0 s)
├── GeneradorEnemigos
│   └── Timer (0.5 s)
└── HUD (CanvasLayer)
    ├── BarraXP
    └── TextoNivel
```

La raíz del proyecto no configura `run/main_scene`. Abrir `mundo.tscn` y ejecutar escena (F6) es el primer intento reproducible; configurar F5 en un ticket separado. No hay input map personalizado: usa `ui_left/right/up/down`. Las escenas no declaran capas/máscaras personalizadas; verificar valores efectivos en el editor antes de cambiar colisiones.

## Archivos y adaptación mínima

| Archivo existente | Se conserva | Adaptación prevista | Dueño |
|---|---|---|---|
| jugador(amado_neftali).gd/.tscn | Movimiento, animación, cámara, empuje, barra | Delegar XP; envolver daño/salud; retirar acceso directo al HUD al integrar señales | Guillermo |
| enemigo(gordo_bolito).gd/.tscn | Sprite, persecución y feedback | ID runtime, muerte única, definición de enemigo, emisión de drop | René |
| generador_enemigos.gd | Cálculo inicial de posición circular | Se desactiva su Timer al conectar WaveManager; no deben coexistir generadores | René |
| bala.gd/.tscn | Proyectil y duración máxima 2 s | Contrato de daño e impacto único; limpiar referencias inválidas | Guillermo |
| moneda_xp.gd/.tscn | Visual y Area2D | Marca consumida; entregar a XPSystem una vez | René con interfaz de Carlos |
| hud.tscn | Barra y etiqueta | HUDController por señales; layout escalable | Guillermo |
| project.godot | Nombre, render GL Compatibility | Escena principal, inputs, capas y autoloads de forma controlada | Guillermo |

Las rutas viejas no se renombran hasta que termine CP2, salvo necesidad concreta. Carpetas nuevas reciben sistemas nuevos; no hay refactor masivo de sprites y escenas. Los `.uid` se versionan; `.godot/` permanece ignorada.

## Registro pendiente de completar por Guillermo

- Editor: versión completa/build y sistema operativo.
- SHA importado y escena ejecutada.
- Resultado: importación, parser, 60 s de movimiento/disparo/XP.
- Capas/máscaras efectivas, controles y dimensiones de viewport.
- Video 30–60 s y errores conocidos con pasos de reproducción.
- Export mínimo y máquina de prueba.

## Migración gradual

Primero introducir adaptadores: `ganar_xp(cantidad)` llama a `XPSystem.add_xp`; `recibir_dano(cantidad)` llama a HealthComponent. Retirar las variables antiguas en la misma integración para evitar doble autoridad. Mantener firmas viejas mientras existan consumidores, documentando su retirada en INTERFACES.

Desactivar el Timer antiguo solo cuando la escena de oleadas demuestre spawn funcional. Quitar el enemigo precolocado de Mundo al integrar el escenario de oleadas; no contarlo como un spawn de la cola. En cada PR ejecutar movimiento, tiro, drop y XP. Ante regresión volver al commit anterior del módulo, sin reemplazar ramas enteras.
