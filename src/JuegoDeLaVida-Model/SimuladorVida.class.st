"
Orquestador principal del dominio de la simulacion del Juego de la Vida. Administra la grilla actual, el contador de generaciones transcurridas y el historial de poblacion viva por cada generacion.
"
Class {
	#name : 'SimuladorVida',
	#superclass : 'Object',
	#instVars : [
		'grillaActual',
		'generacion',
		'historialPoblacion'
	],
	#category : 'JuegoDeLaVida-Model'
}

{ #category : 'simulation' }
SimuladorVida >> avanzarGeneracion [

	self validarSimuladorInicializado.
	grillaActual calcularSiguienteGeneracion.
	generacion := generacion + 1.
	historialPoblacion add: self poblacionActual
]

{ #category : 'configuration' }
SimuladorVida >> cambiarTopologiaA: unaTopologia [

	self validarSimuladorInicializado.
	grillaActual cambiarTopologiaA: unaTopologia
]

{ #category : 'simulation' }
SimuladorVida >> ejecutarGeneraciones: cantidad [

	self validarSimuladorInicializado.
	(cantidad isInteger not or: [ cantidad < 0 ])
		ifTrue: [
			DomainError signal:
				'La cantidad de generaciones a ejecutar debe ser un entero mayor o igual a cero.' ].
	cantidad timesRepeat: [ self avanzarGeneracion ]
]

{ #category : 'accessing' }
SimuladorVida >> generacion [

	^ generacion
]

{ #category : 'accessing' }
SimuladorVida >> grillaActual [

	^ grillaActual
]

{ #category : 'accessing' }
SimuladorVida >> historialPoblacion [

	^ historialPoblacion copy
]

{ #category : 'initialization' }
SimuladorVida >> iniciarConFilas: cantidadFilas columnas: cantidadColumnas topologia: unaTopologia [

	grillaActual := Grilla
		filas: cantidadFilas
		columnas: cantidadColumnas
		topologia: unaTopologia.
	generacion := 0.
	historialPoblacion := OrderedCollection with: self poblacionActual
]

{ #category : 'initialization' }
SimuladorVida >> initialize [

	super initialize.
	generacion := 0.
	historialPoblacion := OrderedCollection new
]

{ #category : 'querying' }
SimuladorVida >> poblacionActual [

	self validarSimuladorInicializado.
	^ grillaActual cantidadVivas
]

{ #category : 'validation' }
SimuladorVida >> validarSimuladorInicializado [

	grillaActual ifNil: [
		DomainError signal:
			'El simulador no fue inicializado con una grilla.' ]
]
