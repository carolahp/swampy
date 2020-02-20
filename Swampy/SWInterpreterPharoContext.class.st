Class {
	#name : #SWInterpreterPharoContext,
	#superclass : #SWPharoContext,
	#category : #Swampy
}

{ #category : #accessing }
SWInterpreterPharoContext >> isInterpreterOnReceiver: aReceiver [

	^ context receiver receiver = aReceiver
]
