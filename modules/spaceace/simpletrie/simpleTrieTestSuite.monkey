Strict

Import mojo
Import spaceace.combinatorics.cMassPermuter
Import cTrie
Import cSymbolFrequencyList

Function Main:Int()
	Local date:Int[] = GetDate()
	Seed = date[5] | date[6]

	Trie.SetAlphabet("esairontlducgpmhbyfkwvzxjq".Split(""))
	
	Local root:TrieNode = New TrieNode()
	
	Print "Loading " + LoadString("testDict.txt").Split("~n").Length + " words."
	Local milliseconds:Int = Millisecs()
	Local dictionary:String[] = LoadString("testDict.txt").Split("~n")
	For Local word:String = EachIn(dictionary)
		If Not (word)
			Continue
		EndIf
		Trie.Insert(root, word)
	Next
	Print "Done in " + (Millisecs() -milliseconds) + " milliseconds."
	Print ""
	
	Print "Calculating letter frequency"
	milliseconds = Millisecs()
	Local frequencyList:List<SymbolFrequencyPair> = Trie.GetSymbolFrequency(root)
	Print "Done in " + (Millisecs() -milliseconds) + " milliseconds."
	Print "The letters in descending order of frequency are: "
	frequencyList.Sort()
	Local s:String
	For Local frequencyPair:SymbolFrequencyPair = EachIn(frequencyList)
		s += frequencyPair.symbol
	Next
	Print s
	Print ""
	
	
	Print "Looking up every word used to create trie; there should be no failures."
	Local lookupResults:Int[2]
	milliseconds = Millisecs()
	For Local word:String = EachIn(dictionary)
		lookupResults[Int(Trie.Contains(root, word))] += 1
	Next
	Print dictionary.Length + " words looked up in " + (Millisecs() -milliseconds) + " milliseconds."
	Print lookupResults[1] + " successes; " + lookupResults[0] + " failures."
	Print ""
	
	Local lookups:Int = Min(10000, dictionary.Length)
	Local lookupIndex:Int = Rnd(dictionary.Length - (lookups - 1))
	Print "Grabbing " + lookups + " words starting at index " + lookupIndex
	Local wordsToLookUp:String[] = dictionary[lookupIndex .. lookups + lookupIndex]
	Print "Corrupting some words to force failures."
	For Local i:Int = 0 To wordsToLookUp.Length - 1
		If (Rnd(10) < 2)
			For Local j:Int = 0 To 3
				wordsToLookUp[i] += Trie.ALPHABET[Rnd(Trie.ALPHABET.Length)]
			Next
		EndIf
	Next
	lookupResults = New Int[2]
	milliseconds = Millisecs()
	For Local word:String = EachIn(wordsToLookUp)
		lookupResults[Int(Trie.Contains(root, word))] += 1
	Next
	Print lookups + " words looked up in " + (Millisecs() -milliseconds) + " milliseconds."
	Print lookupResults[1] + " successes; " + lookupResults[0] + " failures."
	Print ""

	Print "Testing GetNode(). Real words should return a leaf node."
	Print "Bogus words should return Trie.NIL, or a legitimate node, depending on returnPartial."
	Local node:TrieNode = Trie.GetNode(root, "zyzzyvas")
	Print "zyzzyvas (real)"
	Print "NIL? " + Int(node = Trie.NIL)
	Print "Leaf Node? " + Int(node And node.isLeaf)
	node = Trie.GetNode(root, "probustus")
	Print "probustus (baloney)"
	Print "NIL? " + Int(node = Trie.NIL)
	Print "Leaf Node? " + Int(node And node.isLeaf)
	node = Trie.GetNode(root, "zgyhal", False)
	Print "zgyhal (baloney)"
	Print "NIL? " + Int(node = Trie.NIL)
	Print "Leaf Node? " + Int(node And node.isLeaf)
	node = Trie.GetNode(root, "hypocrite")
	Print "hypocrite (real)"
	Print "NIL? " + Int(node = Trie.NIL)
	Print "Leaf Node? " + Int(node And node.isLeaf)
	Print ""

	Print "Selecting ~qomni~q as the starting node. Only words that start with ~qomni~q should be found."
	Print "Example: bus will be found, because ~qomnibus~q is a word. ~qSled~q will not be found, because ~qomnisled~q is not a word."
	Local tmpRoot:TrieNode = Trie.GetNode(root, "omni")
	Local omniWord:String = "bus"
	Print "Found " + omniWord + "? " + Int(Trie.Contains(tmpRoot, omniWord))
	omniWord = "tickle"
	Print "Found " + omniWord + "? " + Int(Trie.Contains(tmpRoot, omniWord))
	omniWord = "arch"
	Print "Found " + omniWord + "? " + Int(Trie.Contains(tmpRoot, omniWord))
	omniWord = "cow"
	Print "Found " + omniWord + "? " + Int(Trie.Contains(tmpRoot, omniWord))
	Print ""
		
	Local testString:String = "aoepdlvk"
	Print "MassPermuting and looking up all variations of a single " + testString.Length + "-character string."
	lookupResults = New Int[2]
	milliseconds = Millisecs()
	Local mp:MassPermuter<String> = New MassPermuter<String>(testString.Split(""))
	While (mp.NextValue())
		lookupResults[Int(Trie.Contains(root, Implode(mp.GetCurrentValue())))] += 1
	Wend
	Print mp.Length() + " permutations looked up in " + (Millisecs() -milliseconds) + " milliseconds."
	Print lookupResults[1] + " successes; " + lookupResults[0] + " failures."
	Print ""

	Local numberOfWordsToPermute:Int = 10
	Print "MassPermuting and looking up all variations of " + numberOfWordsToPermute + " random words from the dictionary."
	Local totalPermutations:Int = 0
	lookupResults = New Int[2]
	milliseconds = Millisecs()
	For Local i:Int = 0 To numberOfWordsToPermute - 1
		Local randomWord:String = dictionary[Rnd(dictionary.Length)]
		mp = New MassPermuter<String>(randomWord.Split(""))
		totalPermutations += mp.Length()

		While (mp.NextValue())
			lookupResults[Int(Trie.Contains(root, Implode(mp.GetCurrentValue())))] += 1
		Wend
	Next
	Print totalPermutations + " permutations looked up in " + (Millisecs() -milliseconds) + " milliseconds."
	Print lookupResults[1] + " successes; " + lookupResults[0] + " failures."
	Print ""
	
	root = New TrieNode()
	Print "The following function should output these words:"
	Print Implode(dictionary[ .. Min(20, dictionary.Length - 1)], ", ")
	For Local word:String = EachIn(dictionary[ .. Min(20, dictionary.Length - 1)])
		Trie.Insert(root, word)
	Next
	
	Local lexicon:StringStack = New StringStack()
	Trie.GetLexicon(root, lexicon)

	Print "Survey SAYS:"
	Print Implode(lexicon.ToArray(), ", ")
	Print ""
	
	Print "The alphabet used for all tests above is: "
	Print Implode(Trie.ALPHABET)
	
	Return 0
End Function


' Currently infinite-looping

Function Implode:String(arr:String[], seperator:String = "")
	Local s:String
	For Local i:Int = 0 To arr.Length - 1
		s += arr[i]
		If (i < arr.Length - 1)
			s += seperator
		EndIf
	Next
	
	Return s
End Function

