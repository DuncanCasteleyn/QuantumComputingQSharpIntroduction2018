﻿namespace Deutsch
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	// qOutput:  |0> --- --- --- --- |0>
	// qInput :  |x> --- --- --- --- |x>
    operation ConstantZero (qOutput: Qubit, qInput: Qubit) : Unit
    {
    }

	// qOutput:  |0> --- --- -X- --- |1>
	// qInput :  |x> --- --- --- --- |x>
    operation ConstantOne (qOutput: Qubit, qInput: Qubit) : Unit
    {
        X(qOutput);
    }

	// qOutput:  |0> --- -O- --- --- |x>
	// qInput :  |x> --- -|- --- --- |x>
    operation Identity (qOutput: Qubit, qInput: Qubit) : Unit
    {
        CNOT(qInput, qOutput);
    }

	// qOutput:  |0> --- -O- -X- --- |!x>
	// qInput :  |x> --- -|- --- ---  |x>
    operation Negation (qOutput: Qubit, qInput: Qubit) : Unit
    {
		CNOT(qInput, qOutput);
		X(qOutput);
    }
	
	// qOutput:  |0> -X- -H- -BB- -H- -M- |!x>
	// qInput :  |x> -X- -H- -BB- -H- -M-  |x>
	operation Deutsch (blackbox: ((Qubit, Qubit) => Unit)) : (Bool, Bool)
	{
		mutable result = (false, false);
		using(register = Qubit[2])
		{
			let qOutput = register[0];
			let qInput = register[1];

			X(qOutput);
			X(qInput);

			H(qOutput);
			H(qInput);

			blackbox(qOutput, qInput);
				
			H(qOutput);
			H(qInput);

			let bOutput = M(qOutput);
			let bInput = M(qInput);

			set result = (bInput == One, bOutput == One);

			if(bOutput == One)
			{
				X(qOutput);
			}
			if(bInput == One)
			{
				X(qInput);
			}
		}

		return result;
	}

	operation DeutschTestConstantZero() : (Bool, Bool)
	{
		return Deutsch(ConstantZero);
	}

	operation DeutschTestConstantOne() : (Bool, Bool)
	{
		return Deutsch(ConstantOne);
	}

	operation DeutschTestIdentity() : (Bool, Bool)
	{
		return Deutsch(Identity);
	}

	operation DeutschTestNegation() : (Bool, Bool)
	{
		return Deutsch(Negation);
	}
}