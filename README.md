# bottom racket

```
usage: bottom [ <option> ... ] [<text>] ...

<option> is one of

  -i <INPUT>, --input <INPUT>
     Input file [Default: command line]
  -o <OUTPUT>, --output <OUTPUT>
     Output file [Default: stdout]
/ -b, --bottomify
|    Translate bytes to bottom
| -r, --regress
|    Translate bottom to human-readable text (futile)
| -V, --version
\    Print version
  --help, -h
     Show this help
  --
     Do not treat any remaining argument as a switch (at this level)

 /|\ Brackets indicate mutually exclusive options.

 Multiple single-letter switches can be combined after
 one `-`. For example, `-h-` is the same as `-h --`.
```
