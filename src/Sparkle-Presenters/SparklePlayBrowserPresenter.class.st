Class {
	#name : 'SparklePlayBrowserPresenter',
	#superclass : 'SpkPresenter',
	#instVars : [
		'projects',
		'packages',
		'classes',
		'categories',
		'methods',
		'source',
		'connection',
		'service'
	],
	#category : 'Sparkle-Presenters-Presenters'
}

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> connectPresenters [

	projects whenSelectionChangedDo: [ :selection | 
		selection selectedItem ifNotNil: [ :sparkleService | 
			self getPackagesForProject: sparkleService ] ].
	packages whenSelectionChangedDo: [ :selection | 
		selection selectedItem ifNotNil: [ :sparkleService | 
			self getClassesForPackage: sparkleService ] ].
	classes whenSelectionChangedDo: [ :selection | 
		selection selectedItem ifNotNil: [ :sparkleService | 
			self getCategoriesForClass: sparkleService.
			self getMethodsForClass: sparkleService ] ].
	categories whenSelectionChangedDo: [ :selection | 
			self getMethodsForClass: classes selectedItem ]
]

{ #category : 'list management' }
SparklePlayBrowserPresenter >> getCategoriesForClass: classSparkleService [

	| sparkleServices classService categoryStrings |
	sparkleServices := service
		                   remotePerformOnService: classSparkleService
		                   selector: #update
		                   arguments: #(  ).
	classService := sparkleServices detect: [ :sparkleService | 
		                sparkleService rowanServiceClassName
		                = #RowanClassService ].
	categoryStrings := classService blobPropertyNamed: #categories.
	categories
		items: categoryStrings;
		sortingBlock: [ :a :b | a < b ]
]

{ #category : 'list management' }
SparklePlayBrowserPresenter >> getClassesForPackage: packageSparkleService [

	| sparkleServices packageService classServices |
	sparkleServices := service
		                   remotePerformOnService: packageSparkleService
		                   selector: #update
		                   arguments: #(  ).
	packageService := sparkleServices detect: [ :sparkleService | 
		                   sparkleService rowanServiceClassName
		                   = #RowanPackageService ].
	classServices := packageService blobPropertyNamed: #classes. 
	classes
		items: classServices;
		sortingBlock: [ :a :b | 
			(a blobPropertyNamed: #name) < (b blobPropertyNamed: #name) ]
]

{ #category : 'list management' }
SparklePlayBrowserPresenter >> getMethodsForClass: classSparkleService [

	| sparkleServices classService methodServices displayedMethodServices |
	sparkleServices := service
		                   remotePerformOnService: classSparkleService
		                   selector: #update
		                   arguments: #(  ).
	classService := sparkleServices detect: [ :sparkleService | 
		                sparkleService rowanServiceClassName
		                = #RowanClassService ].
	methodServices := classService blobPropertyNamed: #methods.
	displayedMethodServices := categories selectedItems isEmpty
		                           ifTrue: [ methodServices ]
		                           ifFalse: [ 
			                           methodServices select: [ :methodService | 
				                           categories selectedItems includes:
					                           (methodService blobPropertyNamed:
						                            #category) ] ].
	methods
		items: displayedMethodServices;
		sortingBlock: [ :a :b | 
			(a blobPropertyNamed: #selector) < (b blobPropertyNamed: #selector) ]
]

{ #category : 'list management' }
SparklePlayBrowserPresenter >> getPackagesForProject: projectSparkleService [

	| sparkleServices projectService packageServices |
	sparkleServices := service
		                   remotePerformOnService: projectSparkleService
		                   selector: #update
		                   arguments: #(  ).
	projectService := sparkleServices detect: [ :sparkleService | 
		                   sparkleService rowanServiceClassName
		                   = #RowanProjectService ].
	packageServices := projectService blobPropertyNamed: #packages. 
	packages
		items: packageServices;
		sortingBlock: [ :a :b | 
			(a blobPropertyNamed: #name) < (b blobPropertyNamed: #name) ]
]

{ #category : 'list management' }
SparklePlayBrowserPresenter >> getSourceForMethod: methodSparkleService [
	"This probably doesn't really update. Need to fix. "
	service
		remotePerformOnService: methodSparkleService
		selector: #update
		arguments: #(  ).
	source text: (methodSparkleService blobPropertyNamed: #source)
]

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initialize [
	super initialize.
	service := SpkRowanServiceClient new registerWith:
		           SpkLauncherPresenter connection.
	self initializeProjects 
]

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initializeListNamed: string in: box [

	| newList |
	box
		add: (SpkBoxLayout newVertical
				 add: (newList := self newList
						             headerTitle: string;
						             yourself);
				 yourself)
		withConstraints: [ :constraints | constraints width: 200 ].
	^ newList
]

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initializeListPresenters [

	| box |
	self layout add: (box := SpkBoxLayout newHorizontal).
	projects := self initializeListNamed: 'Projects' in: box.
	packages := self initializeListNamed: 'Packages' in: box.
	packages display: [ :sparkleService | 
		sparkleService blobPropertyNamed: #name ].
	classes := self initializeListNamed: 'Classes' in: box.
	classes display: [ :sparkleService | 
		sparkleService blobPropertyNamed: #name ].
	categories := self initializeListNamed: 'Categories' in: box.
	categories beMultipleSelection. 
	methods := self initializeListNamed: 'Methods' in: box.
	methods display: [ :sparkleService | 
		sparkleService blobPropertyNamed: #selector ]
]

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initializePresenters [

	super initializePresenters.
	self initializeListPresenters.
	self initializeSourcePresenter.
	
]

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initializeProjects [

	| sparkleServices projectServices |
	sparkleServices := service
		                   remotePerformOn: 'RowanBrowserService'
		                   selector: #updateProjects
		                   arguments: #(  ).
	projectServices := sparkleServices select: [ :sparkleService | 
		                   sparkleService rowanServiceClassName
		                   = #RowanProjectService ].
	projects
		items: projectServices;
		display: [ :sparkleService | 
			sparkleService blobPropertyNamed: #name ];
		sortingBlock: [ :a :b | 
			(a blobPropertyNamed: #name) < (b blobPropertyNamed: #name) ]
]

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initializeSourcePresenter [

	self layout add: (source := self newCode)
]

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Sparkle Browser';
		borderColor: Color purple;
		borderWidth: 3;
		initialExtent: 1000 @ 600
]

{ #category : 'constants' }
SparklePlayBrowserPresenter >> labelHeight [

	^20
]

{ #category : 'accessing' }
SparklePlayBrowserPresenter >> newLayout [

	^ SpkBoxLayout newVertical
]