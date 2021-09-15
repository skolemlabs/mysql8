# mysql8 (ocaml)
A fork of the [mysql](https://github.com/ygrek/ocaml-mysql) library for OCaml to support MySQL 8+

## Changes
### Build
- Replaces GNU Make-based build system with dune

### C
- `my_bool` has been renamed to just `bool`.
- The deprecated/removed `MySQL` options have been removed.

### OCaml
- The deprecated/removed `MySQL` options have been removed.
- `ocamlformat` has been applied.

## Credits
- Original authors:
  - Christian Lindig
  - Shawn Wagner
  - ygrek
- Current authors:
  - Zach Baylin (@zbaylin)
