Extension { #name : 'SpkScaffoldingRowanService' }

{ #category : '*sparkle-scaffolding-gemstone' }
SpkScaffoldingRowanService >> newRowanService [
	^ RowanService new
]

{ #category : '*sparkle-scaffolding-gemstone' }
SpkScaffoldingRowanService >> rowanService [
	^ (self dynamicInstVarAt: #'rowanService')
		ifNil: [ self rowanService: self newRowanService ]
]

{ #category : '*sparkle-scaffolding-gemstone' }
SpkScaffoldingRowanService >> rowanService: anObject [
	"RSR does not have a hook to execute post remote message
	send code. We're doing that here, as a poor substitute. 
	Although not required, it is advised to send this method 
	only after completing the remote message send if you want
	to use the rsr-friendly version of the rowan service on the client."

	self dynamicInstVarAt: #'rowanService' put: anObject.
	rsrRowanService := self rowanService asRSR.
	RowanCommandResult clearResults.
	^anObject "not a true accessor. we return the argument"
]