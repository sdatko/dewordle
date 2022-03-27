dewordle
========

![](https://github.com/sdatko/dewordle/workflows/tests/badge.svg)

Shell script for assisting in solving the Wordle quiz [1].

It was created out of curiosity how such tool may look like.
No guarantees. It may either help or reduce satisfaction.
Use at your own risk ;-)


# Usage

```
Usage: ./dewordle.sh POSITIONS [ALPHABET [LETTERS]]

POSITIONS -- pattern of letters with positions we are sure
ALPHABET -- set of possible letters to check; default is: a-z
LETTERS -- confirmed letters, with unknown positions; default empty

NOTE: For POSITION, a regular expression is expected with dots (.)
      representing any character; for first run just try: .....

NOTE: For ALPHABET, a negative set can be given, e.g. ^abc means
      that none of letters a, b or c should be part of the string.
```


## Example

Find a word that has `o` as second letter and `l` as fourth letter,
containing letters `a` and `g` at some positions, but for sure
no `p`, `q` and `r` anywhere.

```
./dewordle.sh .o.l. ^pqr ag
```


## Using own dictionary

By default, the script looks for `~/.dewordle-words` file in system.

If this file is not present, it downloads the example file from [2].

Alternatively, one may use their own dictionary file. The expected
format should match standard Unix `words` file [3], i.e. one word
in each line.

Having the `wordlist` or `words` package installed, the following
symbolic link should work:

```
ln -s /usr/share/dict/words ~/.dewordle-words
```


# Acknowledgments

The example file URL [2] was taken from Wikipedia [3].

[1] https://www.nytimes.com/games/wordle/

[2] https://users.cs.duke.edu/~ola/ap/linuxwords

[3] https://en.wikipedia.org/wiki/Words_(Unix)
