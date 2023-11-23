global _start
section .data
	digits dq 0
	exercises dq 0
	num_user times 400 db 0
	num_arr times 30 db 0
	user_arr times 30 db 0
	num dq 0
	num1 times 400 db 0
	num2 times 400 db 0
	calc_arr times 400 dw 0
	str1 db 10,"Enter number of digits: "
	str2 db "Enter number of exercises: "
	str3 db "again = 1, other exit "
	str4 db " * "
	str5 db " = "
	temp3 times 8 db 0
	temp4 times 4 db 0
	temp5 times 16 db 0
	temp2: dq 0
	count_correct: dq 0
	count_wrong: dq 0
	str_amount1: db 10,"Amount correct answers: "
	str_amount2: db 10,"Amount wrong answers: "
	str8: db 10,"Time elapsed: "
	str9: db 10,"Again = 1, Exit = other: "
	end_time_seconds: dq 0,0
	start_time_seconds: dq 0,0
	minutes: dq 0
	_seconds: dq 0
	character db 0
section .text
_start:
	
	call game
	mov rdi,0
	mov rax,60
	syscall

input_str:
	mov rax,0
	mov rdi,0
	mov rsi,num_user
	mov rdx,400
	syscall
	ret
print_str:
	mov rax,1
	mov rdi,1
	mov rdx,rbx
	syscall
	ret
random_num:
	pop r14
	pop r13
	mov r12,[digits]
	mov rbx,0
	run:
		mov rax,96
		mov rdi,temp3
		mov rsi,temp5
		mov rdx,temp2
		syscall	
		mov eax,[temp4]
		xor rdx,rdx
		mov r15d,9
		div r15d
		;add dl,48
		cmp rbx,0
		jne next
		inc dl
		next:
		mov rdi,r13
		mov [rdi+rbx],dl
		inc rbx
		dec r12
		jnz run
		
	push r14
	ret
calc:
	mov r14,[digits]
	mov rsi,num1
	mov rdi,num2
	mov rbx,calc_arr
	add rbx,r14
	add rbx,r14
	add rbx,r14
	add rbx,r14
	sub rbx,2
	add rsi,r14
	dec rsi
	add rdi,r14
	dec rdi
	run3:
		run4:
			xor ax,ax
			mov al,[rsi]
			mov r13b,[rdi]
			mul r13b
			add [rbx],ax
			sub rbx,2
			push rsi
			call refresh
			pop rsi
			dec rdi
			cmp rdi,num2
			jnl run4
		sub rbx,2
		add rbx,r14
		add rbx,r14
		add rdi,r14
		dec rsi
		cmp rsi,num1
		jnl run3
	ret

refresh:
	mov rsi,calc_arr
	add rsi,r14
	add rsi,r14
	add rsi,r14
	add rsi,r14
	sub rsi,2
	run5:
		xor eax,eax
		xor edx,edx
		mov ax,[rsi]
		mov r13d,10
		div r13d
		mov [rsi],dx
		add [rsi-2],ax
		sub rsi,2
		cmp rsi,calc_arr
		jne run5
	ret
check:
	mov rsi,calc_arr
	mov rdi,num_user
	cmp word[rsi],0
	jne next2
	add rsi,2
	next2:
	run6:
		mov ax,[rsi]
		mov bl,[rdi]
		sub bl,48
		cmp al,bl
		je next3
		wrong:
		inc qword[count_wrong]
		ret
		next3:
		add rsi,2
		inc rdi
		cmp byte[rdi],10
		jne run6
	inc qword[count_correct]
	ret
str_to_num:
	xor rax,rax
	xor rdx,rdx
	xor r11,r11
	mov rbx,10
	run77:
		mul rbx
		mov r11b,[rdi]
		sub r11b,48
		add rax,r11
		inc rdi
		cmp byte[rdi],10
		jne run77
	mov [num],rax	
	ret
