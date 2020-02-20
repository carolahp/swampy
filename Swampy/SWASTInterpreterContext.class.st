Class {
	#name : #SWASTInterpreterContext,
	#superclass : #SWInterpreterPharoContext,
	#category : #Swampy
}

{ #category : #'debugger-api' }
SWASTInterpreterContext >> icon [

	^ self iconNamed: #smallObjects
]
