import strformat
import strutils
import sequtils

proc uncompress*(previousWord, currentWord: string): string =
  result = ""
  var previousWordCopy = previousWord
  for c in currentWord:
    let i = int(c) - int('0')
    if i>0 and i<=9:
      result.add(previousWordCopy[0..i-1])
      previousWordCopy = previousWordCopy[i..^1]
    else:
      result.add(c)
      if previousWordCopy.len() != 0:
        previousWordCopy = previousWordCopy[1..^1]
