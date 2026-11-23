"
Estrategia de vecindad para grillas acotadas con bordes rigidos. Calcula la vecindad de Moore de una celula descartando cualquier coordenada que caiga fuera del rango valido [1..filas, 1..columnas].
"
Class {
	#name : 'TopologiaAcotada',
	#superclass : 'TopologiaGrilla',
	#category : 'JuegoDeLaVida-Model'
}

{ #category : 'querying' }
TopologiaAcotada >> vecinosDe: unaCelula en: unaGrilla [

	| vecinos |
	vecinos := OrderedCollection new.
	self desplazamientosMoore do: [ :delta |
		| filaVecina columnaVecina |
		filaVecina := unaCelula fila + delta x.
		columnaVecina := unaCelula columna + delta y.
		(unaGrilla esCoordenadaValidaFila: filaVecina columna: columnaVecina)
			ifTrue: [
				vecinos add:
					(unaGrilla celulaEnFila: filaVecina columna: columnaVecina) ] ].
	^ vecinos
]
