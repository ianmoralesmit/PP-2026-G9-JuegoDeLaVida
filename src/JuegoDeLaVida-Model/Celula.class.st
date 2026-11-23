"
Representa una celula individual ubicada en una coordenada (fila, columna) de la Grilla. Encapsula su posicion y delega polimorficamente su condicion de vida, aporte a la vecindad y transicion de estado en su objeto EstadoCelula actual.
"
Class {
	#name : 'Celula',
	#superclass : 'Object',
	#instVars : [
		'fila',
		'columna',
		'estado'
	],
	#category : 'JuegoDeLaVida-Model'
}

{ #category : 'instance creation' }
Celula class >> fila: unaFila columna: unaColumna [

	^ self fila: unaFila columna: unaColumna estado: EstadoMuerto new
]

{ #category : 'instance creation' }
Celula class >> fila: unaFila columna: unaColumna estado: unEstado [

	^ self new inicializarFila: unaFila columna: unaColumna estado: unEstado
]

{ #category : 'accessing' }
Celula >> aporteVecindad [

	^ estado aporteVecindad
]

{ #category : 'state' }
Celula >> cambiarEstadoA: unEstado [

	(unEstado isKindOf: EstadoCelula)
		ifFalse: [
			DomainError signal:
				'El estado asignado debe ser una instancia de EstadoCelula.' ].
	estado := unEstado
]

{ #category : 'accessing' }
Celula >> columna [

	^ columna
]

{ #category : 'testing' }
Celula >> estaLatente [

	^ estado estaLatente
]

{ #category : 'testing' }
Celula >> estaViva [

	^ estado estaViva
]

{ #category : 'accessing' }
Celula >> estado [

	^ estado
]

{ #category : 'evolution' }
Celula >> evolucionarConVecinos: cantidadVecinosVivos [

	self cambiarEstadoA: (estado siguienteEstadoConVecinos: cantidadVecinosVivos)
]

{ #category : 'accessing' }
Celula >> fila [

	^ fila
]

{ #category : 'initialization' }
Celula >> inicializarFila: unaFila columna: unaColumna estado: unEstado [

	(unaFila isInteger not or: [ unaFila < 1 ])
		ifTrue: [
			DomainError signal: 'La fila de la celula debe ser un entero mayor o igual a 1.' ].
	(unaColumna isInteger not or: [ unaColumna < 1 ])
		ifTrue: [
			DomainError signal:
				'La columna de la celula debe ser un entero mayor o igual a 1.' ].
	fila := unaFila.
	columna := unaColumna.
	self cambiarEstadoA: unEstado
]

{ #category : 'initialization' }
Celula >> initialize [

	super initialize.
	estado := EstadoMuerto new
]
