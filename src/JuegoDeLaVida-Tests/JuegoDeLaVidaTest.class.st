"
Suite de pruebas unitarias (SUnit) para verificar el comportamiento del modelo del Juego de la Vida de Conway con estado de latencia, topologias acotada y toroidal, actualizacion sincrona, patrones clasicos y manejo controlado de errores.
"
Class {
	#name : 'JuegoDeLaVidaTest',
	#superclass : 'TestCase',
	#category : 'JuegoDeLaVida-Tests'
}

{ #category : 'tests' }
JuegoDeLaVidaTest >> testBlinkerOscilaEnDosGeneracionesActualizacionSincrona [

	| simulador generador grilla |
	simulador := SimuladorVida new.
	simulador iniciarConFilas: 5 columnas: 5 topologia: TopologiaAcotada new.
	grilla := simulador grillaActual.
	generador := GeneradorPatrones new.
	generador cargarBlinkerEn: grilla origen: 3 @ 2.

	self assert: simulador poblacionActual equals: 3.
	self assert: (grilla celulaEnFila: 3 columna: 2) estaViva.
	self assert: (grilla celulaEnFila: 3 columna: 3) estaViva.
	self assert: (grilla celulaEnFila: 3 columna: 4) estaViva.

	simulador avanzarGeneracion.
	self assert: simulador generacion equals: 1.
	self assert: simulador poblacionActual equals: 3.
	self assert: (grilla celulaEnFila: 2 columna: 3) estaViva.
	self assert: (grilla celulaEnFila: 3 columna: 3) estaViva.
	self assert: (grilla celulaEnFila: 4 columna: 3) estaViva.
	self assert: (grilla celulaEnFila: 3 columna: 2) estaLatente.
	self assert: (grilla celulaEnFila: 3 columna: 4) estaLatente.

	simulador avanzarGeneracion.
	self assert: simulador generacion equals: 2.
	self assert: simulador poblacionActual equals: 3.
	self assert: (grilla celulaEnFila: 3 columna: 2) estaViva.
	self assert: (grilla celulaEnFila: 3 columna: 3) estaViva.
	self assert: (grilla celulaEnFila: 3 columna: 4) estaViva.
	self assert: (grilla celulaEnFila: 2 columna: 3) estaLatente.
	self assert: (grilla celulaEnFila: 4 columna: 3) estaLatente.
	self
		assert: simulador historialPoblacion
		equals: #(0 3 3) asOrderedCollection
]

{ #category : 'tests' }
JuegoDeLaVidaTest >> testBlockPermaneceEstable [

	| simulador generador grilla |
	simulador := SimuladorVida new.
	simulador iniciarConFilas: 4 columnas: 4 topologia: TopologiaAcotada new.
	grilla := simulador grillaActual.
	generador := GeneradorPatrones new.
	generador cargarBlockEn: grilla origen: 2 @ 2.

	simulador ejecutarGeneraciones: 4.
	self assert: simulador generacion equals: 4.
	self assert: simulador poblacionActual equals: 4.
	self assert: (grilla celulaEnFila: 2 columna: 2) estaViva.
	self assert: (grilla celulaEnFila: 2 columna: 3) estaViva.
	self assert: (grilla celulaEnFila: 3 columna: 2) estaViva.
	self assert: (grilla celulaEnFila: 3 columna: 3) estaViva
]

{ #category : 'tests' }
JuegoDeLaVidaTest >> testCambioDeTopologiaEnTiempoDeEjecucion [

	| simulador grilla |
	simulador := SimuladorVida new.
	simulador iniciarConFilas: 3 columnas: 3 topologia: TopologiaAcotada new.
	grilla := simulador grillaActual.
	(grilla celulaEnFila: 1 columna: 3) cambiarEstadoA: EstadoVivo new.
	(grilla celulaEnFila: 3 columna: 1) cambiarEstadoA: EstadoVivo new.
	(grilla celulaEnFila: 3 columna: 3) cambiarEstadoA: EstadoVivo new.

	self
		assert: (grilla contarVecinosVivosDe: (grilla celulaEnFila: 1 columna: 1))
		equals: 0.

	simulador cambiarTopologiaA: TopologiaToroidal new.
	self
		assert: (grilla topologia isKindOf: TopologiaToroidal).
	self
		assert: (grilla contarVecinosVivosDe: (grilla celulaEnFila: 1 columna: 1))
		equals: 3
]

{ #category : 'tests' }
JuegoDeLaVidaTest >> testDiferenciaVecinosEnEsquinaEntreAcotadaYToroidal [

	| grillaAcotada grillaToroidal esquinaAcotada esquinaToroidal |
	grillaAcotada := Grilla
		filas: 4
		columnas: 4
		topologia: TopologiaAcotada new.
	grillaToroidal := Grilla
		filas: 4
		columnas: 4
		topologia: TopologiaToroidal new.

	{ grillaAcotada . grillaToroidal } do: [ :grilla |
		(grilla celulaEnFila: 1 columna: 4) cambiarEstadoA: EstadoVivo new.
		(grilla celulaEnFila: 4 columna: 1) cambiarEstadoA: EstadoVivo new.
		(grilla celulaEnFila: 4 columna: 4) cambiarEstadoA: EstadoVivo new ].

	esquinaAcotada := grillaAcotada celulaEnFila: 1 columna: 1.
	esquinaToroidal := grillaToroidal celulaEnFila: 1 columna: 1.

	self
		assert: (TopologiaAcotada new vecinosDe: esquinaAcotada en: grillaAcotada) size
		equals: 3.
	self
		assert: (TopologiaToroidal new vecinosDe: esquinaToroidal en: grillaToroidal) size
		equals: 8.
	self
		assert: (grillaAcotada contarVecinosVivosDe: esquinaAcotada)
		equals: 0.
	self
		assert: (grillaToroidal contarVecinosVivosDe: esquinaToroidal)
		equals: 3
]

{ #category : 'tests' }
JuegoDeLaVidaTest >> testEjecutarMultiplesGeneracionesYHistorial [

	| simulador generador |
	simulador := SimuladorVida new.
	simulador iniciarConFilas: 5 columnas: 5 topologia: TopologiaAcotada new.
	generador := GeneradorPatrones new.
	generador cargarBlockEn: simulador grillaActual origen: 2 @ 2.

	simulador ejecutarGeneraciones: 3.
	self assert: simulador generacion equals: 3.
	self
		assert: simulador historialPoblacion
		equals: #(0 4 4 4) asOrderedCollection
]

{ #category : 'tests' }
JuegoDeLaVidaTest >> testErroresParametrosInvalidos [

	| simulador grilla |
	simulador := SimuladorVida new.
	self should: [ simulador avanzarGeneracion ] raise: DomainError.
	self should: [ simulador poblacionActual ] raise: DomainError.

	self
		should: [
			Grilla filas: 0 columnas: 5 topologia: TopologiaAcotada new ]
		raise: DomainError.
	self
		should: [
			Grilla filas: 5 columnas: -2 topologia: TopologiaAcotada new ]
		raise: DomainError.
	self
		should: [ Grilla filas: 5 columnas: 5 topologia: Object new ]
		raise: DomainError.

	grilla := Grilla filas: 4 columnas: 4 topologia: TopologiaAcotada new.
	self should: [ grilla celulaEnFila: 0 columna: 1 ] raise: DomainError.
	self should: [ grilla celulaEnFila: 5 columna: 2 ] raise: DomainError.
	self should: [ grilla celulaEnFila: 2 columna: 5 ] raise: DomainError.

	self
		should: [ GeneradorPatrones new poblarAleatorio: grilla densidad: -0.1 ]
		raise: DomainError.
	self
		should: [ GeneradorPatrones new poblarAleatorio: grilla densidad: 1.5 ]
		raise: DomainError.
	self
		should: [ GeneradorPatrones new cargarGliderEn: grilla origen: 3 @ 3 ]
		raise: DomainError.

	simulador iniciarConFilas: 4 columnas: 4 topologia: TopologiaAcotada new.
	self should: [ simulador ejecutarGeneraciones: -1 ] raise: DomainError.
	self
		should: [ (grilla celulaEnFila: 1 columna: 1) cambiarEstadoA: Object new ]
		raise: DomainError.
	self
		should: [ EstadoVivo new siguienteEstadoConVecinos: -1 ]
		raise: DomainError
]

{ #category : 'tests' }
JuegoDeLaVidaTest >> testGliderCruzaBordeEnTopologiaToroidal [

	| simToroidal simAcotada generador |
	simToroidal := SimuladorVida new.
	simToroidal iniciarConFilas: 5 columnas: 5 topologia: TopologiaToroidal new.
	simAcotada := SimuladorVida new.
	simAcotada iniciarConFilas: 5 columnas: 5 topologia: TopologiaAcotada new.

	generador := GeneradorPatrones new.
	generador cargarGliderEn: simToroidal grillaActual origen: 3 @ 3.
	generador cargarGliderEn: simAcotada grillaActual origen: 3 @ 3.

	simToroidal avanzarGeneracion.
	simAcotada avanzarGeneracion.

	self assert: (simToroidal grillaActual celulaEnFila: 1 columna: 4) estaViva.
	self deny: (simAcotada grillaActual celulaEnFila: 1 columna: 4) estaViva
]

{ #category : 'tests' }
JuegoDeLaVidaTest >> testMuerteDefinitivaDesdeEstadoLatente [

	| celula |
	celula := Celula fila: 1 columna: 1 estado: EstadoLatente new.
	celula evolucionarConVecinos: 0.
	self deny: celula estaViva.
	self deny: celula estaLatente.
	self assert: (celula estado isKindOf: EstadoMuerto).

	celula cambiarEstadoA: EstadoLatente new.
	celula evolucionarConVecinos: 1.
	self assert: (celula estado isKindOf: EstadoMuerto).

	celula cambiarEstadoA: EstadoLatente new.
	celula evolucionarConVecinos: 4.
	self assert: (celula estado isKindOf: EstadoMuerto)
]

{ #category : 'tests' }
JuegoDeLaVidaTest >> testNacimientoConTresVecinos [

	| celula |
	celula := Celula fila: 2 columna: 2 estado: EstadoMuerto new.
	self deny: celula estaViva.
	self assert: celula aporteVecindad equals: 0.

	celula evolucionarConVecinos: 2.
	self deny: celula estaViva.
	self assert: (celula estado isKindOf: EstadoMuerto).

	celula evolucionarConVecinos: 3.
	self assert: celula estaViva.
	self assert: celula aporteVecindad equals: 1
]

{ #category : 'tests' }
JuegoDeLaVidaTest >> testPoblarAleatorioConDensidadesExtremas [

	| grilla generador |
	grilla := Grilla filas: 5 columnas: 5 topologia: TopologiaAcotada new.
	generador := GeneradorPatrones new.

	generador poblarAleatorio: grilla densidad: 1.0.
	self assert: grilla cantidadVivas equals: 25.

	generador poblarAleatorio: grilla densidad: 0.0.
	self assert: grilla cantidadVivas equals: 0
]

{ #category : 'tests' }
JuegoDeLaVidaTest >> testReactivacionDesdeEstadoLatente [

	| celula |
	celula := Celula fila: 1 columna: 1 estado: EstadoLatente new.
	self deny: celula estaViva.
	self assert: celula estaLatente.
	self assert: celula aporteVecindad equals: 0.

	celula evolucionarConVecinos: 2.
	self assert: celula estaViva.
	self deny: celula estaLatente.

	celula cambiarEstadoA: EstadoLatente new.
	celula evolucionarConVecinos: 3.
	self assert: celula estaViva
]

{ #category : 'tests' }
JuegoDeLaVidaTest >> testSupervivenciaConDosYTresVecinos [

	| celula |
	celula := Celula fila: 1 columna: 1 estado: EstadoVivo new.
	self assert: celula estaViva.
	self assert: celula aporteVecindad equals: 1.

	celula evolucionarConVecinos: 2.
	self assert: celula estaViva.

	celula evolucionarConVecinos: 3.
	self assert: celula estaViva
]

{ #category : 'tests' }
JuegoDeLaVidaTest >> testTransicionALatentePorSubpoblacionYSuperpoblacion [

	| celulaSub celulaSuper |
	celulaSub := Celula fila: 1 columna: 1 estado: EstadoVivo new.
	celulaSub evolucionarConVecinos: 1.
	self deny: celulaSub estaViva.
	self assert: celulaSub estaLatente.
	self assert: celulaSub aporteVecindad equals: 0.

	celulaSuper := Celula fila: 1 columna: 2 estado: EstadoVivo new.
	celulaSuper evolucionarConVecinos: 4.
	self deny: celulaSuper estaViva.
	self assert: celulaSuper estaLatente.
	self assert: celulaSuper aporteVecindad equals: 0
]
