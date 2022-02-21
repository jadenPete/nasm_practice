section .data
	newline db 10

section .text
	global _start

%macro print 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

print_int:
	push rbp               ; save old stack frame
	mov rbp, rsp           ; create new stack frame

	mov rax, [rbp + 16]    ; n
	push 0                 ; i

	l2:
		; n /= 10
		mov rdx, 0
		mov rbx, 10
		div rbx

		; push n % 10
		add rdx, '0'
		push rdx

		; i += 1
		inc qword [rbp - 8]

		; continue if n != 0
		cmp rax, 0
		jne l2

	l3:
		print rsp, 1    ; print the digit
		add rsp, 8      ; discard the digit

		; continue if --i != 0
		dec qword [rbp - 8]
		jnz l3

	; discard i
	add rsp, 8

	mov rsp, rbp   ; restore old stack pointer
	pop rbp        ; restore old stack base pointer
	ret            ; return

_start:
	push 0     ; a
	push 1     ; b
	push 25    ; i

	l1:
		; print a
		push qword [rsp + 16]
		call print_int
		add rsp, 8

		print newline, 1

		; a, b = b, a + b
		mov rax, [rsp + 16]
		mov rbx, [rsp + 8]
		mov [rsp + 16], rbx
		add [rsp + 8], rax

		; continue if --i != 0
		dec qword [rsp]
		jnz l1

	; discard a, b, i
	add rsp, 24

	; exit(EXIT_SUCCESS)
	mov rax, 60
	mov rdi, 0
	syscall
