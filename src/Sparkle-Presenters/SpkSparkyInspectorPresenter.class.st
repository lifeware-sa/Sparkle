Class {
	#name : 'SpkSparkyInspectorPresenter',
	#superclass : 'SpkPresenter',
	#instVars : [
		'oop',
		'variableList',
		'variablePane',
		'objectDetails',
		'inspectorService'
	],
	#classVars : [
		'DebuggerAnnouncer'
	],
	#category : 'Sparkle-Presenters-Presenters'
}

{ #category : 'initialization' }
SpkSparkyInspectorPresenter >> connectPresenters [

	"the value of the item is assumed to be a string or oop"

	super connectPresenters.
	variableList whenSelectionChangedDo: [ :selection | 
		selection selectedItem ifNotNil: [ :item | 
			item value isString
				ifTrue: [ variablePane text: item value ]
				ifFalse: [ variablePane text: (self printOop: item value) ] ] ]
]

{ #category : 'actions' }
SpkSparkyInspectorPresenter >> fillUpInspector [

	| theOop objects items inspectorArray |
	inspectorArray := objectDetails rowanService. 
	theOop := inspectorArray detect: [ :array | array first = #oop ].
	objects := inspectorArray detect: [ :array | array first = #objects ].
	items := OrderedCollection new.
	items add: 'self' -> theOop last.
	items add: '-.asOop' -> theOop last printString.
	items addAll:
		(objects last collect: [ :array | array first -> array last ]).
	variableList items: items
]

{ #category : 'initialization' }
SpkSparkyInspectorPresenter >> initialize [

	super initialize.
	oop := 20. 
	
]

{ #category : 'initialization' }
SpkSparkyInspectorPresenter >> initializePresenters [

	| box |
	super initializePresenters.
	self initializeToolbar.
	box := SpkBoxLayout newLeftToRight.
	self initializeVariableList: box.
	self initializeVariablePane: box.
	self layout add: box.
	self layout color: SpkConnectionListPresenter defaultColor
]

{ #category : 'initialization' }
SpkSparkyInspectorPresenter >> initializeToolbar [

	| toolbar |
	toolbar := self newToolbar.
	toolbar addItem: (SpToolbarButtonPresenter new
			 label: 'Inspect';
			 icon: (self iconNamed: #smallInspectIt);
			 help: 'Inspect nil for now';
			 action: [ self inspectVariableOop];
			 yourself).
	self layout
		add: toolbar
		withConstraints: [ :constraints | constraints height: 30 ]
]

{ #category : 'initialization' }
SpkSparkyInspectorPresenter >> initializeVariableList: box [

	box add: (variableList := self newTable beSingleSelection addColumn:
			                 (SpImageTableColumn new evaluated: [ :assoc | 
				                  assoc key ])).
	self overrideVariableListMenu
]

{ #category : 'initialization' }
SpkSparkyInspectorPresenter >> initializeVariablePane: box [

	box add: (variablePane := self newText)
]

{ #category : 'initialization' }
SpkSparkyInspectorPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Sparkle Inspector';
		initialExtent: 500 @ 500
]

{ #category : 'actions' }
SpkSparkyInspectorPresenter >> inspectOop [

	self inspectOop: oop
]

{ #category : 'actions' }
SpkSparkyInspectorPresenter >> inspectOop: anOop [

	| promise |
	promise := self inspectorService inspect: anOop.
	promise
		when: [ :result | 
			objectDetails := result.
			self fillUpInspector.
			variableList selectIndex: 1 ]
		catch: [ :reason | 
			Transcript
				cr;
				show: '=========';
				cr;
				show: 'UNEXPECTED CATCH: ' , reason printString;
				cr;
				show: DateAndTime now printString;
				cr;
				show: '=========';
				yourself ]
]

{ #category : 'actions' }
SpkSparkyInspectorPresenter >> inspectVariableOop [

	variableList selection selectedItem ifNotNil: [ :item | 
		item value isString ifFalse: [ SparkyInspector on: item value ] ]
]

{ #category : 'accessing' }
SpkSparkyInspectorPresenter >> inspectorService [

	inspectorService ifNil: [ 
		inspectorService := SpkScaffoldingInspectorServiceClient new 
			                    registerWith:
			                    SpkConnectionProfile defaultConnection ].
	^ inspectorService
]

{ #category : 'accessing' }
SpkSparkyInspectorPresenter >> newLayout [

	^ SpkBoxLayout newVertical
]

{ #category : 'accessing' }
SpkSparkyInspectorPresenter >> oop [

	^ oop
]

{ #category : 'accessing' }
SpkSparkyInspectorPresenter >> oop: anObject [

	oop := anObject
]

{ #category : 'initialization' }
SpkSparkyInspectorPresenter >> overrideVariableListMenu [

	| menu |
	variableList contextMenu:
		(menu := SpMenuPresenter new addGroup: [ :group | 
			         group addItem: [ :item | 
				         item
					         name: 'Inspect';
					         icon: (self iconNamed: #glamorousInspect);
					         action: [ self inspectVariableOop ] ] ])
]

{ #category : 'actions' }
SpkSparkyInspectorPresenter >> printOop: theOop [

	| promise printString sem |
	promise := self inspectorService printOop: theOop.
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