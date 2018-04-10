import strformat
import strutils
import sequtils

proc uncompress*(previousWord, currentWord: string): string =
  result = ""
  var previousWordCopy = previousWord
  for c in currentWord:
    if c in {'1'..'9'}:
      let i = ord(c) - ord('0')
      result.add(previousWordCopy[0..i-1])
      previousWordCopy = previousWordCopy[i..^1]
    else:
      result.add(c)
      if previousWordCopy.len() != 0:
        previousWordCopy = previousWordCopy[1..^1]
