import lib.compress
import lib.uncompress
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

const DICTIONARY_PATH: string = "/usr/share/dict/words"
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
  let newDictionary = actionOnDictionary(dictionary, feat)
  var ofs = newFileStream(ofpath, fmWrite)
  if not isNil(ofs):
    for cWord in newDictionary:
      ofs.writeLine(cWord)
  else:
    echo fmt("Canno't open '{ofpath}' file")

when isMainModule:
  echo fmt("> Compressing {DICTIONARY_PATH} in {COMPRESSED_FILE_PATH}...")
  actionOnDictionaryFromFile(DICTIONARY_PATH, CompressionBehavior.comp)
  echo "Done!"
  echo fmt("> Uncompressing {COMPRESSED_FILE_PATH} in {UNCOMPRESSED_FILE_PATH}...")
  actionOnDictionaryFromFile(COMPRESSED_FILE_PATH, CompressionBehavior.uncomp)
  echo "Done!"