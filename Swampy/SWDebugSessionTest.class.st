Class {
	#name : #SWDebugSessionTest,
	#superclass : #TestCase,
	#category : #Swampy
}

{ #category : #tests }
SWDebugSessionTest >> testStepIntoArgumentPushesIt [

	
	| s |
	s := SWDebugSession debug: '1+2'.
	2 timesRepeat: [ s stepInto ].
	self assert: s currentContext top equals: 2
]

{ #category : #tests }
SWDebugSessionTest >> testStepIntoInterpreterOfArgumentAndOverPushesArgumentToStack [

	
	| s |
	s := SWDebugSession debug: '1+2'.
	1 timesRepeat: [ s stepOver ].
	s stepIntoInterpreter.
	4 timesRepeat: [ s stepOver ].
	self assert: s currentContext top equals: 2
]

{ #category : #tests }
SWDebugSessionTest >> testStepIntoInterpreterOfReceiverAndOverPushesReceiverToStack [

	
	| s |
	s := SWDebugSession debug: '1+2'.
	s stepIntoInterpreter.
	4 timesRepeat: [ s stepOver ].
	self assert: s currentContext top equals: 1
]

{ #category : #tests }
SWDebugSessionTest >> testStepIntoInterpreterOfSumAndOverPushesResultToStack [

	
	| s |
	s := SWDebugSession debug: '1+2'.
	2 timesRepeat: [ s stepInto ].
	s stepIntoInterpreter.
	4 timesRepeat: [ s stepOver ].
	self assert: s currentContext top equals: 3
]

{ #category : #tests }
SWDebugSessionTest >> testStepIntoNativeStackThenOverPopsNativeStack [

	
	| s |
	s := SWDebugSession debug: '1+2'.
	s stepIntoInterpreter.
	2 timesRepeat: [ s stepInto ].
	4 timesRepeat: [ s stepOver ].
	self assert: s currentContext top equals: 3
]

{ #category : #tests }
SWDebugSessionTest >> testStepIntoNativeStackThenOverPushesReturnIntoStack [

	
	| s |
	s := SWDebugSession debug: '1+2'.
	s stepIntoInterpreter.
	2 timesRepeat: [ s stepInto ].
	4 timesRepeat: [ s stepOver ].
	self assert: s currentContext top equals: 3
]

{ #category : #tests }
SWDebugSessionTest >> testStepIntoReceiverPushesIt [

	
	| s |
	s := SWDebugSession debug: '1+2'.
	1 timesRepeat: [ s stepInto ].
	self assert: s currentContext top equals: 1
]

{ #category : #tests }
SWDebugSessionTest >> testStepIntoSumPushesResultToStack [

	
	| s |
	s := SWDebugSession debug: '1+2'.
	3 timesRepeat: [ s stepInto ].
	self assert: s currentContext top equals: 3
]
