# clipng

A CLI wrapper for testing [SwiftLIBPNG](https://github.com/carlynorama/SwiftLIBPNG) on Ubuntu.

Currently generates pngs with random pixel data depending on the command/flags.

```
OVERVIEW: A interface for testing SwiftLIBPNG.

USAGE: clipng <subcommand>

OPTIONS:
  --version               Show the version.
  -h, --help              Show help information.

SUBCOMMANDS:
  purple                  Generate a RGBA PNG file with each pixel a random shade of purple.
  random (default)        Generate a PNG file with each pixel a random color. 8 bit per channel.
                          Grayscale or color, with or without alpha, depending on the flags.
  vbars_grayscale         Generate a grayscale PNG where the first column is black, the second,
                          random, the third, white. If alpha flag is set, black and white columns
                          will have a random alpha.

  See 'clipng help <subcommand>' for detailed help.
```

## Subcommand: random

`swift run clipng 10 10` or `swift run clipng random 10 10` will generate a 10x10 RGB image. 

```
OVERVIEW: Generate a PNG file with each pixel a random color. 8 bit per channel. Grayscale or color, with or without alpha, depending on the flags.

USAGE: clipng random <width> <height> [--hex-output] [--verbose] [--alpha] [--grayscale]

ARGUMENTS:
  <width>
  <height>

OPTIONS:
  -x, --hex-output        Use hexadecimal notation for the result.
  -v, --verbose           Print extra information to the console.
  -a, --alpha             Generate PNG data with alpha channel.
  -g, --grayscale         Generate PNG data as a grayscale pallette. For functions where this not
                          implemented or relevant, flag will be ignored.
  --version               Show the version.
  -h, --help              Show help information.
```

## Subcommand: purple 

`swift run clipng purple 10 10` will generate a 10x10 image where every pixel is a random shade of purple. 

```zsh
OVERVIEW: Generate a RGBA PNG file with each pixel a random shade of purple.

USAGE: clipng purple <width> <height> [--hex-output] [--verbose] [--alpha] [--grayscale]

ARGUMENTS:
  <width>
  <height>
```

Note: grayscale flag is ignored. Alpha flag currently adds an alpha byte of 0xFF for every pixel. 

## Subcommand: vbars_grayscale

`swift run clipng random 10 10` 

```
OVERVIEW: Generate a grayscale PNG where the first column is black, the second, random, the third, white. If alpha flag is set, black and white columns will have a random alpha.

USAGE: clipng vbars_grayscale <width> <height> [--hex-output] [--verbose] [--alpha] [--grayscale]

ARGUMENTS:
  <width>
  <height>
```

Note: grayscale flag is ignored. 


## References

### Commandline Tools

- https://www.swift.org/blog/argument-parser/
- https://www.youtube.com/watch?v=pQt71tLmiac

Other example repos: 
- NO Argument parser: https://github.com/carlynorama/swift-scripting/
- ArgumentParser: https://github.com/carlynorama/tipsy-robot-swift/
