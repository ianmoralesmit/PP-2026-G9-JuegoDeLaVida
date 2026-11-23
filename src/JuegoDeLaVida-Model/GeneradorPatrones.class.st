"
Clase auxiliar encargada de poblar una Grilla con configuraciones iniciales, tanto mediante distribucion aleatoria parametrizada por densidad como cargando patrones clasicos predefinidos (Glider, Blinker y Block) a partir de una coordenada origen.
"
Class {
	#name : 'GeneradorPatrones',
	#superclass : 'Object',
	#category : 'JuegoDeLaVida-Model'
}

{ #category : 'patterns' }
GeneradorPatrones >> cargarBlinkerEn: unaGrilla origen: unOrigen [

	| desplazamientos |
	desplazamientos := { (0 @ 0) . (0 @ 1) . (0 @ 2) }.
	self cargarDesplazamientos: desplazamientos en: unaGrilla origen: unOrigen
]

{ #category : 'patterns' }
GeneradorPatrones >> cargarBlockEn: unaGrilla origen: unOrigen [

	| desplazamientos |
	desplazamientos := { (0 @ 0) . (0 @ 1) . (1 @ 0) . (1 @ 1) }.
	self cargarDesplazamientos: desplazamientos en: unaGrilla origen: unOrigen
]

{ #category : 'private' }
GeneradorPatrones >> cargarDesplazamientos: desplazamientos en: unaGrilla origen: unOrigen [

	| coordenadas |
	self validarGrilla: unaGrilla.
	unOrigen isPoint
		ifFalse: [
			DomainError signal:
				'El origen del patron debe ser un Point (fila @ columna).' ].
	coordenadas := desplazamientos collect: [ :delta |
		| fila columna |
		fila := unOrigen x + delta x.
		columna := unOrigen y + delta y.
		unaGrilla validarCoordenadaFila: fila columna: columna.
		fila @ columna ].
	coordenadas do: [ :coord |
		(unaGrilla celulaEnFila: coord x columna: coord y)
			cambiarEstadoA: EstadoVivo new ]
]

{ #category : 'patterns' }
GeneradorPatrones >> cargarGliderEn: unaGrilla origen: unOrigen [

	| desplazamientos |
	desplazamientos := { (0 @ 1) . (1 @ 2) . (2 @ 0) . (2 @ 1) . (2 @ 2) }.
	self cargarDesplazamientos: desplazamientos en: unaGrilla origen: unOrigen
]

{ #category : 'patterns' }
GeneradorPatrones >> poblarAleatorio: unaGrilla densidad: unaDensidad [

	| generador |
	self validarGrilla: unaGrilla.
	((unaDensidad isKindOf: Number) and: [ unaDensidad between: 0 and: 1 ])
		ifFalse: [
			DomainError signal:
				'La densidad debe ser un numero comprendido entre 0 y 1.' ].
	generador := Random new.
	1 to: unaGrilla filas do: [ :f |
		1 to: unaGrilla columnas do: [ :c |
			| nuevoEstado |
			nuevoEstado := generador next < unaDensidad
				ifTrue: [ EstadoVivo new ]
				ifFalse: [ EstadoMuerto new ].
			(unaGrilla celulaEnFila: f columna: c) cambiarEstadoA: nuevoEstado ] ]
]

{ #category : 'validation' }
GeneradorPatrones >> validarGrilla: unaGrilla [

	(unaGrilla isKindOf: Grilla)
		ifFalse: [ DomainError signal: 'Se esperaba una instancia valida de Grilla.' ]
]
