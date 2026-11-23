"Script para importar, probar y abrir el proyecto Juego de la Vida en un Playground de Pharo 13.
Ajusta 'rutaRepo' si moviste la carpeta del proyecto antes de ejecutar (Do it / Ctrl+D)."

| rutaRepo srcDir |
rutaRepo := 'c:\Users\ianch\Universidad\UTN FRRe\2do año\Paradigmas\TPI\Código' asFileReference.
srcDir := rutaRepo / 'src'.

{ 'JuegoDeLaVida-Model' . 'JuegoDeLaVida-Tests' . 'JuegoDeLaVida-UI' } do: [ :nombrePaquete |
	| repo version |
	repo := TonelRepository new directory: srcDir.
	version := repo loadVersionFromFileNamed: nombrePaquete.
	version load ].

"Ejecutar toda la suite de pruebas SUnit e inspeccionar el resultado:"
(JuegoDeLaVidaTest suite run) inspect.

"Abrir la interfaz grafica del simulador:"
VistaSimulador abrir.
