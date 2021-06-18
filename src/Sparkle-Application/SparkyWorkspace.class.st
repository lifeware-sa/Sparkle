Class {
	#name : 'SparkyWorkspace',
	#superclass : 'SpkApplication',
	#category : 'Sparkle-Application'
}

{ #category : 'examples' }
SparkyWorkspace class >> example [ 
	<example>
	self new start
]

{ #category : 'examples' }
SparkyWorkspace class >> menuCommandOn: aBuilder [ 
	"Add a custom menu item to the world menu"	
	<worldMenu> 
	
	(aBuilder item: #'Sparky Versions')
		order: 0.95; 
		icon: nil;  
		parent: #'Tools'; "This appears as the Library menu option for whatever reason"
		keyText: 'L'; "hot key doesn't work yet" 
		help: 'Sparkle versions on client & server';
		action: [ self versionSoup ]
]

{ #category : 'examples' }
SparkyWorkspace class >> printServerLoadedVersions [ 

	| inspectorService promise printString sem |
	inspectorService := SpkScaffoldingInspectorServiceClient new 
		                    registerWith:
		                    SpkConnectionProfile defaultConnection.
	promise := inspectorService printLoadedVersions.
	sem := Semaphore new.
	promise
		when: [ :result | 
			printString := result.
			sem signal ]
		catch: [ :reason | 
			printString := 'Unexpected Error getting printString '
			               , reason printString.
			sem signal ].
	sem wait.
	^ printString
]

{ #category : 'examples' }
SparkyWorkspace class >> versionSoup [

	"What the heck do I have loaded?"

	<example>
	| inst writeStream |
	SpkConnectionProfile defaultConnection ifNil: [ 
		^ self notify: 'Not Connected' ].
	inst := self new start.
	writeStream := WriteStream on: String new.
	writeStream
		cr;
		nextPutAll: 'Client:';
		cr;
		tab;
		nextPutAll: 'Pharo ' , WelcomeHelp pharoVersionString.

	IceRepository registry do: [ :repository | 
		writeStream
			cr;
			tab;
			nextPutAll: repository name;
			tab;
			space;
			nextPutAll: ([ repository branch name ]
					 on: Error
					 do: [ :ex | 'no branch' ]);
			tab;
			space;
			nextPutAll: ([ repository branch commit shortId ]
					 on: Error
					 do: [ :ex | 'no sha' ]) ].
	writeStream nextPutAll: self printServerLoadedVersions.
	inst text: writeStream contents
]

{ #category : 'running' }
SparkyWorkspace >> start [

	| presenter |
	(presenter := self new: SpkSparkyWorkspacePresenter) openWithSpec.
	^ presenter
]