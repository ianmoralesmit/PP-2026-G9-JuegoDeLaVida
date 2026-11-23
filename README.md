# Juego de la Vida de Conway en Smalltalk (Pharo 13)

Proyecto integrador correspondiente a la **5.ª Instancia de Evaluación — Programación Orientada a Objetos** de la asignatura **Paradigmas de Programación** (2.º año, Ingeniería en Sistemas de Información), **Universidad Tecnológica Nacional — Facultad Regional Resistencia (UTN FRRe)**.

- **Comisión:** K2.1 — **Grupo 9**
- **Integrantes:**
  - Acuña, Ana Guillermina
  - Agüero, Juan Manuel
  - Morales Mitoire, Gonzalo Ian
  - Soria, Yael Fernanda
- **Repositorio:** https://github.com/ianmoralesmit/PP-2026-G9-JuegoDeLaVida

---

## Descripción del Proyecto y Variantes Implementadas

Se modela e implementa el **Juego de la Vida de Conway** (Escenario N.º 9) respetando la separación estricta entre la capa de dominio y la capa de presentación, evitando condicionales por tipo o estado mediante despacho polimórfico.

### Reglas base y aportes originales
1. **Patrón State (`EstadoCelula`):**
   - `EstadoVivo`: computa como viva (`aporteVecindad = 1`). Sobrevive con 2 o 3 vecinos vivos; ante subpoblación o superpoblación transiciona a `EstadoLatente`.
   - `EstadoMuerto`: no computa como viva (`aporteVecindad = 0`). Nace (`EstadoVivo`) con exactamente 3 vecinos vivos.
   - `EstadoLatente` *(variante original)*: resistencia transitoria de una generación. No computa como viva (`aporteVecindad = 0`), pero se reactiva a `EstadoVivo` si en la generación siguiente recupera 2 o 3 vecinos vivos; en caso contrario muere definitivamente pasando a `EstadoMuerto`.
2. **Patrón Strategy (`TopologiaGrilla`):**
   - `TopologiaAcotada`: bordes rígidos en el rango `[1..filas, 1..columnas]`.
   - `TopologiaToroidal` *(variante original)*: conecta bordes opuestos horizontal y verticalmente mediante aritmética modular en base 1 (`((fila - 1 + delta) \\ filas) + 1`), permitiendo cambiar la topología en tiempo de ejecución.
3. **Actualización síncrona en dos fases (`Grilla`):**
   - Primero se calcula la matriz de conteos de vecinos vivos correspondiente al instante `t`, y recién después se aplican todas las transiciones hacia `t+1`.
4. **Catálogo de patrones iniciales (`GeneradorPatrones`):**
   - Poblado aleatorio parametrizado por densidad (`[0..1]`) y patrones clásicos (`Glider`, `Blinker`, `Block`).

---

## Estructura del Proyecto (Formato Tonel)

```text
├── cargar_proyecto.st                  # Script para cargar paquetes, correr tests y abrir la UI en Pharo 13
├── README.md
└── src/
    ├── .properties                     # Metadatos Tonel
    ├── JuegoDeLaVida-Model/            # Capa de dominio (sin dependencias visuales)
    │   ├── package.st
    │   ├── SimuladorVida.class.st
    │   ├── Grilla.class.st
    │   ├── Celula.class.st
    │   ├── EstadoCelula.class.st
    │   ├── EstadoVivo.class.st
    │   ├── EstadoMuerto.class.st
    │   ├── EstadoLatente.class.st
    │   ├── TopologiaGrilla.class.st
    │   ├── TopologiaAcotada.class.st
    │   ├── TopologiaToroidal.class.st
    │   └── GeneradorPatrones.class.st
    ├── JuegoDeLaVida-Tests/            # Pruebas unitarias SUnit
    │   ├── package.st
    │   └── JuegoDeLaVidaTest.class.st
    └── JuegoDeLaVida-UI/               # Capa de presentación en Spec2 + Morphic
        ├── package.st
        ├── TableroVidaMorph.class.st
        └── VistaSimulador.class.st
```

