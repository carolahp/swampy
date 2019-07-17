Class {
	#name : #SWInterpreterContext,
	#superclass : #SWContext,
	#category : #Swampy
}

{ #category : #accessing }
SWInterpreterContext >> doStepInto [

	^ context step
]

{ #category : #'debugger-api' }
SWInterpreterContext >> highlightInterval [
	
	(context isDead) ifTrue: [ ^ 1 to: 0 ].
	^ context debuggerMap
		rangeForPC: context pc
		contextIsActiveContext: true
]

{ #category : #accessing }
SWInterpreterContext >> home [

	^ self mapContext: context home
]

{ #category : #'debugger-api' }
SWInterpreterContext >> icon [

	^ self iconNamed: #smallCogInitialState
]

{ #category : #accessing }
SWInterpreterContext >> method [

	^ context method
]

{ #category : #accessing }
SWInterpreterContext >> namedTempAt: anInteger [ 

	^ context namedTempAt: anInteger 
]

{ #category : #accessing }
SWInterpreterContext >> namedTempAt: index put: aValue [
	"Set the value of the temp at index in the receiver's sequence of tempNames.
	 (Note that if the value is a copied value it is also set out along the lexical chain,
	  but alas not in along the lexical chain.)."
	^context debuggerMap namedTempAt: index put: aValue in: context
]

{ #category : #accessing }
SWInterpreterContext >> newContextOn: aContext [

	^ self class on: aContext parent: self
]

{ #category : #accessing }
SWInterpreterContext >> newContextOn: aContext parent: aParentContext [

	^ self class on: aContext parent: aParentContext
]

{ #category : #accessing }
SWInterpreterContext >> newMetaContextOn: aContext [

	^ SWBytecodeInterpreterContext
		on: aContext
		parent: self
]

{ #category : #accessing }
SWInterpreterContext >> nodes [
	self shouldBeImplemented.
]

{ #category : #accessing }
SWInterpreterContext >> receiver [

	^ context receiver
]

{ #category : #accessing }
SWInterpreterContext >> stepOver [

	| steppedContext sender |
	steppedContext := context.
	sender := context sender.
	steppedContext := steppedContext step.
	[ steppedContext ~= context
		and: [ steppedContext ~= sender ] ]
			whileTrue: [ steppedContext := steppedContext step ].
	^ self mapContext: steppedContext
]

{ #category : #accessing }
SWInterpreterContext >> tempNames [

	^ context tempNames
]
