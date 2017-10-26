# toodo

A console utility for displaying an organized list of TODO and FIXME comments in a working directory.

```
Install: ./toodo.sh install

Usage: td <directory> <file extension regex>
Directory defaults to durrent directory and extension defaults to .go files

Examples: 

td . *.go
td /var/www *.php
td ~/git
```

TODO:

- FIXME comment parsing and listing
- Rewrite in go?
- Install subroutine built in
