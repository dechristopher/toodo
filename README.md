# toodo

A console utility for displaying an organized list of TODO and FIXME comments in a working directory.

```bash
Install: git clone https://github.com/dechristopher/toodo && ./toodo/toodo.sh install
 - Drops script to /usr/local/bin/td

Usage: td <directory> <file extension regex>
Directory defaults to durrent directory and extension defaults to .go files

Examples:

td . *.go
td /var/www *.php
td ~/git
```

TODO:

- Improve argument parsing
- Rewrite in go?
