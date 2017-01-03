Strict

Class TrieNode
	Field children:TrieNode[]
	Field isLeaf:Bool
	
	Method New(alphabetLength:Int = 26)
		children = New TrieNode[alphabetLength]
		isLeaf = False
	End Method
End Class
