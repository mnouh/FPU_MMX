	.data		#Define your variable (changeable) data here.

	.section	.rodata		#Define your constant (read-only) data here.

pchar:	.string	"%c"

	.text
	.globl	show_string
	.type	show_string, @function
# Show String Function
# Takes One Argument 
# Takes the characters the user typed in. 
# Returns what the user typed and the count of characters.		
show_string:	
	pushl	%ebp
	movl	%esp, %ebp
	#I ONLY PROTECT THE SINGLE REGISTER I USE... %EBX and NOT %EAX since I NEED IT TO STORE THE RESULT	
	pushfl
	pushl	%ebx
	movl	8(%ebp), %ebx
	movl	$0, %eax
	jmp	sh1

sh1:	
	pushfl
	pushl	%eax
	pushl	%ebx
	pushl	%ecx
	pushl	%edx
	pushl	%edi
	pushl	%esi

	pushl	(%ebx)
	pushl	$pchar
	call	printf
	addl	$8, %esp

	popl	%esi	
	popl	%edi
	popl	%edx
	popl	%ecx
	popl	%ebx
	popl	%eax
	popfl
	
	incl	%eax
	addl	$1, %ebx
	cmpb	$0, (%ebx)
	jne	sh1

	
	#RESTORE THE REGISTERS
	popl	%ebx
	popfl
	
	leave
	ret
	.size	show_string, .-show_string
	

	.section	.note.GNU-stack,"",@progbits
	.ident	"GCC: (GNU) 3.3.5"
