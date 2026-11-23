"
Representa el estado activo (vivo) de una Celula. Aporta 1 al conteo de vecinos vivos y, al evolucionar, sobrevive como EstadoVivo si posee 2 o 3 vecinos vivos; ante subpoblacion o superpoblacion transiciona al estado intermedio EstadoLatente.
"
Class {
	#name : 'EstadoVivo',
	#superclass : 'EstadoCelula',
	#category : 'JuegoDeLaVida-Model'
}

{ #category : 'accessing' }
EstadoVivo >> aporteVecindad [

	^ 1
]

{ #category : 'testing' }
EstadoVivo >> estaViva [

	^ true
]

{ #category : 'evolution' }
EstadoVivo >> siguienteEstadoConVecinos: cantidadVecinosVivos [

	self validarVecinos: cantidadVecinosVivos.
	(cantidadVecinosVivos between: 2 and: 3)
		ifTrue: [ ^ EstadoVivo new ].
	^ EstadoLatente new
]
