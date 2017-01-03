Strict

Import cSymbolFrequencyPair

Class SymbolFrequencyList Extends List<SymbolFrequencyPair>
	Method New(data:SymbolFrequencyPair[])
		Super.New(data)
	End Method
	
	Method Compare:Int(lhs:SymbolFrequencyPair, rhs:SymbolFrequencyPair)
		Return lhs.occurrences < rhs.occurrences
	End Method
End Class