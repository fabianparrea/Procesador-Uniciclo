ADDI (at 0x0): Adds x10 and immediate 5, stores in x5.
Encoding: 000000000101 01010 000 00101 0010011
Hex: 00550293
SW (at 0x4): Stores x5 to memory at x2 + 8.
Hex: 00512423
LW (at 0x8): Loads data from x2 + 8 (value of x5) into x6.
Hex: 00812303
ADDI (at 0xC): Adds x8 (initially 0) and immediate 1, stores in x8. Ensures x8 ≠ x9 (since x9 is 0).
Encoding: 000000000001 01000 000 01000 0010011
Hex: 00140413
ADD (at 0x10): Adds x5 (from first ADDI) and x6 (from LW, same as x5), stores in x7. This sums past results.
Encoding: 0000000 00110 00101 000 00111 0110011
Hex: 006283B3
BEQ (at 0x14): Compares x8 and x9. Since x8 = 1, x9 = 0, branch to 0x1C (offset 8) fails.
Hex: 00940063
JAL (at 0x18): Jumps to 0x0 (offset -24 bytes from 0x18), stores return address (0x1C) in x1.
Encoding: 1111111 01000 11111111 00001 1101111
Hex: FE9FF06F


00512423
00812303
00140413
006283B3
00940063
FE9FF06F

Estas instrucciones se partieron en el archivo de texto program.mem, para colocarlas en la memoria de instrucciones que tiene el Byte como unidad mínima direccionable. Así:

00550293

93 posición 0 del arreglo (PC inicial)
02 posición 1 del arreglo
55 posición 2 del arreglo
00 posición 3 del arreglo

00812303

03 posición 4 del arreglo (PC+4)
23 posición 5 del arreglo
81 posición 6 del arreglo
00 posición 7 del arreglo

00140413

13 posición 8 del arreglo (PC+4)
04 posición 9 del arreglo
14 posición A del arreglo
00 posición B del arreglo

...etc