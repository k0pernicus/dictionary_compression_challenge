# dictionary_compression_challenge

Challenge based on the [blog post of JM Archer](https://jmarcher.io/programming-challenge-dictionary-compression/), just for fun!

To run the program, you will need nim > 0.18.0

Once the nim compiler installed:
```
cd dictionary_compression_challenge
nimble test
nimber build
./dict_compression
```

### NOTE  
This program runs *only* on macOS and GNU/Linux, because the program will process the `/usr/share/dict/words` file, stored in the filesystem.