"
Example of usage:
SWDebugger basicNew 	debugSession: (SWDebugSession onContext: (SWBytecodeInterpreterContext on: [ OrderedCollection new ] asContext) );
	initialize;
	openWithSpec
"
Class {
	#name : #SWDebugger,
	#superclass : #ComposablePresenter,
	#instVars : [
		'stack',
		'codePane',
		'debugSession',
		'stepIntoButton',
		'stepIntoInterpreterButton',
		'stepOverButton'
	],
	#category : #Swampy
}

{ #category : #specs }
SWDebugger class >> defaultSpec [

	^ SpecLayout composed newColumn: [:col|
		col
			newRow: [ :row |
				row newColumn: [ :c2 | ].
				row add: #stepOverButton width: 100.
				row add: #stepIntoButton width: 100.
				row add: #stepIntoInterpreterButton width: 130 ]
			height: 30.
		col add: #stack.
		col add: #codePane ]
]

{ #category : #accessing }
SWDebugger >> codePane [
	^ codePane
]

{ #category : #accessing }
SWDebugger >> codePane: anObject [
	codePane := anObject
]

{ #category : #events }
SWDebugger >> contextSelected: aContext [

	codePane
		text: aContext method sourceCode;
		behavior: aContext method methodClass;
		"doItReceiver: aContext home receiver;"
		doItContext: aContext;
		highlightNextIntructionInterval: aContext highlightInterval
]

{ #category : #accessing }
SWDebugger >> debugSession [
	^ debugSession
]

{ #category : #accessing }
SWDebugger >> debugSession: aDASTSession [ 

	debugSession := aDASTSession
]

{ #category : #initialization }
SWDebugger >> initialExtent [

	^ 800@600
]

{ #category : #initialization }
SWDebugger >> initializePresenter [

	stack whenSelectedItemChanged: [ :selectedItem |
		selectedItem ifNotNil: [ self contextSelected: selectedItem] ].

	stepIntoButton action: [ self stepInto ].
	stepIntoInterpreterButton action: [ self stepIntoInterpreter ].
	stepOverButton action: [ self stepOver ].
	
	self refreshStack.
]

{ #category : #initialization }
SWDebugger >> initializeWidgets [
	
	stack := self newList.
	stack displayBlock: [ :e | e asString ].
	stack icons: [ :e | e icon ].

	codePane := self newCode.
	codePane aboutToStyle: true.

	stepIntoButton := self newButton.
	stepIntoButton label: 'Step Into'.
	
	stepIntoInterpreterButton := self newButton.
	stepIntoInterpreterButton label: 'Step Into Interpreter'.
	
	stepOverButton := self newButton.
	stepOverButton label: 'Step Over'.
]

{ #category : #refreshing }
SWDebugger >> refreshStack [

	stack items: debugSession stack.
	stack setSelectedItem: stack listItems first
]

{ #category : #accessing }
SWDebugger >> setModelBeforeInitialization: aModel [

	self debugSession: aModel
]

{ #category : #accessing }
SWDebugger >> stack [
	^ stack
]

{ #category : #accessing }
SWDebugger >> stack: anObject [
	stack := anObject
]

{ #category : #actions }
SWDebugger >> stepInto [

	debugSession stepInto.
	self refreshStack.
]

{ #category : #accessing }
SWDebugger >> stepIntoButton [
	^ stepIntoButton
]

{ #category : #accessing }
SWDebugger >> stepIntoButton: anObject [
	stepIntoButton := anObject
]

{ #category : #actions }
SWDebugger >> stepIntoInterpreter [
	
	debugSession stepIntoInterpreter.
	self refreshStack.
]

{ #category : #accessing }
SWDebugger >> stepIntoInterpreterButton [
	^ stepIntoInterpreterButton
]

{ #category : #accessing }
SWDebugger >> stepIntoInterpreterButton: anObject [
	stepIntoInterpreterButton := anObject
]

{ #category : #actions }
SWDebugger >> stepOver [

	debugSession stepOver.
	self refreshStack.
]

{ #category : #accessing }
SWDebugger >> stepOverButton [
	^ stepOverButton
]

{ #category : #accessing }
SWDebugger >> stepOverButton: anObject [
	stepOverButton := anObject
]
