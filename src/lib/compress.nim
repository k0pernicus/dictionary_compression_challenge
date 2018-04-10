import options
import sequtils
import strutils

proc toString*(s: seq[char]): string =
  result = newStringOfCap(s.len)
  copymem(result.addr, s.unsafeAddr, s.len)

## rootWord may be the word with rootWord.len() <= otherWord.len()!
proc getRoot*(rootWord, otherWord: string): uint32 =
  var (shortWord, longWord) = (rootWord, otherWord)
  if rootWord.len() > otherWord.len():
    swap(shortWord, longWord)
  result = 0
  # Compare the two first characters
  if shortWord[0] != longWord[0]:
    return result
  # Check if those two words have the same root
  if longWord.startsWith(shortWord):
    return (uint32) shortWord.len() 
  # Custom computation
  for i in 0..shortWord.len():
    if shortWord[i] != longWord[i]:
      break
    result += 1

# TODO: If the compression length == original length, returns the original length
proc compress*(previousWord, originalWord: string): string =
  result = ""
  var (previous, original) = (previousWord, originalWord)
  while original.len() != 0:
    # The min is here to avoid numbers > 10 (for simplicity)
    let nbSameChar = min(getRoot(previous, original), 9)
    if nbSameChar == 0:
      result.add(original[0])
      (previous, original) = (previous[1..^1], original[1..^1])
    else:
      result.add($nbSameChar)
      (previous, original) = (previous[nbSameChar..^1], original[nbSameChar..^1])
    if previous.len() == 0:
      result.add(original)
      break