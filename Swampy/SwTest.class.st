Class {
	#name : #SwTest,
	#superclass : #TestCase,
	#category : #'Swampy-Tests'
}

{ #category : #tests }
SwTest >> message1 [

	self message2
]

{ #category : #tests }
SwTest >> message2 [

	self message3
]

{ #category : #tests }
SwTest >> newInterpreter: aContext [

	^ SWDebugSession onContext: (SWContextFailingStep on: aContext)
]

{ #category : #tests }
SwTest >> newInterpreterOnMethod: aMethod [ 

	| newNativeContext |
	newNativeContext := (Context newForMethod: aMethod)
		setSender: nil
		receiver: self
		method: aMethod
		closure: nil
		startpc: aMethod initialPC;
		privRefresh.
		
	^ self newInterpreter: newNativeContext
]

{ #category : #tests }
SwTest >> testDefaultNewContextHasSelfReceiver [

	| interpreter |
	interpreter := self newInterpreterOnMethod: (self class >> #message1).

	self
		assert: interpreter stack  first receiver
		equals: self
]

{ #category : #tests }
SwTest >> testDefaultNewContextIsNotInterpreterOnReceiverSelf [

	| interpreter |
	interpreter := self newInterpreterOnMethod: (self class >> #message1).

	self deny: (interpreter stack  first isInterpreterOnReceiver: self)
]

{ #category : #tests }
SwTest >> testDiveIntoMessageSendActivatesNewMetaContext [

	| interpreter |
	interpreter := self newInterpreterOnMethod: (self class >> #message1).
	interpreter stepOver. "Stepping the push of SWTestClass".
	
	interpreter stepIntoInterpreter.
	
	self
		assert: (interpreter stack collect: [ :each | each method selector ])
		equals: #( doStepInto message1 )
]

{ #category : #tests }
SwTest >> testDiveIntoMessageSendActivatesNewMetaContextWithInterpreterReceiver [

	| interpreter |
	interpreter := self newInterpreterOnMethod: (self class >> #message1).
	interpreter stepOver. "Stepping the push of SWTestClass".
	
	interpreter stepIntoInterpreter.
	
	self assert: (interpreter stack first isInterpreterOnReceiver: self)
]

{ #category : #tests }
SwTest >> testStepIntoMessageSendActivatesNewContext [

	| interpreter |
	interpreter := self newInterpreterOnMethod: (self class >> #message1).
	interpreter stepOver. "Stepping the push of SWTestClass".
	
	interpreter stepInto.
	
	self
		assert: (interpreter stack collect: [ :each | each method selector ])
		equals: #( message2 message1 )
]

{ #category : #tests }
SwTest >> testStepIntoMessageSendOnFailingInterpreterShouldDiveIntoUpToError [

	| interpreter |
	interpreter := self newInterpreterOnMethod: (self class >> #message1).
	interpreter stepOver. "Stepping the push of SWTestClass".
	
	interpreter stack first failNextStep.
	interpreter stepInto.
	
	self
		assert: (interpreter stack collect: [ :each | each method selector ])
		equals: #( message2 message1 )
]
