Class {
	#name : #SWVMObject,
	#superclass : #Object,
	#instVars : [
		'vm',
		'address'
	],
	#category : #Swampy
}

{ #category : #'instance creation' }
SWVMObject class >> on: anAddress vm: aVM [ 

	^ self new
		address: anAddress;
		vm: aVM;
		yourself
]

{ #category : #accessing }
SWVMObject >> address [
	^ address
]

{ #category : #accessing }
SWVMObject >> address: anObject [
	address := anObject
]

{ #category : #'as yet unclassified' }
SWVMObject >> gtInspectorVariableNodesIn: aCollection [
	"This is a helper method that adds to the given collection all nodes modeling named and 
	indexed attributes for the current object.
	Subclasses can override it to specialize what appears in the variables presentation."
	| indexableDisplayLimit top bottom topLimit bottomLimit fixedSlots |
	
	indexableDisplayLimit := GTInspector indexableDisplayLimit.        
	top := 1.
	1haltOnce.
	fixedSlots := vm objectMemory numFixedSlotsOf: address.
	bottom := (vm objectMemory lengthOf: address) - fixedSlots.
	topLimit    := indexableDisplayLimit min: bottom.
	bottomLimit := indexableDisplayLimit max: (bottom - indexableDisplayLimit).

	top to: topLimit do: [ :index | 
		aCollection add: (SWInspectorIndexedNode hostObject: self index: index) ].
	
	bottomLimit + 1 to: bottom do: [ :index |
		aCollection add: (SWInspectorIndexedNode hostObject: self index: index) ].
	
	aCollection
		addAll: (((1 to: fixedSlots) collect: [ :index | 
			SWInspectorIndexedSlotNode hostObject: self index: index ]))
]

{ #category : #accessing }
SWVMObject >> internalPrintOn: aStream [
	
	| className |
	self isNilObject ifTrue: [ 
		^ aStream << 'nil' ].
	
	className := vm nameOfClass: (vm objectMemory fetchClassOf: address).
	className = ByteSymbol name
		ifTrue: [ ^ aStream print: (vm stringOf: address) asSymbol ].
	className = SmallInteger name
		ifTrue: [ ^ aStream print: (vm objectMemory integerValueOf: address) ].
	aStream << 'a' << className << $?
]

{ #category : #accessing }
SWVMObject >> isNilObject [

	^ address == vm objectMemory nilObject
]

{ #category : #accessing }
SWVMObject >> printOn: aStream [

	aStream
		<< self class name
		<< $(.
	self internalPrintOn: aStream.
	aStream << $)
]

{ #category : #'as yet unclassified' }
SWVMObject >> swampyInspectorRawIn: composite [
	"This is the most basic presentation showing the state of the object"
	<gtInspectorPresentationOrder: 1>
	<gtInspectorTag: #basic>
	^ composite custom: SWObjectVariablesBrowser new
]

{ #category : #accessing }
SWVMObject >> vm [
	^ vm
]

{ #category : #accessing }
SWVMObject >> vm: anObject [
	vm := anObject
]

{ #category : #accessing }
SWVMObject >> vmIndexableSlotAtIndex: anInteger [ 

	^ SWVMObject on: (vm objectMemory fetchPointer: anInteger - 1 ofObject: address) vm: vm
]

{ #category : #accessing }
SWVMObject >> vmSlotAtIndex: anInteger [ 

	^ SWVMObject on: (vm objectMemory fetchPointer: anInteger - 1 ofObject: address) vm: vm
]
