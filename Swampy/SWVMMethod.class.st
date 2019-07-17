Class {
	#name : #SWVMMethod,
	#superclass : #Object,
	#instVars : [
		'vm',
		'methodPointer',
		'selector'
	],
	#category : #Swampy
}

{ #category : #accessing }
SWVMMethod >> ast [
	
	^ RBParser parseMethod: self sourceCode
]

{ #category : #accessing }
SWVMMethod >> at: index [

	^ (index between: self numLiterals + 1 * vm objectMemory wordSize + 1 and: self size)
		ifTrue: [vm objectMemory fetchByte: index - 1 ofObject: methodPointer]
		ifFalse: [self errorSubscriptBounds: index]
]

{ #category : #accessing }
SWVMMethod >> encoderClass [

	^ EncoderForV3PlusClosures
]

{ #category : #accessing }
SWVMMethod >> endPC [

	^ self trailer endPC
]

{ #category : #accessing }
SWVMMethod >> hasProperty: aString [ 

	^ false
]

{ #category : #accessing }
SWVMMethod >> initialPC [

	^(vm startPCOfMethod: methodPointer) + 1
]

{ #category : #testing }
SWVMMethod >> isPrimitive [
	
	^ self primitiveIndex > 0
]

{ #category : #testing }
SWVMMethod >> isQuick [
	"Answer whether the receiver is a quick return (of self or of an instance 
	variable)."
	^ self primitiveIndex between: 256 and: 519
]

{ #category : #accessing }
SWVMMethod >> literalAt: anInteger [ 

	| literal literalClass literalClassName |
	literal := vm literal: anInteger - 1 ofMethod: methodPointer.
	literalClass := vm objectMemory fetchClassOf: literal.
	literalClassName := vm nameOfClass: literalClass.

	literalClassName = ByteString name
		ifTrue: [ ^ vm stringOf: literal ].	
	literalClassName = ByteSymbol name
		ifTrue: [ ^ (vm stringOf: literal) asSymbol ].
	((self class environment at: literalClassName asSymbol) inheritsFrom: Association)
		ifTrue: [ ^ (vm stringOf: (vm objectMemory fetchPointer: 0 ofObject: literal)) asSymbol -> nil ].
	literalClassName = SmallInteger name
		ifTrue: [ ^ vm objectMemory integerValueOf: literal ].
	literalClassName = Array name
		ifTrue: [ ^ (1 to: (vm objectMemory lengthOf: literal)) collect: [ :i | self halt ] ].
	1halt.
]

{ #category : #accessing }
SWVMMethod >> methodClass [

	| fullname name base |
	fullname := vm nameOfClass: (vm objectMemory fetchClassOf: (vm methodClassOf: methodPointer)).
	name := fullname substrings.
	base := self class environment at: name first asSymbol.
	^ fullname size = 2
		ifTrue: [ base classSide ]
		ifFalse: [ base ]
]

{ #category : #accessing }
SWVMMethod >> methodPointer: anInteger [ 
	methodPointer := anInteger
]

{ #category : #accessing }
SWVMMethod >> numArgs [

	^ vm argumentCountOf: methodPointer
]

{ #category : #accessing }
SWVMMethod >> numLiterals [

	^ vm objectMemory literalCountOf: methodPointer
]

{ #category : #accessing }
SWVMMethod >> numTemps [

	^ vm tempCountOf: methodPointer
]

{ #category : #accessing }
SWVMMethod >> pragmas [

	^ #()
]

{ #category : #acessing }
SWVMMethod >> primitiveIndex [

	^ vm primitiveIndexOf: methodPointer
]

{ #category : #accessing }
SWVMMethod >> propertyAt: aName [

	^ nil
]

{ #category : #accessing }
SWVMMethod >> selector [

	^ selector
]

{ #category : #accessing }
SWVMMethod >> selector: aString [ 

	selector := aString
]

{ #category : #accessing }
SWVMMethod >> size [

	^ vm objectMemory numBytesOf: methodPointer
]

{ #category : #accessing }
SWVMMethod >> sourceCode [

	^ (FBDDecompiler new decompile: self) formattedCode
]

{ #category : #compatibility }
SWVMMethod >> trailer [

	^ CompiledMethodTrailer new method: self
]

{ #category : #accessing }
SWVMMethod >> vm: aVM [ 
	vm := aVM
]
