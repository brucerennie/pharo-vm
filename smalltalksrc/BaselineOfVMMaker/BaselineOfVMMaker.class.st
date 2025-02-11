Class {
	#name : 'BaselineOfVMMaker',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfVMMaker',
	#package : 'BaselineOfVMMaker'
}

{ #category : 'baselines' }
BaselineOfVMMaker >> baseline: spec [
	<baseline>

	spec
		for: #common
		do: [
			
			"Slang, the basics"			
			spec
				package: 'CAST' with: [
					spec requires: #( 'SmaCC-GLR' )
				];
				package: 'Slang' with: [
					spec requires: #( 'CAST' )
				];
			
			"Melchor is a VM-oriented Slang"
			package: 'Melchor' with: [
				spec requires: #('Slang') ];
			
			package: 'Slang-Tests' with: [
					spec requires: #('Slang' 'Melchor') ].

			
			"External Dependencies"
			spec baseline: 'SmaCC-GLR' with: [ 
				spec
					loads: #( 'SmaCC-GLR-Runtime' );
					className: 'BaselineOfSmaCC';
					repository: 'github://guillep/SmaCC' ].
			spec baseline: 'Unicorn' with: [ 
				spec repository: 'github://pharo-project/pharo-unicorn:unicorn2' ].
			spec baseline: 'LLVMDisassembler' with: [ 
				spec repository: 'github://pharo-project/pharo-llvmDisassembler' ].
			spec baseline: 'OpalSimdBytecode' with: [ 
				spec repository: 'github://evref-inria/pharo-opal-simd-bytecode:main' ].

			"Tests"			
			spec
				package: 'VMMakerTests' with: [
					spec requires: #('VMMakerCompatibilityForPharo6' 'Unicorn' 'LLVMDisassembler' 'Slang-Tests' 'OpalSimdBytecode') ].

			"Tools"			
			spec package: 'VMMaker-Tools' with: [ 
				spec requires: #( 'VMMakerCompatibilityForPharo6' 'VMMakerTests' ) ].
			
			spec
				package: 'VMMakerCompatibilityForPharo6' with: [ spec requires: 'VMMaker' ];
				package: 'VMMakerLoadingDependencies'.
			
			"Dependencies from this repositories"
			spec 
				package: 'Printf'.
				
			"Main VMMaker packages"	
			spec
				package: 'VMMaker'
				with: [ spec requires: #( 
					'VMMakerLoadingDependencies' 'Printf' 'Melchor') ].
								
			"VM plugins"
			spec package: 'FileAttributesPlugin' with: [ spec requires: #( 'VMMakerCompatibilityForPharo6') ].
			
			spec group: 'plugins' with: #('FileAttributesPlugin').
			spec group: 'core' with: #('VMMaker').
			spec group: 'tools' with: #('VMMaker-Tools').			
			spec group: 'tests' with: #('VMMakerTests').
			spec group: 'default' with: #( 'core' 'plugins' 'tools' 'tests') ]
]
