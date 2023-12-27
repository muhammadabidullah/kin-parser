# kin-insurance
Description

This Ruby code is designed to parse a file containing numbers represented in ASCII art and output the corresponding numerical digits. It includes a method to calculate the checksum of a number and determine whether it is valid, as well as methods to handle cases where a number cannot be parsed or has an error in its representation.

How to use

To use this code, you will need to have Ruby installed on your system. Once you have Ruby installed, you can run the code by executing the following command
ruby kin_parser.rb
You will need to keep an input file named input.txt in the same folder as this code file with the sample input
This will parse the file input.txt and output the corresponding numerical digits to a file called output.txt.

Output file format

The output file will contain one or more lines of numbers, where each number represents the corresponding numerical digit in the input file. If a number cannot be parsed or has an error in its representation, it will be replaced with a question mark ?. If there are multiple possible interpretations of a number, the output will include both the possible interpretations separated by the string AMB.

If a number has an error in its representation, the output will include the original number followed by the string ERR. If a number cannot be parsed, the output will include the original number followed by the string ILL.
Implementation details

The code works by defining a hash that maps each possible pattern of ASCII art to its corresponding numerical digit. It then reads in the input file, splits it into blocks of ASCII art, and uses the hash to convert each block into its corresponding numerical digit. If a number cannot be parsed, it uses a combination of replacing characters in the number and checksum validation to determine the correct interpretation. If a number has an error in its representation, it tries replacing each digit in turn with possible correct digits and validating the checksum to find the correct interpretation.

