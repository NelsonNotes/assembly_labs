nasm -f elf64 -o lab5_main.o lab5_main.asm
g++ -o lab5 lab5_interface.cpp lab5_main.o

# g++ -O0 -c lab5_interface.cpp
# ghex lab5_interface.o