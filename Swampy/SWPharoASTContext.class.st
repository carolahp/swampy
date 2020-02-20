Class {
	#name : #SWPharoASTContext,
	#superclass : #SWContext,
	#instVars : [
		'debugSession'
	],
	#category : #Swampy
}

{ #category : #'instance creation' }
SWPharoASTContext class >> fromDebugSession: aDASTSession [ 

	^ self
		fromDebugSession: aDASTSession
		context: aDASTSession interruptedContext
]

{ #category : #'instance creation' }
SWPharoASTContext class >> fromDebugSession: aDASTSession context: aContext [

	^ self
		fromDebugSession: aDASTSession
		context: aContext
		parent: nil
]

{ #category : #'instance creation' }
SWPharoASTContext class >> fromDebugSession: aDASTSession context: aContext parent: aParent [

	^ self new
		debugSession: aDASTSession;
		context: aContext;
		parent: aParent;
		yourself
]

{ #category : #accessing }
SWPharoASTContext >> debugSession: aDASTSession [

	debugSession := aDASTSession
]

{ #category : #stepping }
SWPharoASTContext >> doStepInto [
	
	^ debugSession interpreter stepInto
]

{ #category : #'debugging-api' }
SWPharoASTContext >> highlightInterval [

	^ context nodes
		ifEmpty: [ 1 to: 0 ]
		ifNotEmpty: [ :nodeStack | nodeStack top start to: nodeStack top stop ]
]

{ #category : #'debugger-api' }
SWPharoASTContext >> icon [

	^ self iconNamed: #blankIcon
]

{ #category : #accessing }
SWPharoASTContext >> method [

	^ context method
]

{ #category : #stepping }
SWPharoASTContext >> newContextOn: aContext [

	^ SWPharoASTContext fromDebugSession: debugSession context: aContext parent: self
]

{ #category : #stepping }
SWPharoASTContext >> newContextOn: aContext parent: aParentContext [

	^ SWPharoASTContext fromDebugSession: debugSession context: aContext parent: aParentContext
]

{ #category : #stepping }
SWPharoASTContext >> newMetaContextOn: aContext [

	^ SWASTInterpreterContext
		on: aContext
		parent: self
]
