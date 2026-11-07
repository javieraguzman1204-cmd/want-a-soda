# Ejemplos de contratos de datos

Estos archivos son fixtures de planificación válidos como JSON, **no contenido instalado en el runtime Godot**. El esquema definitivo se implementará con Resources según DATA_SCHEMA. No constituyen una segunda fuente de balance de producción.

- [Catálogo](catalog.fixture.json): tres armas/tres pasivos, cinco niveles completos por objeto, y los cuatro enemigos con los valores propuestos en BALANCE_DESIGN. Omite escenas conforme a la excepción de fixtures conceptuales, salvo `enemy_basic`, cuya escena ya existe (`res://enemigo(gordo_bolito).tscn`); `enemy_medium`, `miniboss` y `boss_cio` reciben `scene_path` cuando René cree sus escenas.
- [Inventario](inventory.example.json): snapshot con IDs y niveles, sin Nodes ni HP.
- [Perfil](profile.v1.example.json): guardado inicial sin resultados inventados.
- [Oleada](wave.fixture.json): cinco eventos ilustrativos del contrato; no representa la curva completa de BALANCE_DESIGN. Referencia los cuatro EnemyDefinition del catálogo.
- [Grafo](graph.fixture.json): adyacencia derivada; no es MapDefinition completo ni inventa coordenadas de escena.
- [Misiones](missions.fixture.json): raíz y condiciones/recompensas explícitas. `amount` de spawn_regia es cantidad de pickups; en heal es HP; none requiere0.

Carlos valida estructura/IDs; Roberto transforma valores en `.tres`; el owner de cada escena asigna recursos reales. Los fixtures de prueba para sexta arma y slots llenos deben añadir IDs sintéticos claramente separados del catálogo jugable.
