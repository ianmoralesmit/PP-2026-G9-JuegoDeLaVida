"
Estrategia de vecindad para grillas toroidales. Conecta los bordes opuestos horizontal y verticalmente mediante aritmetica modular en base 1, devolviendo siempre 8 celulas vecinas.
"
Class {
	#name : 'TopologiaToroidal',
	#superclass : 'TopologiaGrilla',
	#category : 'JuegoDeLaVida-Model'
}

{ #category : 'querying' }
TopologiaToroidal >> vecinosDe: unaCelula en: unaGrilla [

	| filas columnas |
	filas := unaGrilla filas.
	columnas := unaGrilla columnas.
	^ self desplazamientosMoore collect: [ :delta |
		| filaVecina columnaVecina |
		filaVecina := ((unaCelula fila - 1 + delta x) \\ filas) + 1.
		columnaVecina := ((unaCelula columna - 1 + delta y) \\ columnas) + 1.
		unaGrilla celulaEnFila: filaVecina columna: columnaVecina ]
]