game:
	xor rax,rax
	mov [count_wrong],rax
	mov [count_correct],rax
	mov rsi,str1
	mov rbx,25
	call print_str
	call input_str
	mov rdi,num_user
	call str_to_num
	mov rax,[num]
	mov [digits],rax
	mov rsi,str2
	mov rbx,27
	call print_str
	call input_str
	mov rdi,num_user
	call str_to_num
	mov rax,[num]
	mov [exercises],rax
	mov rax,96
	mov rdi,start_time_seconds
	mov rsi,temp5
	mov rdx,temp2
	syscall
	mov r12,[exercises]
	run7:
		push r12
		push num1
		call random_num
		push num2
		call random_num
		mov rdi,calc_arr
		mov rbx,400
		call clean_arr
		call calc
		push num1
		call to_printable
		push num2
		call to_printable
		mov rsi,num1
		mov rbx,[digits]
		call print_str
		mov rsi,str4
		mov rbx,3
		call print_str
		mov rsi,num2
		mov rbx,[digits]
		call print_str
		mov rsi,str5
		mov rbx,3
		call print_str
		call input_str
		call check
		pop r12
		dec r12
		jnz run7
	mov rax,96
	mov rdi,end_time_seconds
	mov rsi,temp5
	mov rdx,temp2
	syscall
	call print_time
	call print_results
	mov rsi,str9
	mov rbx,26
	call print_str
	call input_str
	cmp byte[num_user],'1'
	je game
	ret	
		
to_printable:
	pop r15
	pop rsi
	mov r12,[digits]
	run8:
		add byte[rsi],48
		inc rsi
		dec r12
		jnz run8
	push r15
	ret	
print_time:
	mov rax,[end_time_seconds]
	sub rax,[start_time_seconds]
	mov rbx,60
	mov rdx,0
	div rbx
	mov [_seconds],rdx
	mov [minutes],rax
	mov rdi,num_arr
	mov rbx,30
	call clean_arr
	mov rdi,num_arr
	mov rbx,10
	run20:
		xor rdx,rdx
		div rbx
		add dl,48
		mov [rdi],dl
		inc rdi
		cmp rax,0
		jne run20
	dec rdi
	mov rsi,num_arr
	run9:
		mov al,[rdi]
		mov ah,[rsi]
		mov [rdi],ah
		mov [rsi],al
		inc rsi
		dec rdi
		cmp rsi,rdi
		jl run9
		
	mov rdi,user_arr
	mov rbx,30
	call clean_arr
	mov rax,[_seconds]
	mov rdi,user_arr
	mov rbx,10
	run10:
		xor rdx,rdx
		div rbx
		add dl,48
		mov [rdi],dl
		inc rdi
		cmp rax,0
		jne run10
	
	dec rdi
	mov rsi,user_arr
	run11:
		mov al,[rdi]
		mov ah,[rsi]
		mov [rdi],ah
		mov [rsi],al
		inc rsi
		dec rdi
		cmp rsi,rdi
		jl run11
	mov rsi,str8
	mov rbx,15
	call print_str
	mov rsi,num_arr
	mov rbx,5
	call print_str
	mov al,':'
	mov [character],al
	mov rsi,character
	mov rbx,1
	call print_str
	mov rsi,user_arr
	mov rbx,5
	call print_str
	ret
clean_arr:
	mov rcx,rbx
	run12:
		mov byte[rdi],0
		inc rdi
		loop run12
	ret
print_results:
	mov rdi,num_arr
	mov rbx,30
	call clean_arr
	mov rax,[count_correct]
	mov rdi,num_arr
	mov rbx,10
	run13:
		xor rdx,rdx
		div rbx
		add dl,48
		mov [rdi],dl
		inc rdi
		cmp rax,0
		jne run13
	dec rdi
	mov rsi,num_arr
	run14:
		mov al,[rdi]
		mov ah,[rsi]
		mov [rdi],ah
		mov [rsi],al
		inc rsi
		dec rdi
		cmp rsi,rdi
		jl run14
	mov rsi,str_amount1
	mov rbx,25
	call print_str
	mov rsi,num_arr
	mov rbx,5
	call print_str
	mov rdi,num_arr
	mov rbx,30
	call clean_arr
	mov rax,[count_wrong]
	mov rdi,num_arr
	mov rbx,10
	run15:
		xor rdx,rdx
		div rbx
		add dl,48
		mov [rdi],dl
		inc rdi
		cmp rax,0
		jne run15
	dec rdi
	mov rsi,num_arr
	run16:
		mov al,[rdi]
		mov ah,[rsi]
		mov [rdi],ah
		mov [rsi],al
		inc rsi
		dec rdi
		cmp rsi,rdi
		jl run16
	mov rsi,str_amount2
	mov rbx,23
	call print_str
	mov rsi,num_arr
	mov rbx,5
	call print_str
	ret
		
		
		
		
		
		
		
		
