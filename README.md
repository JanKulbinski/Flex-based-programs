# Flex-based-programs
My first programs with lexical analyzer FLEX.


Programs:


1) Reads any text file, deletes all of it whitespace at the end and beginning of the line, changes all instances of tabs and spaces to exactly one space, eliminates empty lines, and at the end writes a number
of lines and words (strings separated by whitespace).

2) Deletes all comments in XML source file.

3) Deletes all comments in programs written
in C ++, and after enabling the option leaves documentation comments
(according to Doxygen: / **, / * !, /// and //!) and removes the others.

4) A simple postfix calculator (reverse Polish notation)
for integers performing operations of addition (+), subtraction (-), multiplication (*),
integer division (/), exponentiation (^) and modulo (%). Expression to count
should be written on one line. The program displays the result for each line
or error message (as detailed as possible). Example:
```
2 3+4*
= 20
1 2 3 4 + * -
= -13
-1 2 -3 4 + * -
= -3
8 -7 6 -5 4 * -3 % / - +
= 4
```
