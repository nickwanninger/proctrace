global _start

_start:
	mov edi, 10
	call fib

	mov rdi, rax

	mov rax, 60      ; system call for exit
	xor rdi, rdi     ; exit code 0
	syscall          ; invoke operating system to exit


fib:
  push rbp
  mov rbp, rsp
  push rbx
  sub rsp, 24
  mov DWORD [rbp-20], edi
  cmp DWORD [rbp-20], 1
  jg .L2
  mov eax, DWORD [rbp-20]
  jmp .L3
.L2:
  mov eax, DWORD [rbp-20]
  sub eax, 1
  mov edi, eax
  call fib
  mov ebx, eax
  mov eax, DWORD [rbp-20]
  sub eax, 2
  mov edi, eax
  call fib
  add eax, ebx
.L3:
  mov rbx, QWORD [rbp-8]
  leave
  ret
