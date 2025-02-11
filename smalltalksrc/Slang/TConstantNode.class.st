Class {
	#name : 'TConstantNode',
	#superclass : 'TParseNode',
	#instVars : [
		'value'
	],
	#category : 'Slang-AST',
	#package : 'Slang',
	#tag : 'AST'
}

{ #category : 'instance creation' }
TConstantNode class >> value: aValue [

	^ self new
		  setValue: aValue;
		  yourself
]

{ #category : 'comparing' }
TConstantNode >> = aNode [

	^ aNode isConstant and: [ value = aNode value ]
]

{ #category : 'visiting' }
TConstantNode >> accept: aVisitor [
	
	^ aVisitor visitConstantNode: self
]

{ #category : 'tranforming' }
TConstantNode >> asCASTIn: aBuilder [

	^ CConstantNode value: (aBuilder cLiteralFor: value)
]

{ #category : 'transformations' }
TConstantNode >> asPrintfFormatStringNode [
	^TPrintfFormatStringNode new
		setValue: value;
		comment: comment;
		yourself
]

{ #category : 'accessing' }
TConstantNode >> children [
	
	^ #()
]

{ #category : 'accessing' }
TConstantNode >> constantNumbericValueIfAtAllPossibleOrNilIn: aCCodeGen [
	"This is a version of constantNumbericValueOrNil for type checking rather than code generation.
	 It aims to yield a value if at all possible.  This should /not/ be overridden in TDefineNode."
	^value isNumber ifTrue: [value]
]

{ #category : 'accessing' }
TConstantNode >> constantNumbericValueOrNil [

	^value isNumber ifTrue: [value]
]

{ #category : 'testing' }
TConstantNode >> hasSideEffect [
	"Answer if the parse tree rooted at this node has a side-effect or not."
	^false
]

{ #category : 'testing' }
TConstantNode >> isConstant [

	^true
]

{ #category : 'testing' }
TConstantNode >> isLeaf [

	^true
]

{ #category : 'comparing' }
TConstantNode >> isSameAs: aTParseNode [
	^aTParseNode isConstant
	 and: [value class == aTParseNode value class
	 and: [value = aTParseNode value]]
]

{ #category : 'accessing' }
TConstantNode >> name [
	^''
]

{ #category : 'accessing' }
TConstantNode >> nameOrValue [

	^value
]

{ #category : 'enumerating' }
TConstantNode >> nodesDo: aBlock parent: parent [
	"Apply aBlock to all nodes in the receiver with each node's parent.
	 N.B. This is assumed to be bottom-up, leaves first."
	aBlock value: self value: parent
]

{ #category : 'printing' }
TConstantNode >> printOn: aStream level: level [
	value isSymbol
		ifTrue: [aStream nextPutAll: (value copyWithout: $:)]
		ifFalse: [value storeOn: aStream]
]

{ #category : 'accessing' }
TConstantNode >> setValue: anObject [

	value := anObject.
]

{ #category : 'type inference' }
TConstantNode >> typeOrNilFrom: aCodeGenerator in: aTMethod [
	"For integers, answer int unless the value does not fit into a 32bits signed int.
	In that case, answer the shortest architecture independant integer type that could hold the constant.
	This method must be consistent with CCodeGenerator>>cLiteralFor:"
	| hb |
	value isInteger
		ifTrue:
			[value positive
				ifTrue:
					[hb := value highBit.
					hb < 32 ifTrue: [^#int].
					hb = 32 ifTrue: [^#'unsigned int'].
					hb = 64 ifTrue: [^#'unsigned long long'].
					^#'long long']
				ifFalse:
					[hb := value bitInvert highBit.
					hb < 32 ifTrue: [^#int].
					^#'long long']].
	value isFloat ifTrue: [^#double].
	(#(nil true false) includes: value) ifTrue: [^#int].
	(value isString and: [value isSymbol not]) ifTrue: [^#'char *'].
	^nil
]

{ #category : 'accessing' }
TConstantNode >> value [

	^value
]
