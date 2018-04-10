import lib.compress
import lib.uncompress
import os
import streams
import strformat
import strutils

type 
  Dictionary = seq[string]

# comp -> Compress
# uncomp -> Uncompress
type
  CompressionBehavior = enum
    comp, uncomp

const COMPRESSED_FILE_PATH = "compressed_dictionary.txt"
const UNCOMPRESSED_FILE_PATH = "uncompressed_dictionary.txt"

# TODO: Compress/Uncompress via ENUM
proc actionOnDictionary(dictionary: Dictionary, feat: CompressionBehavior): Dictionary =
  var rootWord = dictionary[0]
  result = @[rootWord]
  if feat == CompressionBehavior.comp:
    for word in dictionary[1..<dictionary.len()]:
      result.add compress(rootWord, word)
      rootWord = word
  else:
    for word in dictionary[1..<dictionary.len()]:
      rootWord = uncompress(rootWord, word)
      result.add rootWord

proc actionOnDictionaryFromFile(pathfile: string, feat: CompressionBehavior) =
  var ofpath = COMPRESSED_FILE_PATH
  if feat == CompressionBehavior.uncomp:
    ofpath = UNCOMPRESSED_FILE_PATH
  var line: string = ""
  var fs = newFileStream(pathfile, fmRead)
  var dictionary: Dictionary = @[]
  if not isNil(fs):
    while fs.readLine(line):
      dictionary.add(line.toLowerAscii())
  else:
    echo fmt("Canno't open '{pathfile}' file")
    quit(QuitFailure)
  let newDictionary = actionOnDictionary(dictionary, feat)
  var ofs = newFileStream(ofpath, fmWrite)
  if not isNil(ofs):
    for cWord in newDictionary:
      ofs.writeLine(cWord)
  else:
    echo fmt("Canno't open '{ofpath}' file")
    quit(QuitFailure)

when isMainModule:
  let argv = commandLineParams()
  if argv.len() == 0:
    let programName = getAppFilename()
    echo "Please to insert a text file that contains all the words to compress."
    echo fmt("For example: `{programName} /usr/share/dict/words`")
    quit(QuitFailure)
  let input_file = argv[0]
  echo fmt("> Compressing {input_file} into {COMPRESSED_FILE_PATH}...")
  actionOnDictionaryFromFile(input_file, CompressionBehavior.comp)
  echo "Done!"
  echo fmt("> Uncompressing {COMPRESSED_FILE_PATH} into {UNCOMPRESSED_FILE_PATH}...")
  actionOnDictionaryFromFile(COMPRESSED_FILE_PATH, CompressionBehavior.uncomp)
  echo "Done!"