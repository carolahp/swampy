Class {
	#name : #SWObjectVariablesBrowser,
	#superclass : #SWRawObjectVariablesBrowser,
	#category : #'Swampy-Inspector'
}

{ #category : #'private building' }
SWObjectVariablesBrowser >> basicVariableNodesFor: anObject in: aCollection [

	^ anObject gtInspectorVariableNodesIn: aCollection 
]

{ #category : #'private building' }
SWObjectVariablesBrowser >> printArray: anArray [
	"The #printString method of an array needs to scan through the entire array to
	determine how to print the array. Only scan through a limited number of elements
	for large arrays."
	| limitedString limit |
	limit := 50000.
	limitedString := String streamContents: [ :aStream | 
		anArray gtInspectorFastPrintOn: aStream.
	] limitedTo: limit.
	limitedString size < limit ifTrue: [^ limitedString].
	^ limitedString , '...etc...'
	
	
]

{ #category : #'private building' }
SWObjectVariablesBrowser >> printStringOf: anObject [ 
	^ ["Treat arrays differently as their #printString method can be slow.
		In the future if multiple objects need to be handled differenty,
		dispatch through the object."
		((anObject class == Array  
			ifTrue: [ self printArray: anObject ]
			ifFalse: [ anObject printString ]) contractTo: 200) asComment] 
		on: Error 
		do: ['"Error printing. Try self printString to debug"']
]
