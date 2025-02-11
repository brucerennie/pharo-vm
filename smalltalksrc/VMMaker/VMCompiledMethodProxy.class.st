"
A VMCompiledMethodProxy is a wrapper for the oop of a CompiledMethod object in the simulator VM's heap that provides accessd to the oop as if it were a CompiledMethod object.
"
Class {
	#name : 'VMCompiledMethodProxy',
	#superclass : 'VMObjectProxy',
	#instVars : [
		'size',
		'numLiterals'
	],
	#category : 'VMMaker-Support',
	#package : 'VMMaker',
	#tag : 'Support'
}

{ #category : 'accessing' }
VMCompiledMethodProxy >> at: index [
	^(index between: self numLiterals + 1 * objectMemory wordSize + 1 and: self size)
		ifTrue: [objectMemory fetchByte: index - 1 ofObject: oop]
		ifFalse: [self errorSubscriptBounds: index]
]

{ #category : 'accessing' }
VMCompiledMethodProxy >> encoderClass [

	^coInterpreter encoderClassForHeader: self header
]

{ #category : 'accessing' }
VMCompiledMethodProxy >> endPC [
	"Answer the index of the last bytecode."
	^(coInterpreter cogit endPCOf: oop) + 1
]

{ #category : 'literals' }
VMCompiledMethodProxy >> header [
	^objectMemory integerValueOf: (objectMemory methodHeaderOf: oop)
]

{ #category : 'accessing' }
VMCompiledMethodProxy >> initialPC [
	"Answer the program counter for the receiver's first bytecode."

	^(coInterpreter startPCOfMethod: oop) + 1
]

{ #category : 'literals' }
VMCompiledMethodProxy >> literalAt: index [ 
	^VMObjectProxy new
		for: (coInterpreter literal: index - 1 ofMethod: oop)
		coInterpreter: coInterpreter
		objectMemory: objectMemory
]

{ #category : 'accessing' }
VMCompiledMethodProxy >> numArgs [
	"Answer the argument count of the receiver."
	
	^coInterpreter argumentCountOf: oop
]

{ #category : 'accessing' }
VMCompiledMethodProxy >> numLiterals [
	"Answer the number of literals used by the receiver."
	
	^numLiterals ifNil: [numLiterals := objectMemory literalCountOf: oop]
]

{ #category : 'accessing' }
VMCompiledMethodProxy >> numTemps [
	^coInterpreter tempCountOf: oop
]

{ #category : 'scanning' }
VMCompiledMethodProxy >> pcPreviousTo: thePC [
	"Answer the pc of the bytecode before the bytecode at thePC."
	| pc prevPc byte encoderClass |
	thePC > self endPC ifTrue: [^self endPC].
	pc := self initialPC.
	encoderClass := self encoderClass.
	[pc < thePC] whileTrue:
		[byte := self at: (prevPc := pc).
		 [pc := pc + (encoderClass bytecodeSize: byte).
		  encoderClass isExtension: byte] whileTrue:
			[byte := self at: pc]].
	^prevPc
]

{ #category : 'accessing' }
VMCompiledMethodProxy >> primitive [
	"Answer the receiver's primitive."
	
	^coInterpreter primitiveIndexOf: oop
]

{ #category : 'accessing' }
VMCompiledMethodProxy >> size [
	^size ifNil: [size := objectMemory numBytesOf: oop]
]
