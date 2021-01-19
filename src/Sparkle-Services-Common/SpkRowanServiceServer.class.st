Class {
	#name : 'SpkRowanServiceServer',
	#superclass : 'SpkRowanService',
	#category : 'Sparkle-Services-Common'
}

{ #category : 'command execution' }
SpkRowanServiceServer >> remotePerformOn: classString selector: selector arguments: anArray meta: meta [

	| commandResultClass sparkleServices rowanServiceClass rowanService |
	rowanServiceClass := self rowanServiceClass.
	rowanService := rowanServiceClass
		                instantiateFromClassName: classString
		                meta: meta.
	commandResultClass := (GsSession currentSession resolveSymbol:
		                       #RowanCommandResult) value.
	commandResultClass initializeResults.

	rowanService perform: selector withArguments: anArray.
	sparkleServices := commandResultClass results collect: [ :service | 
		                   service makeSparkle ].
	^ sparkleServices
]

{ #category : 'command execution' }
SpkRowanServiceServer >> remotePerformOnService: sparkleService selector: selector arguments: anArray [

	| commandResultClass sparkleServices rowanService rowanServiceClass |
	rowanServiceClass := self rowanServiceClass.
	rowanService := rowanServiceClass instantiateFrom: sparkleService.

	commandResultClass := (GsSession currentSession resolveSymbol:
		                       #RowanCommandResult) value.
	commandResultClass initializeResults.

	rowanService perform: selector withArguments: anArray.
	sparkleServices := commandResultClass results collect: [ :service | 
		                   service makeSparkle ].
	^ sparkleServices
]

{ #category : 'command execution' }
SpkRowanServiceServer >> rowanServiceClass [

	^ (GsSession currentSession resolveSymbol: #RowanService) value
]