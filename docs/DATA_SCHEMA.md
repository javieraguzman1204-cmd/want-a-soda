# Esquemas y diccionario de datos

**Contrato v1 · Dueño: Carlos.** Tipos conceptuales para implementar Resources/GDScript. Todos los campos listados son obligatorios salvo los marcados opcionales. JSON usa String para StringName y arrays de dos números para Vector2. Campos desconocidos se rechazan en catálogos; en perfil se procesan solo dentro de una versión de esquema conocida.

## WeaponDefinition y WeaponLevel

| Campo | Tipo | Regla |
|---|---|---|
| id | StringName | Único, estable, ASCII snake_case |
| display_name | String | 1–80 caracteres |
| category | enum | Siempre weapon |
| behavior_id | enum | projectile, chain, melee; area para ampliación |
| scene_path | String | Ruta res:// válida, opcional en fixtures conceptuales |
| levels | Array[WeaponLevel] | 1–5 filas contiguas; max_level = tamaño |
| tags | Array[StringName] | Opcional; no define comportamiento por texto visible |

WeaponLevel: `level:int 1..5`, `damage:int >=0`, `cooldown_s:float >0`, `range_px:float >0`, `projectile_speed_px_s:float >=0`, `max_targets:int 1..8`. Para Escopeta/Machete max_targets no limita un área: se ignora por contrato de su behavior; el campo define profundidad solo en chain. Valores completos por nivel, no una mezcla de deltas y totales. `current_level` pertenece a EquippedItem.

## PassiveDefinition

`id`, `display_name`, `category=passive`, `effect_stat:enum`, `levels:Array[PassiveLevel]`. Cada fila: `level:int`, `value:float` finito. Los stats admitidos: `move_speed_pct`, `armor_flat`, `attack_speed_pct`, `max_health_flat`, `pickup_radius_pct`. Una definición modifica un stat; agregar efectos compuestos requiere ampliar esquema.

`value` es efecto total del nivel, no incremento sobre nivel anterior. 0.10 significa +10%. Los flat son enteros no negativos en uso. Los porcentajes tienen rango inicial 0..2 para evitar valores accidentales enormes; el validador usa límites documentados, no texto del nombre.

## EnemyDefinition

| Campo | Tipo/unidad | Regla |
|---|---|---|
| id, display_name | StringName, String | ID conocido |
| kind | enum | basic, medium, miniboss, final_boss |
| max_health | int HP | >0 |
| contact_damage | int HP | ≥0 |
| move_speed_px_s | float | ≥0 |
| contact_cooldown_s | float | >0 |
| xp_reward | int | Básico1, mediano5, mini20, CIO0 |
| scene_path | String | res://; escena asignada y existente |
| behavior_id | enum | chase, charge, radial_boss |

EnemyInstance: `instance_id:int`, `run_id:String`, `definition_id`, `current_hp:int`, `is_dead:bool`, `position:Vector2`, `attack_cooldown_remaining_s:float`. El Node runtime mantiene estos valores. `is_dead` evita doble emisión; no es otra máquina de estado de partida.

## WaveDefinition y WaveEvent

WaveDefinition: `id:StringName`, `map_id:StringName`, `balance_version:String`, `regular_active_limit:int=50`, `max_spawns_per_frame:int=5`, `events:Array[WaveEvent]`.

WaveEvent: `event_id:StringName` único, `time_s:float >=0`, `sequence:int >=0` única por ola, `enemy_id:StringName`, `quantity:int 1..50`, `pattern:enum ring|edge|boss_anchor`. Orden ascendente `(time_s,sequence)`. Sin campo priority en v1. Los eventos regulares tienen time_s<300; mini jefe=180 y CIO=300, quantity=1.

WaveRuntime: cursor/eventos cola, evento actual opcional y `remaining_quantity`. Sacar un evento de la cola no implica que todos sus enemigos ya aparecieron. Mantener el evento actual hasta cumplirlo; con cupo lleno se pospone, no se reencola ni reordena. Al entrar CIO se cancelan pendientes regulares explícitamente con log de cancelación.

## Inventario, XP y PlayerState

EquippedItem: `item_id:StringName`, `level:int 1..max_level`. InventoryState: `run_id`, `revision:int >=0`, `weapons:Array[EquippedItem] <=5`, `passives:Array[EquippedItem] <=5`. IDs únicos entre ambos arrays, tipo coincide con catálogo. Escopeta L1 en reset. No contiene pickups.

XPState: `level:int 1..20`, `current_xp:int >=0`, `total_collected_xp:int >=0`, `earned_choices:int >=0`. En nivel<20 current_xp es menor al siguiente umbral tras procesar; en nivel 20 current_xp=0 y next_required=0 como vista MAX. `earned_choices=level-1` en una partida sin comandos debug. LevelUpState: `consumed_choices:int`, `active_offer:Offer?`; pendientes = earned_choices-consumed_choices. No decrementar XP para consumir elección.

