## SpaceAce's Trie for Monkey-X

### A simple implementation of a trie data structure

**How is trie pronounced?**

Try, tree, whatever.


**What is a trie?**

A trie is is a data structure used for storing information as an interconnected set of nodes. Tries are commonly used to store strings. For this example, let's assume you are using the trie to store a 
dictionary of words, because that's what I'm using it for, and I'm the one writing this. Your dictionary graph might look something like this:

![trie](http://i.imgur.com/5Ls5yQz.png)

The connecting lines show references from one node to another. Each node can have at most [number of symbols in your alphabet] connections to other nodes. The connections only point in one direction. 
You cannot travel back up the trie.

The green nodes represent leaf nodes. A leaf node is a terminating node, meaning that it is the last node of a series, representing the terminal point of a string. Let's say the first word you insert 
into your trie is "ace." The insert code starts at the root node (not visible in this diagram - it has no values of its own, only references to the nodes under it), and creates a new node in the "a" 
position. The code then descends into the "a" node, creates the "c" node, descends into that, and creates the "e" node. Now, having reached the end of the word you were inserting, the "e" node is marked 
as a leaf node. Next, you insert the word "aced." The code sees that the "a" node already exists, and descends into it, then into the "c" node, then the "e" node, where it creates the non-existend "d" 
node, and marks it as a leaf. Insertions carry on in this manner, traversing existing nodes, creating new nodes where necessary, and marking the terminal node of each string as a leaf.

Lookups work in essentially the same fashion; you traverse the nodes until you hit a node that doesn't exist (lookup failed), reach the last letter of your search string, but the last letter is not a 
terminal node (lookup failed), or reach the last letter of your search string, which ends on a leaf node (lookup succeeded.)

Tries are very efficient in that they store very little repeated data. Any two words in the trie will automatically share the longest possible prefix before splitting off from one another. Because of 
this property, tries are also known as prefix trees.


**Installation**

Simply clone this repository, and merge the modules folder with your Monkey-X modules folder.


**Usage**

To use the tree, you create a TrieNode, and insert data into the node.
```
Trie.SetAlphabet(["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"])
Local dictionary:String[] =["alphabet", "xylophone", "scrub", "photosensitive"]
Local root:TrieNode = New TrieNode()
For Local word:String = EachIn(dictionary)
	Trie.Insert(root, word)
Next
		
Print Int(Trie.Contains(root, "photosensitive"))
Print Int(Trie.Contains(root, "electrocution"))
Print Int(Trie.Contains(root, "missive"))
Print Int(Trie.Contains(root, "xylophone"))
```
Output:
```
1
0
0
1
```

The Trie alphabet defaults to lower-case a-z. The call to SetAlphabet() is just for illustration, here.

