Class {
	#name : #SWInspectorIndexedSlotNode,
	#superclass : #GTInspectorVariableNode,
	#instVars : [
		'index'
	],
	#category : #'Swampy-Inspector'
}

{ #category : #'instance creation' }
SWInspectorIndexedSlotNode class >> hostObject: anObject index: index [
	^ (self hostObject: anObject)
		index: index;
		yourself
]

{ #category : #accessing }
SWInspectorIndexedSlotNode >> errorMessage [
	^ 'error obtaining indexed attribute value'
]

{ #category : #accessing }
SWInspectorIndexedSlotNode >> index [
	^ index
]

{ #category : #accessing }
SWInspectorIndexedSlotNode >> index: anInteger [
	index := anInteger
]

{ #category : #accessing }
SWInspectorIndexedSlotNode >> key [
	^ self index
]

{ #category : #accessing }
SWInspectorIndexedSlotNode >> rawValue [
	1haltOnce.
	^ self hostObject vmSlotAtIndex: index
]

{ #category : #actions }
SWInspectorIndexedSlotNode >> save: aValue [
	self hostObject at: self index put: aValue
]

{ #category : #accessing }
SWInspectorIndexedSlotNode >> variableTag [
	^ 'attribute'
]
