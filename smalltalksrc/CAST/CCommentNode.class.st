Class {
	#name : 'CCommentNode',
	#superclass : 'CGLRAbstractNode',
	#instVars : [
		'comment'
	],
	#category : 'CAST-Nodes',
	#package : 'CAST',
	#tag : 'Nodes'
}

{ #category : 'instance creation' }
CCommentNode class >> comment: aString [

	^ self new
		  comment: aString;
		  yourself
]

{ #category : 'generated' }
CCommentNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitComment: self
]

{ #category : 'accessing' }
CCommentNode >> comment [

	^ comment
]

{ #category : 'accessing' }
CCommentNode >> comment: aComment [

	comment := aComment
]

{ #category : 'testing' }
CCommentNode >> isComment [

	^ true
]

{ #category : 'testing' }
CCommentNode >> needsSeparator [

	^ false
]

{ #category : 'testing' }
CCommentNode >> needsTrailingSemicolon [

	^ false
]
