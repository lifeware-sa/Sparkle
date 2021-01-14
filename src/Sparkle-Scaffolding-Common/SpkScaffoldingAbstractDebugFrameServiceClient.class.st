Class {
	#name : 'SpkScaffoldingAbstractDebugFrameServiceClient',
	#superclass : 'SpkScaffoldingDebugFrameService',
	#category : 'Sparkle-Scaffolding-Common'
}

{ #category : 'accessing' }
SpkScaffoldingAbstractDebugFrameServiceClient >> label [

	^label ifNil: [ label := remoteSelf label wait ]
]

{ #category : 'printing' }
SpkScaffoldingAbstractDebugFrameServiceClient >> printOn: aStream [

	aStream
		nextPutAll: self label
]