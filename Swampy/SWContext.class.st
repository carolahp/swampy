Class {
	#name : #SWContext,
	#superclass : #Object,
	#instVars : [
		'context',
		'parent'
	],
	#category : #Swampy
}

{ #category : #'instance creation' }
SWContext class >> on: aContext [ 

	^ self new
		context: aContext;
		yourself
]

{ #category : #'instance creation' }
SWContext class >> on: aNativeContext parent: aSWContext [

	^ self new
		context: aNativeContext;
		parent: aSWContext;
		yourself
]

{ #category : #'debugger-api' }
SWContext >> asString [

	^ context asString
]

{ #category : #accessing }
SWContext >> context: aContext [ 
	context := aContext
]

{ #category : #stepping }
SWContext >> doStepInto [

	self subclassResponsibility
]

{ #category : #accessing }
SWContext >> home [

	self subclassResponsibility
]

{ #category : #'debugger-api' }
SWContext >> icon [

	^ self subclassResponsibility
]

{ #category : #accessing }
SWContext >> lookupNativeContext: aNativeContext ifAbsent: aBlock [

	aNativeContext = context
		ifTrue: [ ^ self ].
	
	parent ifNil: [ ^ aBlock value ].
	^ parent lookupNativeContext: aNativeContext ifAbsent: aBlock
]

{ #category : #accessing }
SWContext >> mapContext: aContext [

	aContext ifNil: [ ^ parent ].

	^ self
		lookupNativeContext: aContext
		ifAbsent: [ 
			self newContextOn: aContext" parent: (self mapContext: aContext sender) "]
]

{ #category : #accessing }
SWContext >> namedTempAt: anInteger [ 

	self subclassResponsibility
]

{ #category : #accessing }
SWContext >> newContextOn: aContext [

	^ self newContextOn: aContext parent: self
]

{ #category : #accessing }
SWContext >> newContextOn: aContext parent: aParentContext [

	self subclassResponsibility
]

{ #category : #accessing }
SWContext >> newMetaContextOn: aContext [

	self subclassResponsibility
]

{ #category : #accessing }
SWContext >> parent [
	^ parent
]

{ #category : #accessing }
SWContext >> parent: anObject [
	parent := anObject
]

{ #category : #stepping }
SWContext >> push: aValue [

	context push: aValue
]

{ #category : #accessing }
SWContext >> receiver [

	self subclassResponsibility
]

{ #category : #accessing }
SWContext >> stack [

	^ parent
		ifNil: [ { self } ]
		ifNotNil: [ { self }, parent stack ]
]

{ #category : #accessing }
SWContext >> stepInto [

	^ self mapContext: self doStepInto
]

{ #category : #stepping }
SWContext >> stepIntoInterpreter [

	| method newNativeContext |
	method := self class lookupSelector: #doStepInto.
	newNativeContext := (Context newForMethod: method)
		setSender: nil
		receiver: self
		method: method
		closure: nil
		startpc: method initialPC;
		privRefresh.

	^ self newMetaContextOn: newNativeContext
]

{ #category : #stepping }
SWContext >> stepOver [

	| steppedContext |
	steppedContext := context.
	steppedContext := self doStepInto.
	[ steppedContext ~= context
		and: [ steppedContext ~= context sender ] ]
			whileTrue: [ steppedContext := self doStepInto ].
	^ self mapContext: steppedContext
]

{ #category : #accessing }
SWContext >> tempNames [

	^ self subclassResponsibility
]

{ #category : #accessing }
SWContext >> top [

	^ context top
]
