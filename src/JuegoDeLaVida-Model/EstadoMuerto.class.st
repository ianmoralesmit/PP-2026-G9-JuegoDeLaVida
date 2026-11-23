"
Representa el estado inactivo (muerto) de una Celula. No computa como viva y aporta 0 a la vecindad. Al evolucionar, nace convirtiendose en EstadoVivo unicamente si posee exactamente 3 vecinos vivos; en caso contrario permanece como EstadoMuerto.
"
Class {
	#name : 'EstadoMuerto',
	#superclass : 'EstadoCelula',
	#category : 'JuegoDeLaVida-Model'
}

{ #category : 'accessing' }
EstadoMuerto >> aporteVecindad [

	^ 0
]

{ #category : 'testing' }
EstadoMuerto >> estaViva [

	^ false
]

{ #category : 'evolution' }
EstadoMuerto >> siguienteEstadoConVecinos: cantidadVecinosVivos [

	self validarVecinos: cantidadVecinosVivos.
	cantidadVecinosVivos = 3
		ifTrue: [ ^ EstadoVivo new ].
	^ EstadoMuerto new
]
