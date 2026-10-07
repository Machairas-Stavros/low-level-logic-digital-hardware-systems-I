# low-level-logic-digital-hardware-systems-I

<div align="justify">

Semester project for the subject "Low Level Logic Digital Hardware Systems I" for the seventh semester of the undergraduate studies program in Electrical and Computer Engineering of Airstotle University of Thessaloniki. <br>

The project refers to the design implementation and testing of a RISC-V type processor using verilog as it is depicted in the image below. <br>

![RISC-V Architecture](photos/Control%20Unit%20Diagram.png)

<br>

Within the source code files, there are two additioinal files: "rom.v" and "ram.v", while the base of the repository a ".data" file is provided. The first two files are archives referring to the instruction memory and the data memory, respectively. The latter file containins the initialized instructions used to run simulations in the testbench. There is also a file called "top_proc_alternate.v" which presents a slightly different approach to the project when it comes to the FSM section. The file referring to the testbench of this approach is the same as the “top_proc.v” file. The change that needs to be made is in the inclusion statement where the file name “top_proc.v” must be replaced with “top_proc_alternate.v”.

</div>