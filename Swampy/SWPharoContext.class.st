Class {
	#name : #SWPharoContext,
	#superclass : #SWContext,
	#category : #Swampy
}

{ #category : #accessing }
SWPharoContext >> doStepInto [

	^ context step
]

{ #category : #'debugger-api' }
SWPharoContext >> highlightInterval [
	
	(context isDead) ifTrue: [ ^ 1 to: 0 ].
	^ context debuggerMap
		rangeForPC: context pc
		contextIsActiveContext: true
]

{ #category : #accessing }
SWPharoContext >> home [

	^ self mapContext: context home
]

{ #category : #'debugger-api' }
SWPharoContext >> icon [

	^ self iconNamed: #smallCogInitialState
]

{ #category : #accessing }
SWPharoContext >> method [

	^ context method
]

{ #category : #accessing }
SWPharoContext >> namedTempAt: anInteger [ 

	^ context namedTempAt: anInteger 
]

{ #category : #accessing }
SWPharoContext >> namedTempAt: index put: aValue [
	"Set the value of the temp at index in the receiver's sequence of tempNames.
	 (Note that if the value is a copied value it is also set out along the lexical chain,
	  but alas not in along the lexical chain.)."
	^context debuggerMap namedTempAt: index put: aValue in: context
]

{ #category : #accessing }
SWPharoContext >> newContextOn: aContext [

	^ self class on: aContext parent: self
]

{ #category : #accessing }
SWPharoContext >> newContextOn: aContext parent: aParentContext [

	^ self class on: aContext parent: aParentContext
]

{ #category : #accessing }
SWPharoContext >> newMetaContextOn: aContext [

	^ SWBytecodeInterpreterContext
		on: aContext
		parent: self
]

{ #category : #accessing }
SWPharoContext >> nodes [
	self shouldBeImplemented.
]

{ #category : #accessing }
SWPharoContext >> receiver [

	^ context receiver
]

{ #category : #accessing }
SWPharoContext >> stepOver [

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
SWPharoContext >> tempNames [

	^ context tempNames
]
