"
Presentador principal en Spec2 (capa de presentacion) para operar e inspeccionar la simulacion del Juego de la Vida de Conway. Mantiene una referencia al SimuladorVida del dominio, coordina controles de parametrizacion, carga de patrones, cambio dinamico de topologia, ejecucion paso a paso o continua, y renderizado mediante TableroVidaMorph.
"
Class {
	#name : 'VistaSimulador',
	#superclass : 'SpPresenter',
	#instVars : [
		'simulador',
		'tableroMorph',
		'tableroPresenter',
		'inputFilas',
		'inputColumnas',
		'botonCrearGrilla',
		'selectorTopologia',
		'selectorPatron',
		'botonCargarPatron',
		'botonSiguientePaso',
		'botonIniciarPausar',
		'botonLimpiar',
		'etiquetaGeneracion',
		'etiquetaPoblacion',
		'etiquetaLeyenda',
		'enEjecucion',
		'procesoSimulacion',
		'intervaloMs',
		'transicionesManuales'
	],
	#category : 'JuegoDeLaVida-UI'
}

{ #category : 'instance creation' }
VistaSimulador class >> abrir [

	^ self new open
]

{ #category : 'updating' }
VistaSimulador >> actualizarTablero [

	etiquetaGeneracion label:
		'Generacion (t): ' , simulador generacion asString.
	etiquetaPoblacion label:
		'Poblacion viva: ' , simulador poblacionActual asString.
	tableroMorph changed
]

{ #category : 'actions' }
VistaSimulador >> alCambiarTopologia: unaTopologia [

	self ejecutarConManejoDeErrores: [
		simulador cambiarTopologiaA: unaTopologia.
		self actualizarTablero ]
]

{ #category : 'actions' }
VistaSimulador >> alPresionarSiguientePaso [

	self ejecutarConManejoDeErrores: [
		simulador avanzarGeneracion.
		self actualizarTablero ]
]

{ #category : 'actions' }
VistaSimulador >> alternarCelulaEnFila: fila columna: columna [

	self ejecutarConManejoDeErrores: [
		| celula claseSiguiente |
		celula := simulador grillaActual celulaEnFila: fila columna: columna.
		claseSiguiente := transicionesManuales
			at: celula estado class
			ifAbsent: [ EstadoVivo ].
		celula cambiarEstadoA: claseSiguiente new.
		self actualizarTablero ]
]

{ #category : 'simulation' }
VistaSimulador >> alternarEjecucion [

	enEjecucion
		ifTrue: [ self detenerSimulacion ]
		ifFalse: [ self iniciarSimulacion ]
]

{ #category : 'actions' }
VistaSimulador >> cargarPatronSeleccionado [

	self ejecutarConManejoDeErrores: [
		| itemSeleccionado |
		self detenerSimulacion.
		itemSeleccionado := selectorPatron selectedItem.
		itemSeleccionado ifNil: [
			DomainError signal: 'Debe seleccionar un patron inicial.' ].
		itemSeleccionado value
			value: GeneradorPatrones new
			value: simulador grillaActual.
		self actualizarTablero ]
]

{ #category : 'actions' }
VistaSimulador >> crearOReiniciarGrilla [

	self ejecutarConManejoDeErrores: [
		| filas columnas itemTopologia claseTopologia |
		self detenerSimulacion.
		filas := self parsearEntero: inputFilas text.
		columnas := self parsearEntero: inputColumnas text.
		itemTopologia := selectorTopologia selectedItem.
		claseTopologia := itemTopologia
			ifNil: [ TopologiaAcotada ]
			ifNotNil: [ itemTopologia value ].
		simulador
			iniciarConFilas: filas
			columnas: columnas
			topologia: claseTopologia new.
		self actualizarTablero ]
]

{ #category : 'layout' }
VistaSimulador >> defaultLayout [

	| barraConfig barraAcciones barraEstado |
	barraConfig := SpBoxLayout newLeftToRight
		spacing: 6;
		add: (self newLabel label: 'Filas:'; yourself) width: 40;
		add: inputFilas width: 60;
		add: (self newLabel label: 'Columnas:'; yourself) width: 70;
		add: inputColumnas width: 60;
		add: botonCrearGrilla width: 165;
		add: (self newLabel label: 'Topologia:'; yourself) width: 70;
		add: selectorTopologia width: 120;
		yourself.
	barraAcciones := SpBoxLayout newLeftToRight
		spacing: 6;
		add: (self newLabel label: 'Patron:'; yourself) width: 50;
		add: selectorPatron width: 145;
		add: botonCargarPatron width: 115;
		add: botonSiguientePaso width: 120;
		add: botonIniciarPausar width: 95;
		add: botonLimpiar width: 85;
		yourself.
	barraEstado := SpBoxLayout newLeftToRight
		spacing: 12;
		add: etiquetaGeneracion width: 140;
		add: etiquetaPoblacion width: 140;
		add: etiquetaLeyenda;
		yourself.
	^ SpBoxLayout newTopToBottom
		spacing: 8;
		add: barraConfig expand: false;
		add: barraAcciones expand: false;
		add: barraEstado expand: false;
		add: tableroPresenter;
		yourself
]

{ #category : 'simulation' }
VistaSimulador >> detenerSimulacion [

	enEjecucion := false.
	procesoSimulacion ifNotNil: [
		procesoSimulacion terminate.
		procesoSimulacion := nil ].
	botonIniciarPausar ifNotNil: [ botonIniciarPausar label: 'Iniciar' ]
]

{ #category : 'error handling' }
VistaSimulador >> ejecutarConManejoDeErrores: unBloque [

	unBloque
		on: Error
		do: [ :ex |
			self detenerSimulacion.
			self mostrarError: ex messageText ]
]

{ #category : 'simulation' }
VistaSimulador >> iniciarSimulacion [

	enEjecucion ifTrue: [ ^ self ].
	enEjecucion := true.
	botonIniciarPausar label: 'Pausar'.
	procesoSimulacion := [
		[ enEjecucion ] whileTrue: [
			(Delay forMilliseconds: intervaloMs) wait.
			enEjecucion ifTrue: [
				UIManager default defer: [
					enEjecucion ifTrue: [ self alPresionarSiguientePaso ] ] ] ]
	] forkAt: Processor userBackgroundPriority named: 'JuegoDeLaVida-Loop'
]

{ #category : 'initialization' }
VistaSimulador >> initialize [

	simulador := SimuladorVida new.
	simulador
		iniciarConFilas: 20
		columnas: 20
		topologia: TopologiaAcotada new.
	enEjecucion := false.
	intervaloMs := 200.
	transicionesManuales := Dictionary new
		at: EstadoVivo put: EstadoMuerto;
		at: EstadoMuerto put: EstadoVivo;
		at: EstadoLatente put: EstadoVivo;
		yourself.
	super initialize
]

{ #category : 'initialization' }
VistaSimulador >> initializePresenters [

	inputFilas := self newTextInput
		text: '20';
		placeholder: 'Filas';
		yourself.
	inputColumnas := self newTextInput
		text: '20';
		placeholder: 'Columnas';
		yourself.
	botonCrearGrilla := self newButton
		label: 'Crear / Reiniciar Grilla';
		action: [ self crearOReiniciarGrilla ];
		yourself.
	selectorTopologia := self newDropList
		display: [ :item | item key ];
		items: {
			'Acotada' -> TopologiaAcotada .
			'Toroidal' -> TopologiaToroidal
		};
		whenSelectedItemChangedDo: [ :item |
			item ifNotNil: [ self alCambiarTopologia: item value new ] ];
		yourself.
	selectorPatron := self newDropList
		display: [ :item | item key ];
		items: {
			'Aleatorio (30%)' -> [ :gen :grilla |
				gen poblarAleatorio: grilla densidad: 0.3 ] .
			'Glider' -> [ :gen :grilla |
				grilla limpiar.
				gen cargarGliderEn: grilla origen: 1 @ 1 ] .
			'Blinker' -> [ :gen :grilla |
				grilla limpiar.
				gen
					cargarBlinkerEn: grilla
					origen: ((grilla filas // 2 max: 1) @ ((grilla columnas // 2 - 1) max: 1)) ] .
			'Block' -> [ :gen :grilla |
				grilla limpiar.
				gen
					cargarBlockEn: grilla
					origen: ((grilla filas // 2 max: 1) @ (grilla columnas // 2 max: 1)) ]
		};
		yourself.
	botonCargarPatron := self newButton
		label: 'Cargar Patron';
		action: [ self cargarPatronSeleccionado ];
		yourself.
	botonSiguientePaso := self newButton
		label: 'Siguiente Paso';
		action: [ self alPresionarSiguientePaso ];
		yourself.
	botonIniciarPausar := self newButton
		label: 'Iniciar';
		action: [ self alternarEjecucion ];
		yourself.
	botonLimpiar := self newButton
		label: 'Limpiar';
		action: [ self limpiarGrilla ];
		yourself.
	etiquetaGeneracion := self newLabel.
	etiquetaPoblacion := self newLabel.
	etiquetaLeyenda := self newLabel
		label: 'Verde: Viva | Naranja: Latente | Blanco: Muerta (clic en celda para alternar)';
		yourself.
	tableroMorph := TableroVidaMorph new
		simulador: simulador;
		alHacerClickEnCelda: [ :f :c | self alternarCelulaEnFila: f columna: c ];
		yourself.
	tableroPresenter := self newMorph
		morph: tableroMorph;
		yourself.
	self actualizarTablero
]

{ #category : 'initialization' }
VistaSimulador >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Juego de la Vida de Conway - Grupo 9 (UTN FRRe)';
		initialExtent: 860 @ 680;
		whenClosedDo: [ self detenerSimulacion ]
]

{ #category : 'actions' }
VistaSimulador >> limpiarGrilla [

	self ejecutarConManejoDeErrores: [
		self detenerSimulacion.
		simulador grillaActual limpiar.
		self actualizarTablero ]
]

{ #category : 'error handling' }
VistaSimulador >> mostrarError: unMensaje [

	UIManager default
		alert: (unMensaje ifEmpty: [ 'Se produjo un error en los parametros ingresados.' ])
		title: 'Error de validacion'
]

{ #category : 'parsing' }
VistaSimulador >> parsearEntero: unTexto [

	| texto digitos |
	texto := unTexto asString trimBoth.
	texto isEmpty
		ifTrue: [
			DomainError signal: 'Debe ingresar un valor entero para filas y columnas.' ].
	digitos := (texto first = $-)
		ifTrue: [ texto allButFirst ]
		ifFalse: [ texto ].
	(digitos isEmpty or: [ (digitos allSatisfy: [ :ch | ch isDigit ]) not ])
		ifTrue: [
			DomainError signal:
				'Dimension invalida (' , texto , '). Debe ingresar un numero entero.' ].
	^ texto asInteger
]

{ #category : 'accessing' }
VistaSimulador >> simulador [

	^ simulador
]
