Class {
	#name : #SWPharoVMContext,
	#superclass : #SWContext,
	#instVars : [
		'vm'
	],
	#category : #Swampy
}

{ #category : #'instance creation' }
SWPharoVMContext class >> fromInitialContextOfVM: aVM [

	^ self fromVMFramePointer: aVM framePointer inVM: aVM
]

{ #category : #'instance creation' }
SWPharoVMContext class >> fromVMFramePointer: aFramePointer inVM: aVM [

	| sender callerFramePointer |
	"self haltIf: [ 	(aVM stackPages couldBeFramePointer: aFramePointer) not ]."
	callerFramePointer := aVM frameCallerFP: aFramePointer.
	sender := callerFramePointer = 0
		ifFalse: [ self fromVMFramePointer: callerFramePointer inVM: aVM ].
	^ (self on: aFramePointer parent: sender)
		vm: aVM;
		yourself
]

{ #category : #accessing }
SWPharoVMContext >> asString [ 
	
	| receiver methodPointer isBlock methodClassPointer selectorPointer |
	receiver := vm frameReceiver: context.
	methodPointer := vm frameMethodObject: context.
	isBlock := vm frameIsBlockActivation: context.
	methodClassPointer := vm findClassOfMethod: methodPointer forReceiver: receiver.
	selectorPointer := vm findSelectorOfMethod: methodPointer.
	
	^ (0 to: (128 min: (vm objectMemory lengthOf: selectorPointer)))
		collect: [ :index | (vm objectMemory fetchByte: index ofObject: selectorPointer) asCharacter ]
		as: ByteString
]

{ #category : #accessing }
SWPharoVMContext >> context [

	^ context
]

{ #category : #stepping }
SWPharoVMContext >> doStepInto [

	vm singleStep.
	^ vm framePointer
]

{ #category : #'debugger-api' }
SWPharoVMContext >> highlightInterval [

	^ (self class compilerClass debuggerMethodMapForMethod: self method)
		rangeForPC: self pc
		contextIsActiveContext: true
]

{ #category : #accessing }
SWPharoVMContext >> home [

	(vm stackPages couldBeFramePointer: context)
		ifFalse: [ self halt: #notFrame ].

	^ self
]

{ #category : #'debugger-api' }
SWPharoVMContext >> icon [

	^ self iconNamed: #configuration
]

{ #category : #accessing }
SWPharoVMContext >> method [

	| methodPointer selectorPointer selector |
	methodPointer := vm frameMethodObject: context.
	selectorPointer := vm findSelectorOfMethod: methodPointer.
	
	selector := (vm objectMemory stringOf: selectorPointer) asSymbol.

	^ SWVMMethod new
		selector: selector;
		methodPointer: (vm frameMethodObject: context);
		vm: vm;
		yourself
]

{ #category : #accessing }
SWPharoVMContext >> newContextOn: aContext [

	^ (self class on: aContext parent: self)
		vm: vm;
		yourself
]

{ #category : #accessing }
SWPharoVMContext >> newContextOn: aContext parent: aParentContext [

	^ (self class on: aContext parent: aParentContext)
		vm: vm;
		yourself
]

{ #category : #accessing }
SWPharoVMContext >> newMetaContextOn: aContext [

	^ SWBytecodeInterpreterContext
		on: aContext
		parent: self
]

{ #category : #accessing }
SWPharoVMContext >> pc [

	| ip thePage frameAbove |
	context = vm framePointer ifTrue: [ 
		^ (vm instVarNamed: #instructionPointer)
			- (vm frameMethod: context)
			- vm objectMemory baseHeaderSize
			+ 1 ].
	^ 30
]

{ #category : #accessing }
SWPharoVMContext >> receiver [

	^ vm frameReceiver: context
]

{ #category : #'debugger-api' }
SWPharoVMContext >> stepOver [

	| steppedContext sender |

	steppedContext := context.
	sender := parent ifNotNil: #context.
	steppedContext := self doStepInto.
	[ steppedContext ~= context
		and: [ steppedContext ~= sender ] ]
			whileTrue: [ steppedContext := self doStepInto ].
	^ self mapContext: steppedContext
]

{ #category : #accessing }
SWPharoVMContext >> vm [
	
	^ vm
]

{ #category : #accessing }
SWPharoVMContext >> vm: aVM [ 
	vm := aVM
]
