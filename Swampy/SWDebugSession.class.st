Class {
	#name : #SWDebugSession,
	#superclass : #Object,
	#instVars : [
		'currentContext'
	],
	#category : #Swampy
}

{ #category : #debugging }
SWDebugSession class >> debug: anExpression [

	^ self onContext: (SWPharoASTContext fromDebugSession: (DASTSession debug: anExpression))
]

{ #category : #debugging }
SWDebugSession class >> debugVM: aVM [

	^ self onContext: (SWPharoVMContext fromInitialContextOfVM: aVM)
]

{ #category : #debugging }
SWDebugSession class >> onContext: aContext [

	^ self new
		initializeWithContext: aContext;
		yourself
]

{ #category : #accessing }
SWDebugSession >> currentContext [

	^ currentContext
]

{ #category : #initialization }
SWDebugSession >> initializeWithContext: aContext [

	currentContext := aContext
]

{ #category : #initialization }
SWDebugSession >> initializeWithExpression: aString [ 

	currentContext := SWPharoASTContext fromDebugSession: (DASTSession debug: aString)
]

{ #category : #accessing }
SWDebugSession >> stack [

	^ currentContext stack
]

{ #category : #stepping }
SWDebugSession >> step: aBlock [

	currentContext := aBlock
		on: Halt
		do: [ :ex |
			(ex signalerContext copyTo: thisContext home) stack reversed
				inject: (currentContext mapContext: currentContext vm framePointer)
				into: [ :accum :each | 
					(currentContext newMetaContextOn: each)
						parent: accum;
						yourself ] ]
]

{ #category : #stepping }
SWDebugSession >> stepInto [

	self step: [ currentContext stepInto ]
]

{ #category : #stepping }
SWDebugSession >> stepIntoInterpreter [

	self step: [ currentContext stepIntoInterpreter ]
]

{ #category : #stepping }
SWDebugSession >> stepOver [
	
	self step: [ currentContext stepOver ]
]
