# Assembly Language

This repository contains coursework and programs from the Assembly Language course at **FAST NUCES**.

## 📖 About This Course

Assembly Language bridges the gap between high-level programming and computer hardware. The course covers low-level programming using x86 architecture, teaching how processors execute instructions, how memory is managed at the register level, and how programs interact directly with hardware.

## 🗂️ Topics Covered

- Number systems — binary, octal, hexadecimal
- Registers and memory addressing modes
- MOV, arithmetic, and logical instructions
- Branching and looping (JMP, JE, JNE, LOOP)
- Procedures and the stack
- String operations
- Interrupts and system calls (INT 21h)
- Macros and modular programming
- File handling in Assembly

## 🛠️ Tools Used

![NASM](https://img.shields.io/badge/NASM-Assembler-lightgrey?style=flat&logo=buffer&logoColor=white)
![Notepad++](https://img.shields.io/badge/Notepad++-Editor-green?style=flat&logo=notepadplusplus&logoColor=white)
![DOSBox](https://img.shields.io/badge/DOSBox-Emulator-yellow?style=flat&logo=windows-terminal&logoColor=white)

## ⚙️ Setup & How to Run

### Requirements
- [Notepad++](https://notepad-plus-plus.org/) — for writing `.asm` source files
- [NASM](https://www.nasm.us/) — assembler to compile `.asm` files
- [DOSBox](https://www.dosbox.com/) — to emulate the DOS environment for running programs

### Steps

1. Clone the repository
   ```bash
   git clone https://github.com/talha586/Assembly-Language.git
   ```

2. Open the `.asm` file in **Notepad++**

3. Assemble using NASM
   ```bash
   nasm -f bin filename.asm -o filename.com
   ```

4. Run in DOSBox
   ```
   Open DOSBox → mount your directory → type filename.com
   ```

## 👨‍💻 Author

**Muhammad Talha** — CS Student at FAST NUCES, Lahore
