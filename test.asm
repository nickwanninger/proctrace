global _start

_start:

	; exit(fib(N))
	mov edi, 2
	mov esi, 3
	call A

	mov rdi, rax
	mov rax, 60      ; system call for exit
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





A:
  mov ecx, edi
  test edi, edi
  je .L73
.L60:
  lea r8d, [rcx-1]
  test esi, esi
  jne .L75
  test r8d, r8d
  je .L64
  sub ecx, 2
  jmp .L63
.L70:
  mov esi, 2
  test ecx, ecx
  jne .L60
.L73:
  lea eax, [rsi+1]
  ret
.L75:
  sub esi, 1
  xchg ecx, r8d
.L63:
  lea edx, [r8-1]
  test esi, esi
  jne .L76
  test edx, edx
  je .L70
  sub r8d, 2
.L72:
  push r15
  push r14
  push r13
  push r12
  push rbp
  push rbx
  sub rsp, 24
.L10:
  lea r15d, [rdx-1]
  test esi, esi
  jne .L77
  sub edx, 2
  test r15d, r15d
  je .L78
.L14:
  lea r14d, [r15-1]
  test esi, esi
  jne .L79
  test r14d, r14d
  je .L41
  sub r15d, 2
.L18:
  lea r13d, [r14-1]
  test esi, esi
  jne .L80
  test r13d, r13d
  je .L42
  sub r14d, 2
.L22:
  lea r12d, [r13-1]
  test esi, esi
  jne .L81
  test r12d, r12d
  je .L43
  sub r13d, 2
.L26:
  lea ebp, [r12-1]
  test esi, esi
  jne .L82
  test ebp, ebp
  je .L44
  sub r12d, 2
.L30:
  lea ebx, [rbp-1]
  test esi, esi
  jne .L83
  test ebx, ebx
  je .L45
  sub ebp, 2
.L34:
  lea edi, [rbx-1]
  test esi, esi
  jne .L84
  test edi, edi
  je .L46
  sub ebx, 2
.L36:
  mov DWORD [rsp+12], ecx
  mov DWORD [rsp+8], edx
  mov DWORD [rsp+4], r8d
  call A
  test ebx, ebx
  mov r8d, DWORD [rsp+4]
  mov edx, DWORD [rsp+8]
  mov ecx, DWORD [rsp+12]
  mov esi, eax
  jne .L34
  add esi, 1
.L37:
  test ebp, ebp
  jne .L30
  add esi, 1
.L33:
  test r12d, r12d
  jne .L26
  add esi, 1
.L29:
  test r13d, r13d
  jne .L22
  add esi, 1
.L25:
  test r14d, r14d
  jne .L18
  add esi, 1
.L21:
  test r15d, r15d
  jne .L14
  add esi, 1
.L17:
  test edx, edx
  jne .L10
  add esi, 1
  test r8d, r8d
  jne .L6
  jmp .L85
.L89:
  sub ecx, 2
.L6:
  lea edx, [r8-1]
  test esi, esi
  jne .L86
  sub r8d, 2
  test edx, edx
  jne .L10
  mov esi, 2
  test ecx, ecx
  je .L87
.L2:
  lea r8d, [rcx-1]
  test esi, esi
  jne .L88
  test r8d, r8d
  jne .L89
  add rsp, 24
  mov eax, 2
  pop rbx
  pop rbp
  pop r12
  pop r13
  pop r14
  pop r15
  ret
.L46:
  mov esi, 2
  jmp .L37
.L45:
  mov esi, 2
  jmp .L33
.L44:
  mov esi, 2
  jmp .L29
.L43:
  mov esi, 2
  jmp .L25
.L42:
  mov esi, 2
  jmp .L21
.L41:
  mov esi, 2
  jmp .L17
.L78:
  mov esi, 2
  test r8d, r8d
  jne .L6
.L85:
  add esi, 1
  test ecx, ecx
  jne .L2
.L87:
  add rsp, 24
  lea eax, [rsi+1]
  pop rbx
  pop rbp
  pop r12
  pop r13
  pop r14
  pop r15
  ret
.L84:
  mov eax, edi
  sub esi, 1
  mov edi, ebx
  mov ebx, eax
  jmp .L36
.L83:
  mov eax, ebx
  sub esi, 1
  mov ebx, ebp
  mov ebp, eax
  jmp .L34
.L82:
  mov eax, ebp
  sub esi, 1
  mov ebp, r12d
  mov r12d, eax
  jmp .L30
.L81:
  mov eax, r12d
  sub esi, 1
  mov r12d, r13d
  mov r13d, eax
  jmp .L26
.L80:
  mov eax, r13d
  sub esi, 1
  mov r13d, r14d
  mov r14d, eax
  jmp .L22
.L79:
  mov eax, r14d
  sub esi, 1
  mov r14d, r15d
  mov r15d, eax
  jmp .L18
.L77:
  mov eax, r15d
  sub esi, 1
  mov r15d, edx
  mov edx, eax
  jmp .L14
.L86:
  mov eax, edx
  sub esi, 1
  mov edx, r8d
  mov r8d, eax
  jmp .L10
.L88:
  mov eax, r8d
  sub esi, 1
  mov r8d, ecx
  mov ecx, eax
  jmp .L6
.L76:
  sub esi, 1
  xchg r8d, edx
  jmp .L72
.L64:
  mov eax, 2
  ret
