Extension { #name : #TextPresenter }

{ #category : #'*Swampy' }
TextPresenter >> highlightNextIntructionInterval: anInterval [
	| highlightSegment |
	highlightSegment := RubTextSegmentMorph
		from: anInterval first
		to: anInterval last + 1.
	highlightSegment color: Color red.
	self widget
		ifNotNil: [ :adapter | adapter widget addSegment: highlightSegment ]
]
