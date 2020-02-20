Class {
	#name : #SWContextFailingStep,
	#superclass : #SWPharoContext,
	#instVars : [
		'shouldFailNextStep'
	],
	#category : #'Swampy-Tests'
}

{ #category : #accessing }
SWContextFailingStep >> doStepInto [

	shouldFailNextStep ifTrue: [ self error ].
	^ super doStepInto
]

{ #category : #accessing }
SWContextFailingStep >> failNextStep [

	shouldFailNextStep := true
]

{ #category : #accessing }
SWContextFailingStep >> initialize [
	super initialize.
	shouldFailNextStep := false
]
