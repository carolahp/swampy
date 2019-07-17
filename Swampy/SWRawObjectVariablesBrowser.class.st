Class {
	#name : #SWRawObjectVariablesBrowser,
	#superclass : #GLMCompositePresentation,
	#instVars : [
		'cachedHashes'
	],
	#category : #'Swampy-Inspector'
}

{ #category : #'private building' }
SWRawObjectVariablesBrowser >> basicVariableNodesFor: anObject [

	^ #()
]

{ #category : #'private building' }
SWRawObjectVariablesBrowser >> basicVariableNodesFor: anObject in: aCollection [

	self subclassResponsibility 
]

{ #category : #'private building' }
SWRawObjectVariablesBrowser >> childrenVariableNodesForNode: aNode [
	| variableNodes |

	"Nil should have now a single child: `self`. For now this is needed for
	a smooth navigation in the tree widget."
	"anObject ifNil: [ ^ #() ]."

	variableNodes := OrderedCollection new: aNode value class allSlots size.
	variableNodes add: (GTInspectorWrapperNode hostObject: aNode label: 'self').
	self basicVariableNodesFor: aNode value in: variableNodes.
	^ variableNodes
]

{ #category : #building }
SWRawObjectVariablesBrowser >> compose [
	self title: 'VMRaw'.
	self tabulator with: [ :browser |
		browser row: #variables; row: #evaluator.
		browser transmit 
			to: #variables; 
			andShow: [:a | self variablesIn: a ].
		browser transmit 
			to: #evaluator; 
			andShow: [:a | self evaluatorIn: a ].
		browser transmit 
			from: #variables; 
			toOutsidePort: #selection; 
			transformed: [ :aNode | aNode ifNotNil: [aNode value]].
		browser transmit 
			from: #evaluator; 
			toOutsidePort: #selection ].
	self wantsAutomaticRefresh: true
]

{ #category : #'private building' }
SWRawObjectVariablesBrowser >> evaluatorIn: composite [
	^ composite pharoScript
		doItReceiver: [ :object | object ];
		smalltalkClass: [ :object | object class ];
		display: [ :object | 
			String streamContents: [ :stream | 
				stream 
					nextPutAll: (self printStringOf: object);
					cr;
					nextPutAll: (GTSnippets snippetAt: object class)] ];
		onChangeOfPort: #text act: [ :textPresentation :object |
				GTSnippets 
					snippetAt: object class 
					put: (self stringWithoutInitialCommentFrom: textPresentation text asString).
				 textPresentation clearUserEdits ];
		installDefaultSelectionActions
]

{ #category : #'private - updating' }
SWRawObjectVariablesBrowser >> generateCacheFor: anObject [
	| valuesCache |
	
	valuesCache := OrderedDictionary new.
	((self basicVariableNodesFor: anObject) do: [ :assoc | 
		valuesCache 
			at: assoc key 
			put: (self generateHashFor: assoc value) ]).
	
	^ valuesCache
]

{ #category : #'private - updating' }
SWRawObjectVariablesBrowser >> generateHashFor: anObject [ 

	^ (self basicVariableNodesFor: anObject)
		inject: anObject gtInspectorHash
		into: [ :hashValue :assoc | hashValue bitXor: assoc value gtInspectorHash ].
	
	
]

{ #category : #'private building' }
SWRawObjectVariablesBrowser >> iconFor: anObject [
		
	^ [ (anObject gtInspectorIcon)
		ifNil: [ anObject class systemIcon ] ]
			on: Error do: [ :error | self iconFor: anObject error: error ]
]

{ #category : #'private building' }
SWRawObjectVariablesBrowser >> iconFor: anEyeElement error: error [
	^ self iconNamed: #smallWarningIcon
]

{ #category : #'private building' }
SWRawObjectVariablesBrowser >> printStringOf: anObject [
	self subclassResponsibility
]

{ #category : #'private - updating' }
SWRawObjectVariablesBrowser >> rebuildCacheFor: anObject [

	cachedHashes := self generateCacheFor: anObject
]

{ #category : #stepping }
SWRawObjectVariablesBrowser >> requestRefresh [
	(self presentations first paneNamed: #variables) presentations first requestRefresh
]

{ #category : #'private - updating' }
SWRawObjectVariablesBrowser >> shouldRefresh [
	|newCache result|

	newCache := self generateCacheFor: self entity.
	result := cachedHashes ~= newCache.
	cachedHashes := newCache.
	^ result
]

{ #category : #'private building' }
SWRawObjectVariablesBrowser >> stringWithoutInitialCommentFrom: aString [
	^ (aString trimLeft isEmpty not and: [ aString trimLeft first = $" ])
		ifFalse: [ aString trimRight ]
		ifTrue: [|startIndex doubleQuoteCounter|
			startIndex := aString findAnySubstring: '"' startingAt: (aString indexOf: $") + 1.
			doubleQuoteCounter := 1.
			"we need to iterate over the whole string queuing quotes to support nested double quotes"
			[ startIndex <= aString size
				and: [ doubleQuoteCounter % 2 = 1
					or: [ (aString at: startIndex) = $"
						or: [ (aString at: startIndex) isSeparator ] ] ] ]
			whileTrue: [ 
				(aString at: startIndex) = $" ifTrue: [ 
					doubleQuoteCounter := doubleQuoteCounter + 1 ].
				startIndex := startIndex + 1 ].
	
			(startIndex >= (aString size + 1)) ifTrue: [ "No content if a comment cannot be identified. " ^ '' ].
			(aString
				copyFrom: startIndex
				to: aString size) trimBoth ]
]

{ #category : #'private building' }
SWRawObjectVariablesBrowser >> updateVariableNode: aNode basedOn: aString [
	| aResult |

	aResult := aNode hostObject class compiler
			source: aString;
			context: nil;
			receiver: aNode hostObject;
			failBlock: [ ^ self ];
			evaluate.
						
	aNode save: aResult
]

{ #category : #'private building' }
SWRawObjectVariablesBrowser >> variableNodesFor: anObject [
	| variableNodes |

	"Nil should have now a single child: `self`. For now this is needed for
	a smooth navigation in the tree widget."
	"anObject ifNil: [ ^ #() ]."

	variableNodes := OrderedCollection new: anObject class allSlots size.
	variableNodes add: (GTInspectorSelfNode hostObject: anObject).
	self basicVariableNodesFor: anObject in: variableNodes.
	^ variableNodes
]

{ #category : #'private building' }
SWRawObjectVariablesBrowser >> variablesIn: composite [
	^ composite fastTreeTable
		useCache;
		hasChildren: [ :aNode | aNode key ~= 'self' ];
		children: [ :aNode | aNode childrenNodesFor: self ];
		icon: [ :aNode | self iconFor: aNode value ];
		display: [ :anObject | 
			self variableNodesFor: anObject ];
		column: 'Variable' translated
			evaluated: [ :aNode | (GTObjectPrinter asNonTruncatedTextFrom: aNode label) ];
		column: 'Value' translated
			evaluated: [ :aNode | | rawValue displayValue |
				[ rawValue := aNode rawValue. ] 
					on: Error 
					do: [ displayValue := Text string: aNode errorMessage attribute: TextColor red ].
				displayValue ifNil: [ GTObjectPrinter asTruncatedTextFrom: rawValue ] ]
			modified: [ :newValue :editedNode :curentPresentation | 
				self updateVariableNode: editedNode basedOn: newValue.
				curentPresentation requestRefresh ];
		morphicSelectionAct: [:list | list selection value browse ] 
			icon: GLMUIThemeExtraIcons glamorousBrowse 
			on: $b 
			entitled: 'Browse' translated;
		morphicSelectionAct: [:list | list selection value inspect ] 
			icon: GLMUIThemeExtraIcons glamorousInspect 
			on: $i 
			entitled: 'Inspect' translated;
		dynamicActionsOnSelection: [ :presentation |
			(presentation rawSelection isKindOf: GTInspectorVariableNode) 
				ifTrue: [presentation rawSelection inspectorActionsForNode ]
				ifFalse: [ #() ] ];
		selectionAct: [:list | 
			((list selection value pointersToExcept: { list selection value })
									reject: [ :each | each pointsOnlyWeaklyTo: list selection value ]) inspect ] 
			on: $t
			entitled: 'Open pointers to' translated
	
]
