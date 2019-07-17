Class {
	#name : #SWASTInterpreterContext,
	#superclass : #SWInterpreterContext,
	#category : #Swampy
}

{ #category : #'debugger-api' }
SWASTInterpreterContext >> icon [

	^ self iconNamed: #smallObjects
]
