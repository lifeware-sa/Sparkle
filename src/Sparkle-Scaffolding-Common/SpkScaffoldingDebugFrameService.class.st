Class {
	#name : 'SpkScaffoldingDebugFrameService',
	#superclass : 'SpkScaffoldingAbstractService',
	#instVars : [
		'label',
		'variableMap',
		'variableOopMap',
		'methodService',
		'methodSource',
		'startPos',
		'stopPos',
		'frameOop'
	],
	#category : 'Sparkle-Scaffolding-Common'
}

{ #category : 'accessing' }
SpkScaffoldingDebugFrameService class >> templateClassName [

	^ #SpkScaffoldingDebugFrameService
]

{ #category : 'accessing' }
SpkScaffoldingDebugFrameService >> frameOop [

	^frameOop
]

{ #category : 'accessing' }
SpkScaffoldingDebugFrameService >> label [

	self subclassResponsibility
]

{ #category : 'accessing' }
SpkScaffoldingDebugFrameService >> methodService [

	self subclassResponsibility
]

{ #category : 'accessing' }
SpkScaffoldingDebugFrameService >> methodSource [

	self subclassResponsibility
]

{ #category : 'accessing' }
SpkScaffoldingDebugFrameService >> startPos [

	^ startPos
]

{ #category : 'accessing' }
SpkScaffoldingDebugFrameService >> stopPos [

	^ stopPos
]

{ #category : 'accessing' }
SpkScaffoldingDebugFrameService >> variableMap [

	self subclassResponsibility
]