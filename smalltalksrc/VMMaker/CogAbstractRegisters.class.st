"
I am a pool for the abstract register set that the Cogit uses to define its model of Smalltalk compiled to machine code.
"
Class {
	#name : 'CogAbstractRegisters',
	#superclass : 'SharedPool',
	#classVars : [
		'Arg0Reg',
		'Arg1Reg',
		'CallerSavedRegisterMask',
		'ClassReg',
		'DPFPReg0',
		'DPFPReg1',
		'DPFPReg10',
		'DPFPReg11',
		'DPFPReg12',
		'DPFPReg13',
		'DPFPReg14',
		'DPFPReg15',
		'DPFPReg2',
		'DPFPReg3',
		'DPFPReg4',
		'DPFPReg5',
		'DPFPReg6',
		'DPFPReg7',
		'DPFPReg8',
		'DPFPReg9',
		'Extra0Reg',
		'Extra1Reg',
		'Extra2Reg',
		'Extra3Reg',
		'Extra4Reg',
		'Extra5Reg',
		'Extra6Reg',
		'Extra7Reg',
		'FPReg',
		'LinkReg',
		'NoReg',
		'NumFloatRegisters',
		'NumRegisters',
		'PCReg',
		'RISCTempReg',
		'ReceiverResultReg',
		'SPReg',
		'SendNumArgsReg',
		'TempReg',
		'VReg0',
		'VReg1',
		'VReg2',
		'VReg3',
		'VReg4',
		'VReg5',
		'VReg6',
		'VReg7',
		'VarBaseReg'
	],
	#category : 'VMMaker-JIT',
	#package : 'VMMaker',
	#tag : 'JIT'
}

{ #category : 'class initialization' }
CogAbstractRegisters class >> initialize [
	"Define a fixed set of abstract register names used in code generation for Smalltalk code.
	 These are given concrete values by the currently in-use back end, which is a subclass of
	 CogAbstractInstruction; see implementors of initializeAbstractRegisters.

	 We assume concrete registers defined by the back ends are in the range 0 to N, possibly
	 with integer registers and floating-point registers using overlapping ranges of indices.
	 Here we initialize all registers to #undefined, leaving it to initializeAbstractRegisters to
	 initialize the subset of the abstract registers that a platform actually uses."

	"NoReg encodes no register, e.g. for parameters that supply an optional register.
	 Being negative it is distinct from abstract and concrete registers in the 0 to N range."
	NoReg := -1.

	"The core set of abstract registers that define the Cogit's model of Smalltalk code
	 provide for a register-based calling convention oriented towards inline caching and
	 executing a core set of machine code primitives in registers.  The set is composed of
	 8 registers, dictated by the available registers on IA32."
	"Smalltalk machine code executes on stack pages in the stack zone, requiring frame and stack pointers."
	FPReg				:= #undefined.	"A frame pointer is used for Smalltalk frames."
	SPReg				:= #undefined.
	ReceiverResultReg	:= #undefined.	"The receiver at point of send, and return value of a send"
	ClassReg			:= #undefined.	"The inline send cache class tag is in this register, loaded at the send site"
	SendNumArgsReg	:= #undefined.	"Sends > 2 args set the arg count in this reg"
	Arg0Reg			:= #undefined.	"In the StackToRegisterMappingCogit 1 & 2 arg sends marshall into these registers."
	Arg1Reg			:= #undefined.
	TempReg			:= #undefined.

	"A small fixed set of abstract scratch registers for register-rich machines (ARM can use 1, x64 can use 6 or 7)."
	Extra0Reg := #undefined.
	Extra1Reg := #undefined.
	Extra2Reg := #undefined.
	Extra3Reg := #undefined.
	Extra4Reg := #undefined.
	Extra5Reg := #undefined.
	Extra6Reg := #undefined.
	Extra7Reg := #undefined.

	"RISC-specific registers"
	LinkReg			:= #undefined.
	RISCTempReg	:= #undefined.		"Used to synthesize CISC instructions from multiple RISC instructions."
	PCReg			:= #undefined.		"If the processor has an assignable pc, e.g. ARM"
	VarBaseReg	:= #undefined.		"If useful, points to base of interpreter variables."

	NumRegisters	:= #undefined.	"Number of basic/integer regsiters (we don't do M68k ;-) )"

	"Up to 16 floating-point registers. e.g. IA32+SSE2 can use 8, x64 can use 16."
	DPFPReg0	:= #undefined.
	DPFPReg1	:= #undefined.
	DPFPReg2	:= #undefined.
	DPFPReg3	:= #undefined.
	DPFPReg4	:= #undefined.
	DPFPReg5	:= #undefined.
	DPFPReg6	:= #undefined.
	DPFPReg7	:= #undefined.
	DPFPReg8	:= #undefined.
	DPFPReg9	:= #undefined.
	DPFPReg10	:= #undefined.
	DPFPReg11	:= #undefined.
	DPFPReg12	:= #undefined.
	DPFPReg13	:= #undefined.
	DPFPReg14	:= #undefined.
	DPFPReg15	:= #undefined.
		
	"Up to 8 SIMD registers. e.g. IA32+SSE can use 8, Armv8 can use 32."
	VReg0 := #undefined.
	VReg1 := #undefined.
	VReg2 := #undefined.
	VReg3 := #undefined.
	VReg4 := #undefined.
	VReg5 := #undefined.
	VReg6 := #undefined.
	VReg7 := #undefined.
		
	NumFloatRegisters	:= #undefined.	"Number of floating-point registers (we don;t do single-precision; we don't do xmm high (yet)."
]

{ #category : 'debug printing' }
CogAbstractRegisters class >> nameForFPRegister: reg [ "<Integer>"
	^#(DPFPReg0 DPFPReg1 DPFPReg2 DPFPReg3 DPFPReg4 DPFPReg5 DPFPReg6 DPFPReg7
		DPFPReg8 DPFPReg9 DPFPReg10 DPFPReg11 DPFPReg12 DPFPReg13 DPFPReg14 DPFPReg15)
		detect: [:sym| (classPool at: sym) = reg]
		ifNone: ['REG', reg printString, '?']
]

{ #category : 'debug printing' }
CogAbstractRegisters class >> nameForRegister: reg [ "<Integer>"
	^#(Arg0Reg Arg1Reg ClassReg FPReg ReceiverResultReg SPReg SendNumArgsReg TempReg
		LinkReg RISCTempReg VarBaseReg PCReg
		Extra0Reg Extra1Reg Extra2Reg Extra3Reg Extra4Reg Extra5Reg)
			detect: [:sym| (classPool at: sym) = reg]
			ifNone: ['REG', reg printString, '?']
]
