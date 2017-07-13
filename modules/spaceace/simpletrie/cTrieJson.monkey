Strict

Import cTrie
Import cTrieNode
Import brl.json

#rem monkeydoc
	Provides static functions to traverse a Trie, and return its contents as JSON, as
	well as functions to restore a Trie from JSON data.
#END
Class TrieJson
	#rem monkeydoc
		As Monkey-X doesn't have pass-by-reference for fundamental types,
		such as String, we'll just collect the JSON in this Global (equivalent
		of static in other languages) variable.
		
		Alternatively, we could use an array or an object to achieve this 
		goal, but the static variable is the simplest approach.
	#END
	Global trieAsJson:String
	
	#rem monkeydoc
		Acts as a launcher function that kicks off the recursive Trie descent.
		This function expects the Trie alphabet to be the one that rootNode
		and all its children were built from.
	#END
	Function TrieToJson:String(rootNode:TrieNode)
		Local json:String = "{"

		Local alphabetAsString:String = ""
		alphabetAsString = alphabetAsString.Join(Trie.ALPHABET)
		json += "~qalphabet~q: ~q" + alphabetAsString + "~q"
		json += ", ~qleaf_node_count~q: " + Trie.LEAF_NODE_COUNT

		json += ", ~qtrie~q:"
		json += "{"
		RecurseIntoTrie(rootNode)
		json += trieAsJson
		json += "}"
		
		json += "}"

		Return json
	End Function
	
	#rem monkeydoc
		Recursively descends into all children of rootNode, building and returning
		a JSON string representing the complete Trie from rootNode on down.
	#END
	Function RecurseIntoTrie:Void(currentNode:TrieNode)
		Local liveNodesFound:Int = 0
		' _ is the index that corresponds to "isLeaf," because including a string
		' like "isLeaf" in every single node of the Trie would make the JSON much
		' larger than necessary, and hurt its compactness.
		' Furthermore, why store "true" and "false," when 0 or 1 will do?
		' In fact, why store anything at all when the value is false? We'll
		' only store a value if isLeaf is true.
		'
		' The Trie alphabet is intended to composed of single symbols or objects. 
		' In order to make sure we don't conflict with a user's alphabet, we'll
		' use a two-symbol key to store the isLeaf value.
		If (currentNode.isLeaf)
			trieAsJson += "~q__~q:1"
		EndIf
		For Local alphabetIndex:Int = 0 To Trie.ALPHABET.Length - 1
			Local symbol:String = Trie.ALPHABET[alphabetIndex]
			If (currentNode.children[alphabetIndex])
				If (currentNode.isLeaf Or liveNodesFound > 0)
					trieAsJson += ","
				EndIf
				trieAsJson += "~q" + symbol + "~q:"
				trieAsJson += "{"
				RecurseIntoTrie(currentNode.children[alphabetIndex])
				trieAsJson += "}"
				liveNodesFound += 1
			EndIf
		Next
	End Function
	
	Function FromJson:TrieNode(json:String)
		Local rootJsonObject:JsonObject = JsonObject(json)
		Local alphabet:String = rootJsonObject.GetString("alphabet")
		Local leafNodeCount:Int = rootJsonObject.GetInt("leaf_node_count")
		Trie.SetAlphabet(alphabet.Split(""))
		Trie.LEAF_NODE_COUNT = leafNodeCount
		Local trieJsonObject:JsonObject = JsonObject(rootJsonObject.Get("trie"))
		Local rootNode:TrieNode = New TrieNode(Trie.ALPHABET.Length)
		RecurseIntoJson(trieJsonObject, rootNode)
		
		Return rootNode
	End Function
	
	Function RecurseIntoJson:Void(currentJsonObject:JsonObject, node:TrieNode)
		Local data:StringMap<JsonValue> = currentJsonObject.GetData()
		Local isLeaf:Bool = False
		If (data.Contains("__"))
			data.Remove("__")
			isLeaf = True
		EndIf
		For Local jv:map.Node<String, JsonValue> = EachIn(data)
			node.children[Trie.IndexFromCharacter(jv.Key)] = New TrieNode(Trie.ALPHABET.Length)
			Local objectToRecurseInto:JsonObject = JsonObject(jv.Value.ToJson())
			RecurseIntoJson(objectToRecurseInto, node.children[Trie.IndexFromCharacter(jv.Key)])
		Next
		
		node.isLeaf = isLeaf
	End Function
End Class