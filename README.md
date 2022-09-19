# PAL-1 Hacks
Dump of 6502 Assembly code for the PAL-1 SBC.

![That's my PAL!](images/mypal.jpg)

## Perquisites
- [cc650](https://cc65.github.io) cross development kit.
- [srecord](http://srecord.sourceforge.net) tool kit.
- [GNU Make](https://www.gnu.org/software/make/) tool.
- [minicom](https://salsa.debian.org/minicom-team/minicom) serial communication program.
### Mac OS Instructions
- Install cc65 `brew install cc65`
- Install srecord `brew install srecord`
- Install minicom `brew install minicom`

## Programs
### `abirahasa` -> Abirahasa Game Interpreter
A text adventure game interpreter that works over TTY
```
make -C abirahasa
```
**How To Play**

1. First load interpreter `abirahasa.ptp`.
2. Load a game file next such as `abirahasa_story1.ptp`.
3. Start the interpreter at 0x0200 address.

### `hellotty` -> Demonstration Of KIM-1 TTY Routines
Using KIM-1 ROM TTY related routines
```
make -C hellotty
```

### `kimio` -> Demonstration Of KIM-1 Onboard IO
Using KIM-1 keypad and dispay subroutines built into ROM.
```
make -C kimio
```