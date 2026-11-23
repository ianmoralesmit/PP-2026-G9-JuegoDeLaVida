"
Clase abstracta que define el protocolo polimorfico del patron State para el ciclo de vida de una Celula. Sus subclases (EstadoVivo, EstadoMuerto y EstadoLatente) determinan si la celula computa como viva, cuanto aporta a la vecindad y hacia que estado transiciona segun la cantidad de vecinos vivos.
"
Class {
	#name : 'EstadoCelula',
	#superclass : 'Object',
	#category : 'JuegoDeLaVida-Model'
}

{ #category : 'accessing' }
EstadoCelula >> aporteVecindad [

	^ self subclassResponsibility
]

{ #category : 'testing' }
EstadoCelula >> estaLatente [

	^ false
]

{ #category : 'testing' }
EstadoCelula >> estaViva [

	^ self subclassResponsibility
]

{ #category : 'evolution' }
EstadoCelula >> siguienteEstadoConVecinos: cantidadVecinosVivos [

	^ self subclassResponsibility
]

{ #category : 'validation' }
EstadoCelula >> validarVecinos: cantidadVecinosVivos [

	(cantidadVecinosVivos isInteger not or: [ cantidadVecinosVivos < 0 ])
		ifTrue: [
			DomainError signal:
				'La cantidad de vecinos vivos debe ser un entero mayor o igual a cero.' ]
]
