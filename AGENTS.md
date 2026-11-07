# AGENTS.md — Want a Soda? Amado y peligroso
 
Este archivo le da contexto a cualquier agente de IA (Claude Code, Codex, o cualquier otro)
que trabaje en este repositorio. Léelo antes de tocar código.
 
## Qué es este proyecto
 
**Want a Soda? Amado y peligroso** es un videojuego hecho en **Godot 4.7**, desarrollado
como proyecto de equipo para la materia *Estructura de Datos y Algoritmos Computacionales*
(Instituto Kriete de Ingeniería y Ciencias, Mgtr. Rafael Alexander Torres Rodríguez).
 
El repositorio tiene dos tipos de contenido que **no se deben mezclar**:
 
1. **El juego en sí** (Godot/GDScript) — escenas, scripts, sprites, animaciones.
2. **Entregables académicos** (Python) — los checkpoints de la materia, donde se modelan
   estructuras de datos (ej. el inventario del jugador como lista) y se documenta con
   pseudocódigo, diagramas de flujo y evidencia de ejecución.
### Concepto del juego
 
- **Mundo:** una colonia salvadoreña, con el tono de humor negro del meme "¿Querés gaseosa?".
- **Protagonista:** Amado Neftalí, vigilante nocturno.
- **Antagonistas:** fiesteros y borrachos (enemigos básicos), peligros mayores de la noche
  (enemigos medianos y mini jefes), y el CIO de Salva Cola como jefe final.
- **Objeto especial:** la Escopeta, arma inicial e icónica del protagonista.
- **Problema a resolver:** proteger a los vecinos de la colonia y derrotar al CIO de Salva
  Cola para liberarse de la gaseosa.
## Stack técnico
 
- **Motor del juego:** Godot 4.7 (GL Compatibility renderer). Lenguaje: GDScript.
- **Entregables de la materia:** Python 3, sin dependencias externas.
- **Control de versiones:** Git + GitHub (repo privado). `.godot/` y `/android/` están
  ignorados vía `.gitignore` — nunca deben commitearse.
## Reglas para cualquier agente
 
1. **No renombrar ni mover archivos de Godot** (`.tscn`, `.gd`, `.import`, sprites) fuera
   del editor de Godot. Godot vincula estos archivos por rutas y UID internos; renombrarlos
   con una herramienta externa (o un agente que no entienda esto) rompe referencias de
   escena silenciosamente.
2. **Respetar el `.gitignore` existente.** No commitear `.godot/`, `__pycache__/`,
   `.DS_Store`, ni carpetas de build.
3. **Commits pequeños y descriptivos**, en español, título corto (idealmente <50 caracteres)
   más una línea de descripción si hace falta detalle — es el mismo estilo que ya usa el
   equipo en GitHub.
4. **No reescribir historial compartido** (`git push --force`, `rebase` sobre `main`) sin
   avisar al equipo primero.
5. **Los entregables académicos (checkpoints) no se tocan sin que Roberto lo pida** — son
   documentos ya revisados y entregados; cualquier cambio ahí debe pasar por él.
6. Antes de un cambio grande (nueva mecánica, refactor de una escena central), dejarlo
   anotado en el commit o pedir confirmación en vez de asumir alcance.
## Estructura del repositorio
 
```
want-a-soda/
├── project.godot                  # Configuración raíz del proyecto Godot
├── mundo.tscn                     # Escena principal del juego
├── hud.tscn                       # Interfaz en pantalla
├── jugador(amado_neftali).*       # Escena/script/animación del protagonista
├── enemigo(gordo_bolito).*        # Escena/script del enemigo básico
├── generador_enemigos.gd          # Spawner de enemigos
├── bala.*                         # Escena/script de proyectiles
├── moneda_xp.*                    # Escena/script de recolectables de experiencia
├── *.png / *.svg (+ .import)      # Arte y sprites
├── .gitignore / .gitattributes / .editorconfig
└── (checkpoints de la materia se manejan en documentos aparte, ver README.md)
```
 
## Equipo y roles
 
División propuesta por el equipo (5 personas). **Regla de oro:** un sistema puede tener
colaboradores, pero solo una persona es responsable de que ese sistema termine funcionando
e integrado.
 
| Persona | Rol principal | Responsabilidad central |
|---|---|---|
| Guillermo Córdova | Godot / Gameplay & Engine Lead | Escenas, jugador, animaciones, colisiones, integración visual, ejecución del combate |
| René Serrano | Enemy & Wave Systems / Gameplay Integration | Enemigos, spawns, oleadas, jefes, integración de cola de eventos |
| Carlos Valencia | Architecture, Data & Integration Lead | Arquitectura, inventario, XP, estados, integración general, criterios técnicos y defensa |
| Javier Guzmán | Algorithms & Gameplay Systems Lead | Pilas, colas, recursividad, búsqueda, ordenamiento, grafos, BFS/DFS y módulos algorítmicos |
| Roberto Villacorta | Product, QA, Game Data & Evidence Lead | Superestructura inicial asistida por IA, documentación, balance, pruebas, evidencias y métricas |
 
## Cómo se dividen Claude Code y Codex en este repo
 
Para evitar que los dos agentes se pisen entre sí o generen conflictos de merge, se dividen
por **carril de trabajo (ownership por carpeta/tipo de archivo)**, no por "quién es mejor en
qué" — ambos son agentes de código de nivel similar, así que la división por carril es lo que
realmente evita fricción:
 
- **Claude Code** — mecánica de juego en Godot/GDScript (escenas, scripts de gameplay,
  balance de combate/XP), mantenimiento de este `AGENTS.md`/`README.md`, y operaciones de
  git/GitHub (commits, PRs, resolución de conflictos).
- **Codex** — entregables de Python de la materia (estructuras de datos, checkpoints),
  generación de contenido/sistemas nuevos en paralelo, y como **segunda opinión/revisor**
  sobre los cambios que proponga Claude Code antes de mergear a `main` (un agente que
  implementa, otro que revisa, reduce bugs que un solo agente no se detecta a sí mismo).
- **Roberto** — integra y aprueba: revisa lo que proponen ambos agentes, decide qué se
  mergea, y es responsable final de la evidencia y calidad del entregable.
Si en algún punto un agente necesita tocar el carril del otro, debe dejarlo explícito en el
mensaje de commit (ej. "Codex: ajuste menor en mundo.tscn para desbloquear checkpoint").
 
Como el rol de Roberto (Product, QA, Game Data & Evidence Lead) es el que trabaja
directamente con Claude Code y Codex, los cambios que estos agentes propongan en carpetas
que sean responsabilidad central de otra persona (ej. `enemigo(gordo_bolito).*` es de René,
`mundo.tscn`/animaciones de Guillermo) deben quedar marcados como propuesta en el commit y
esa persona los revisa antes de darlos por definitivos — no se pisan responsabilidades
ajenas sin avisar.