PlayerState es snapshot: `current_hp`, `max_hp`, `level`, `current_xp`, `next_required`, `move_speed_px_s`, `armor_flat`, `pickup_radius_px`, `attack_speed_multiplier`. Incluye `run_id` y se construye de dueños reales; la UI no puede escribirlo.

Offer: `offer_id:String`, `run_id`, `inventory_revision:int`, `candidates:Array[Candidate]`. Candidate: `candidate_id:String`, `kind:add|upgrade|heal|continue`, `item_id:StringName?`, `resulting_level:int?`, `heal_amount:int?`. Validez reevaluada al confirmar; no confiar en IDs enviados por UI.

## Stats y fórmula de efectos

Base propuesta: HP100, speed300 px/s, armor0, pickup radius95 px, attack_speed1. Los pasivos suman sus contribuciones sobre base:

```text
speed = base_speed * (1 + suma(move_speed_pct))
armor = base_armor + suma(armor_flat)
attack_speed_multiplier = 1 + suma(attack_speed_pct)
cooldown_efectivo = weapon_level.cooldown_s / attack_speed_multiplier
max_hp = base_max_hp + suma(max_health_flat)
pickup_radius = base_radius * (1 + suma(pickup_radius_pct))
daño_recibido = max(1, daño_bruto - armor) si daño_bruto > 0
```

Daño bruto=0 aplica 0, nunca 1. Cambiar HP máximo conserva HP absoluto y lo limita al nuevo máximo; no cura gratis. Las mejoras de arma usan directamente la fila del nivel. Nunca aplicar el mismo pasivo desde Player y WeaponController.

## MapDefinition y grafo

MapDefinition: `id`, `spawn_position:[x,y]`, `zones:Array[ZoneDefinition]`, `edges:Array[MapEdge]`. ZoneDefinition: `id`, `display_name`, `center:[x,y]`, `required:bool`. MapEdge: `from_id`, `to_id`, `bidirectional:bool=true`. Grafo no ponderado: BFS minimiza saltos entre zonas, no distancia física.

IDs iniciales: entrada, parqueo, tienda, callejon, plaza, salva_cola. Conexiones: entrada-parqueo, entrada-tienda, parqueo-callejon, tienda-plaza, callejon-plaza, plaza-salva_cola. Las coordenadas son datos de la escena por definir; no se inventa un mapa ya construido.

## MissionDefinition y estado

MissionDefinition: `id`, `parent_id:StringName|null`, `condition:{event_type, target_id?, required_count:int>0}`, `reward:{kind:none|heal|spawn_regia, amount:int>=0}`. Raíz única `patrulla` con condición run_started y recompensa none. Misiones de zona tienen required_count1; recoger monedas cuenta pickups consumidos, no puntos XP. `derrotar_miniboss` cuenta la muerte real, no despawn.

Los eventos para estas condiciones son run_started, pickup_collected, zone_entered y enemy_died según INTERFACES. `pickup_kind=xp_coin` identifica la moneda; pickup_id sirve para deduplicar.

MissionRuntime: `mission_id`, `status:locked|active|completed`, `progress:int`, `reward_granted:bool`. MissionSystem deduplica por ID de evento; los eventos de moneda usan pickup_instance_id. La condición solo cuenta desde activación. Si el mini jefe ya fue vencido antes de activar su misión, al activarla se consulta WorldState y se completa una vez; documentar este caso especial idempotente.

WorldState: `map_id`, `visited_zones:Dictionary[StringName,bool]`, `miniboss_defeated:bool`, `boss_defeated:bool`. Set_flag solo permite estas dos claves booleanas; zonas se actualizan con visit_zone. No contiene HP/XP/build. Estado de misión pertenece a MissionSystem.

## Profile y RunSummary

Profile: `schema_version:int=1`, `settings:{master_volume:float 0..1, reduce_flashes:bool}`, `completed_mission_ids:Array[String]` única, `recent_runs:Array[RunSummary] <=20`.

RunSummary: `run_id:String`, `seed:int`, `balance_version:String`, `result:victory|defeat`, `duration_s:float>=0`, `player_level:int1..20`, `kills:int>=0`, `build:{weapons:[EquippedItem],passives:[EquippedItem]}`. Stats de daño por arma pueden añadirse como campo opcional `damage_by_weapon:Dictionary[String,int]`, sin inventar cifras al migrar guardados antiguos.

Debug/abandonos al menú no generan resumen competitivo. `run_id` duplicado se ignora al guardar. Ejemplo estructural en [profile.v1.example.json](data_examples/profile.v1.example.json).
