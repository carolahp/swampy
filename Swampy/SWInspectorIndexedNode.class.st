Class {
	#name : #SWInspectorIndexedNode,
	#superclass : #GTInspectorVariableNode,
	#instVars : [
		'index'
	],
	#category : #'Swampy-Inspector'
}

{ #category : #'instance creation' }
SWInspectorIndexedNode class >> hostObject: anObject index: index [
	^ (self hostObject: anObject)
		index: index;
		yourself
]

{ #category : #accessing }
SWInspectorIndexedNode >> errorMessage [
	^ 'error obtaining indexed attribute value'
]

{ #category : #accessing }
SWInspectorIndexedNode >> index [
	^ index
]

{ #category : #accessing }
SWInspectorIndexedNode >> index: anInteger [
	index := anInteger
]

{ #category : #accessing }
SWInspectorIndexedNode >> key [
	^ self index
]

{ #category : #accessing }
SWInspectorIndexedNode >> rawValue [
	1haltOnce.
	^ self hostObject vmIndexableSlotAtIndex: index
]

{ #category : #actions }
SWInspectorIndexedNode >> save: aValue [
	self hostObject at: self index put: aValue
]

{ #category : #accessing }
SWInspectorIndexedNode >> variableTag [
	^ 'attribute'
]
