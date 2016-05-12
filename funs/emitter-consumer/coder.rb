# Bencoding exercise

exit

Bencoding is the wire encoding format that is used in the Bittorrent protocol.

The point of this exercise is to implement the bencoding format, by taking a bencoded string as input,
and converting it to native Java types, which in turn are converted to a JSON string as output.

## Working implementation

A working version will implement the following cases:

    Bencoding.decode("i15e")                                        : 15
    Bencoding.decode("3:dog")                                       : "dog"
    Bencoding.decode("8:robots54")                                  : "robots54"
    Bencoding.decode("l5:green3:red4:bluee")                        : ["green", "red", "blue"]
    Bencoding.decode("d4:user3:bob3:agei47ee")                      : {"user”: "bob", "age”: 47}
    Bencoding.decode("d5:usersl3:bob4:mikee6:colorsl3:red4:blueee") : {"users”: ["bob", "mike"], "colors”: ["red", "blue"]}

## Types

Bencoding supports 4 different types.  You can think of the prefix and suffix as delimiters that open and close like parentheses.
      
      Prefix    Length    Suffix
Integer      i    n/a    e
String      XX:    from prefix  n/a
List/Array    l    n/a    e
Dictionary/Map/Hash  d    n/a    e

### Integers

Integers are represented with delimiters 'i' and 'e'.

Some examples:

    10      = "i10e"
    154     = "i154e"
    100349  = "i100349e"

### Strings

Strings are prefixed with their string length as an integer, followed by a ':' character, and then the characters that make up that string.

Some examples:

    "house"       = "5:house"
    "dog"         = "3:dog"
    "I love ruby" = "11:I love ruby"

### Lists (Arrays)

Lists are prefixed with an 'l' character, filled with a variable number of other bencoded types, then end with an 'e' character delimiter.

Some examples:

    [4]                           = "li4ee"
    ["blue", "red"]               = "l4:blue3:rede"
    ["cat", "dog", "parrot", 27]  = "l3:cat3:dog6:parroti27ee"

### Dictionaries (Hashes)

Dictionaries are prefixed with a 'd' character, filed with a variable number of other bencoded types, then end with an 'e' character delimiter.

Some examples:

    {"animal" : "cat"}             = "d6:animal3:cate"
    {"animal" : "cat", "age" : 3} = "d6:animal3:cat3:agei3ee"
