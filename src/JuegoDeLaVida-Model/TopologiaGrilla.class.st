"
Clase abstracta que define el protocolo del patron Strategy para calcular la vecindad de Moore (hasta 8 celdas adyacentes) de una Celula dentro de una Grilla. Sus subclases implementan el comportamiento para bordes rigidos (TopologiaAcotada) o bordes conectados ciclicamente (TopologiaToroidal).
"
Class {
	#name : 'TopologiaGrilla',
	#superclass : 'Object',
	#category : 'JuegoDeLaVida-Model'
}

{ #category : 'geometry' }
TopologiaGrilla >> desplazamientosMoore [

	^ {
		(-1 @ -1) .
		(-1 @ 0) .
		(-1 @ 1) .
		(0 @ -1) .
		(0 @ 1) .
		(1 @ -1) .
		(1 @ 0) .
		(1 @ 1)
	}
]

{ #category : 'querying' }
TopologiaGrilla >> vecinosDe: unaCelula en: unaGrilla [

	^ self subclassResponsibility
]
