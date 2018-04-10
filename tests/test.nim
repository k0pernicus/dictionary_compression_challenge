import
  unittest, lib.compress, lib.uncompress

suite "my suite":
  setup:
    echo "suite setup"
    var testVar = "from setup"

  teardown:
    echo "suite teardown"

  test "test compress":
    check(compress("hola", "hello") == "1e1lo")
    check(compress("hello", "hollo") == "1o3")
    check(compress("commence", "commencer") == "8r")
    check(compress("commencer", "commence") == "8")
    check(compress("bonjour", "hola") == "h1la")

  test "test uncompress":
    check(uncompress("hola", "1e1lo") == "hello")
    check(uncompress("hello", "1o3") == "hollo")
    check(uncompress("commence", "8r") == "commencer")
    check(uncompress("commencer", "8") == "commence")
    check(uncompress("bonjour", "h1la") == "hola")