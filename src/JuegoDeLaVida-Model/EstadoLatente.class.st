"
Representa el estado transitorio de latencia celular (resistencia de una generacion tras perder condiciones de supervivencia). No computa como viva (aporteVecindad es 0), pero si en la generacion siguiente recupera 2 o 3 vecinos vivos se reactiva a EstadoVivo; de lo contrario muere definitivamente pasando a EstadoMuerto.
"
Class {
	#name : 'EstadoLatente',
	#superclass : 'EstadoCelula',
	#category : 'JuegoDeLaVida-Model'
}

{ #category : 'accessing' }
EstadoLatente >> aporteVecindad [

	^ 0
]

{ #category : 'testing' }
EstadoLatente >> estaLatente [

	^ true
]

{ #category : 'testing' }
EstadoLatente >> estaViva [

	^ false
]

{ #category : 'evolution' }
EstadoLatente >> siguienteEstadoConVecinos: cantidadVecinosVivos [

	self validarVecinos: cantidadVecinosVivos.
	(cantidadVecinosVivos between: 2 and: 3)
		ifTrue: [ ^ EstadoVivo new ].
	^ EstadoMuerto new
]
