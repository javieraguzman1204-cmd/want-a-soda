# Registro de riesgos y respuesta

Propuesta inicial del16 de septiembre. Probabilidad/impacto cualitativos; Roberto revisa semanalmente. Una señal activa respuesta, no espera al día de entrega.

| ID | Riesgo | Prob./impacto | Señal observable | Mitigación / dueño |
|---|---|---|---|---|
| RISK01 | Editor incompatible o escena principal ausente | Alta/alta | Otro integrante no importa o F5 no abre | G01 registra binario y export; no downgrade masivo / Guillermo |
| RISK02 | Documentación y Godot en ramas distintas | Alta/alta | Merge elimina juego o CP1 | Incorporación selectiva y revisión de diff / Carlos |
| RISK03 | Syllabus/calendario no confirmado | Media/alta | Fechas/requisitos diferentes al plan v1 | O01 consigue fuente primaria; recalcular hitos / Roberto |
| RISK04 | Carlos/Guillermo absorben integración | Alta/alta | >20% de desviación o múltiples tickets ajenos | Owners integran; fixtures; redistribuir y recortar extras / todos |
| RISK05 | Contratos cambian por IA | Alta/alta | Duplicados de XP/inventario o firmas incompatibles | Un ticket, archivos delimitados, review productor/consumidor / Carlos |
| RISK06 | Cola acumula retraso o pierde boss | Media/alta | Atraso>10 s, CIO no aparece | Medir backlog, ajustar datos, excepción explícita de transición final / René |
| RISK07 | Pausa deja mundo activo | Media/alta | Daño/Timer durante mejora | Test process_mode y reloj único / Guillermo |
| RISK08 | XP/equipamiento duplicados | Media/alta | Doble pickup, doble clic, drop doble | Guards, revisiones y transacciones; QA11/19/20 / Carlos y René |
| RISK09 | Grafo solo existe en demo aislada | Media/alta | Ruta no corresponde a arena | Seis zonas físicas y BFS visible, DFS valida mapa / Javier |
| RISK10 | Recursos comparten HP/nivel por accidente | Media/alta | Un enemigo hereda daño de otro | Separar definición inmutable/runtime / Carlos |
| RISK11 | Contenido extra retrasa CP | Alta/alta | Nuevos mapas/armas antes de pruebas | Congelar3+3, extras después de gates / Roberto |
| RISK12 | Evidencia no corresponde al código | Media/alta | Video sin SHA o resultado viejo | Índice por checkpoint y prueba del mismo commit / Roberto |
| RISK13 | Medición engañosa | Media/media | Logs/generación dentro del tiempo, solo un run | Protocolo30 repeticiones, datos crudos y metadatos / Javier |
| RISK14 | Guardado corrupto o futuro sobrescrito | Media/media | JSON inválido/version desconocida | Validación, temp/backup, error no bloqueante / Carlos |
| RISK15 | Ausencia de un integrante | Media/alta | Entrega sin sustituto o bloqueo>24 h | Reviewer conoce módulo, documentación y ticket pequeño / todos |
| RISK16 | Scope5 min no deja terminar CIO | Alta/media | Victoria por reloj sin pelea |300 s de oleadas +90 s de boss explícitos / René |

## Plan de recorte

Primero quitar armas/pasivos extra, luego VFX sofisticados y arte adicional. Mantener tres armas/pasivos, una arena, loop completo y estructuras de la rúbrica. Si aun así no cabe, recalcular alcance con el equipo y profesor; no marcar requisitos como opcionales unilateralmente. La reserva de 50 h de equipo absorbe incertidumbre, no se asigna por adelantado a nuevas features.