### Nota de diseño sobre Pharo 13
En la imagen estándar de **Pharo 13.0 (64-bit stable)** la clase `Array2D` no viene preinstalada por defecto. Para garantizar que el proyecto funcione **sin conexión a internet ni dependencias externas**, la clase `Grilla` implementa el almacenamiento interno de `celdas` mediante una matriz indexada en base 1 (`Array` de `Array`s).

---

## Requisitos

- **Pharo 13.0** (64-bit stable).
- No requiere paquetes externos ni conexión a internet para cargar o ejecutar el sistema.

---

## Cómo cargar y ejecutar en Pharo 13 (sin conexión a internet)

### Opción 1: Desde un Playground (método rápido)
1. Abrí tu imagen de **Pharo 13**.
2. Abrí un **Playground** (`Ctrl + O`, luego `Ctrl + W`, o menú *Browse → Playground*).
3. Copiá el contenido de `cargar_proyecto.st` (ajustando la ruta en `rutaRepo` a la carpeta local donde clonaste/descomprimiste el repositorio).
4. Seleccioná todo (`Ctrl + A`) y ejecutalo con **Do it** (`Ctrl + D`).

Al ejecutarse:
- Importa los tres paquetes (`JuegoDeLaVida-Model`, `JuegoDeLaVida-Tests`, `JuegoDeLaVida-UI`) desde `src/`.
- Ejecuta la suite completa `JuegoDeLaVidaTest` e inspecciona los resultados.
- Abre la ventana gráfica mediante `VistaSimulador abrir.`.

### Opción 2: Importación mediante Iceberg (Git integrado en Pharo)
1. En Pharo 13 abrí **Browse → Iceberg**.
2. Hacé clic en **Add** (`+`) → **Import from existing clone**.
3. Seleccioná la carpeta raíz del repositorio (donde se encuentra `.git`) e indicá `src` como subdirectorio de código.
4. En la lista de paquetes del repositorio, seleccioná `JuegoDeLaVida-Model`, `JuegoDeLaVida-Tests` y `JuegoDeLaVida-UI` y hacé clic en **Load**.

---

## Cómo ejecutar las pruebas unitarias (SUnit)

- **Desde Test Runner:** abrí *Browse → Test Runner*, buscá el paquete `JuegoDeLaVida-Tests`, seleccioná `JuegoDeLaVidaTest` y presioná **Run Selected**.
- **Desde Playground:**
  ```smalltalk
  (JuegoDeLaVidaTest suite run) inspect.
  ```
La suite incluye 13 tests que validan supervivencia, nacimiento, estado latente (transición, reactivación y muerte definitiva), oscilador *Blinker* (actualización síncrona), *Block*, diferencias entre topología acotada y toroidal (incluido cruce de borde con *Glider*), cambio dinámico de topología, historial poblacional y validaciones con `DomainError`.

---

## Cómo abrir y usar la interfaz gráfica (`VistaSimulador`)

Una vez cargados los paquetes, ejecutá en un Playground:

```smalltalk
VistaSimulador abrir.
```

### Controles disponibles
- **Filas / Columnas + `Crear / Reiniciar Grilla`:** crea una nueva grilla con las dimensiones ingresadas. Si se ingresan valores no enteros o menores o iguales a `0`, la vista captura el `DomainError` del dominio y muestra un diálogo de alerta controlado.
- **Topología (`Acotada` / `Toroidal`):** permite cambiar la estrategia de vecindad en caliente sin reiniciar la simulación.
- **Patrón + `Cargar Patrón`:** puebla la grilla con distribución aleatoria (30%) o con los patrones `Glider`, `Blinker` o `Block`.
- **Clic directo sobre el tablero:** alterna manualmente el estado de cualquier celda (`Verde`: `EstadoVivo`, `Naranja`: `EstadoLatente`, `Blanco/Gris claro`: `EstadoMuerto`).
- **`Siguiente Paso` / `Iniciar` (o `Pausar`) / `Limpiar`:** avanza una generación, ejecuta la simulación de forma continua sin bloquear la interfaz, o limpia el tablero.
- **Indicadores en tiempo real:** muestra la **Generación (`t`)** y la **Población viva** actual.
