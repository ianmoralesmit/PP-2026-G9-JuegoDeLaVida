"
Administra una matriz bidimensional de M x N instancias de Celula (matriz indexada en base 1 mediante Array de Arrays) y una estrategia TopologiaGrilla. Coordina el conteo de vecinos vivos y garantiza la actualizacion sincrona en dos fases hacia la generacion t+1.
"
Class {
	#name : 'Grilla',
	#superclass : 'Object',
	#instVars : [
		'filas',
		'columnas',
		'celdas',
		'topologia'
	],
	#category : 'JuegoDeLaVida-Model'
}

{ #category : 'instance creation' }
Grilla class >> filas: cantidadFilas columnas: cantidadColumnas topologia: unaTopologia [

	^ self new
		inicializarFilas: cantidadFilas
		columnas: cantidadColumnas
		topologia: unaTopologia
]

{ #category : 'evolution' }
Grilla >> calcularSiguienteGeneracion [

	| conteosVecinos |
	conteosVecinos := (1 to: filas) collect: [ :f |
		(1 to: columnas) collect: [ :c |
			self contarVecinosVivosDe: (self celulaEnFila: f columna: c) ] ].
	1 to: filas do: [ :f |
		1 to: columnas do: [ :c |
			(self celulaEnFila: f columna: c)
				evolucionarConVecinos: ((conteosVecinos at: f) at: c) ] ]
]

{ #category : 'configuration' }
Grilla >> cambiarTopologiaA: unaTopologia [

	(unaTopologia isKindOf: TopologiaGrilla)
		ifFalse: [
			DomainError signal:
				'La topologia debe ser una instancia de TopologiaGrilla.' ].
	topologia := unaTopologia
]

{ #category : 'querying' }
Grilla >> cantidadVivas [

	| total |
	total := 0.
	1 to: filas do: [ :f |
		1 to: columnas do: [ :c |
			total := total + (self celulaEnFila: f columna: c) aporteVecindad ] ].
	^ total
]

{ #category : 'accessing' }
Grilla >> celulaEnFila: unaFila columna: unaColumna [

	self validarCoordenadaFila: unaFila columna: unaColumna.
	^ (celdas at: unaFila) at: unaColumna
]

{ #category : 'accessing' }
Grilla >> columnas [

	^ columnas
]

{ #category : 'querying' }
Grilla >> contarVecinosVivosDe: unaCelula [

	(unaCelula isKindOf: Celula)
		ifFalse: [ DomainError signal: 'Se esperaba una instancia de Celula.' ].
	^ (topologia vecinosDe: unaCelula en: self)
		sumNumbers: [ :vecina | vecina aporteVecindad ]
]

{ #category : 'validation' }
Grilla >> esCoordenadaValidaFila: unaFila columna: unaColumna [

	(unaFila isInteger and: [ unaColumna isInteger ])
		ifFalse: [ ^ false ].
	^ (unaFila between: 1 and: filas)
		and: [ unaColumna between: 1 and: columnas ]
]

{ #category : 'accessing' }
Grilla >> filas [

	^ filas
]

{ #category : 'initialization' }
Grilla >> inicializarFilas: cantidadFilas columnas: cantidadColumnas topologia: unaTopologia [

	(cantidadFilas isInteger not or: [ cantidadFilas < 1 ])
		ifTrue: [
			DomainError signal:
				'La cantidad de filas debe ser un entero positivo mayor a cero.' ].
	(cantidadColumnas isInteger not or: [ cantidadColumnas < 1 ])
		ifTrue: [
			DomainError signal:
				'La cantidad de columnas debe ser un entero positivo mayor a cero.' ].
	filas := cantidadFilas.
	columnas := cantidadColumnas.
	self cambiarTopologiaA: unaTopologia.
	celdas := (1 to: filas) collect: [ :f |
		(1 to: columnas) collect: [ :c | Celula fila: f columna: c ] ]
]

{ #category : 'initialization' }
Grilla >> limpiar [

	1 to: filas do: [ :f |
		1 to: columnas do: [ :c |
			(self celulaEnFila: f columna: c) cambiarEstadoA: EstadoMuerto new ] ]
]

{ #category : 'accessing' }
Grilla >> topologia [

	^ topologia
]

{ #category : 'validation' }
Grilla >> validarCoordenadaFila: unaFila columna: unaColumna [

	(self esCoordenadaValidaFila: unaFila columna: unaColumna)
		ifFalse: [
			DomainError signal:
				'Coordenada fuera de los limites validos de la grilla.' ]
]
