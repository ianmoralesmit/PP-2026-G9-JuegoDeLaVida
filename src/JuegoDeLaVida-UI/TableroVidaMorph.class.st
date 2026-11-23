"
Componente Morphic encargado de renderizar visualmente la grilla bidimensional de celulas diferenciando los estados Vivo, Latente y Muerto mediante colores, y de traducir los clics del usuario en coordenadas (fila, columna) sin acoplar el dominio a la interfaz grafica.
"
Class {
	#name : 'TableroVidaMorph',
	#superclass : 'Morph',
	#instVars : [
		'simulador',
		'coloresPorEstado',
		'alHacerClickEnCelda'
	],
	#category : 'JuegoDeLaVida-UI'
}

{ #category : 'accessing' }
TableroVidaMorph >> alHacerClickEnCelda: unBloque [

	alHacerClickEnCelda := unBloque
]

{ #category : 'drawing' }
TableroVidaMorph >> drawOn: aCanvas [

	| grilla metricas tamCelda origenX origenY colorBorde |
	super drawOn: aCanvas.
	(simulador isNil or: [ simulador grillaActual isNil ])
		ifTrue: [ ^ self ].
	grilla := simulador grillaActual.
	metricas := self metricasTablero.
	tamCelda := metricas at: #tamCelda.
	origenX := metricas at: #origenX.
	origenY := metricas at: #origenY.
	colorBorde := Color fromHexString: 'CBD5E1'.
	1 to: grilla filas do: [ :f |
		1 to: grilla columnas do: [ :c |
			| celula x y rectangulo colorCelda |
			celula := grilla celulaEnFila: f columna: c.
			x := origenX + ((c - 1) * tamCelda).
			y := origenY + ((f - 1) * tamCelda).
			rectangulo := Rectangle origin: x @ y extent: tamCelda @ tamCelda.
			colorCelda := coloresPorEstado
				at: celula estado class
				ifAbsent: [ Color white ].
			aCanvas fillRectangle: rectangulo color: colorCelda.
			tamCelda >= 6
				ifTrue: [
					aCanvas
						frameRectangle: rectangulo
						width: 1
						color: colorBorde ] ] ]
]

{ #category : 'event handling' }
TableroVidaMorph >> handlesMouseDown: anEvent [

	^ true
]

{ #category : 'initialization' }
TableroVidaMorph >> initialize [

	super initialize.
	self color: (Color fromHexString: 'E2E8F0').
	self extent: 520 @ 520.
	coloresPorEstado := Dictionary new
		at: EstadoVivo put: (Color fromHexString: '1B7A3E');
		at: EstadoLatente put: (Color fromHexString: 'E67E22');
		at: EstadoMuerto put: (Color fromHexString: 'F8FAFC');
		yourself
]

{ #category : 'geometry' }
TableroVidaMorph >> metricasTablero [

	| grilla area filas columnas tamCelda anchoTotal altoTotal origenX origenY |
	grilla := simulador grillaActual.
	area := self innerBounds.
	filas := grilla filas.
	columnas := grilla columnas.
	tamCelda := ((area width / columnas) min: (area height / filas)) floor max: 4.
	anchoTotal := tamCelda * columnas.
	altoTotal := tamCelda * filas.
	origenX := area left + ((area width - anchoTotal) // 2).
	origenY := area top + ((area height - altoTotal) // 2).
	^ Dictionary new
		at: #tamCelda put: tamCelda;
		at: #origenX put: origenX;
		at: #origenY put: origenY;
		yourself
]

{ #category : 'event handling' }
TableroVidaMorph >> mouseDown: anEvent [

	| grilla metricas tamCelda origenX origenY posicion fila columna |
	(simulador isNil or: [ simulador grillaActual isNil ])
		ifTrue: [ ^ self ].
	grilla := simulador grillaActual.
	metricas := self metricasTablero.
	tamCelda := metricas at: #tamCelda.
	origenX := metricas at: #origenX.
	origenY := metricas at: #origenY.
	posicion := anEvent position.
	columna := ((posicion x - origenX) // tamCelda) + 1.
	fila := ((posicion y - origenY) // tamCelda) + 1.
	((grilla esCoordenadaValidaFila: fila columna: columna)
		and: [ alHacerClickEnCelda notNil ])
		ifTrue: [ alHacerClickEnCelda value: fila value: columna ]
]

{ #category : 'accessing' }
TableroVidaMorph >> simulador: unSimulador [

	simulador := unSimulador.
	self changed
]
