	.data		#Define your variable (changeable) data here.

	.section	.rodata		#Define your constant (read-only) data here.

pchar:	.string	"%c"

	.text
	.globl	show_string
	.type	show_string, @function

# Show String Function
# Takes One Argument 
# Takes the characters the user typed in. 
# Returns what the user typed and the count of Vowels			
show_string:	
	pushl	%ebp
	movl	%esp, %ebp
#PROTECT THE REGISTERS
	pushfl
	pushl	%ebx
	pushl	%ecx
	pushl	%edx
	pushl	%edi
	pushl	%esi

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
	
	#incl	%eax

sh3:

	#I could of made this more efficient, but due to heavy load this week, and not enough time, I took the easy approach. Works though!
	#I Compare the values of the ASCII with that of the vowels and I make jumps.

	cmpb	$0x41, (%ebx)
	jz	cinc	

	cmpb	$0x61, (%ebx)
	jz	cinc

	cmpb	$0x45, (%ebx)
	jz	cinc
	
	cmpb	$0x65, (%ebx)
	jz	cinc


	cmpb	$0x69, (%ebx)
	jz	cinc


	cmpb	$0x49, (%ebx)
	jz	cinc


	cmpb	$0x4F, (%ebx)
	jz	cinc


	cmpb	$0x6F, (%ebx)
	jz	cinc


	cmpb	$0x55, (%ebx)
	jz	cinc

	
	cmpb	$0x75, (%ebx)
	jz	cinc

	jmp	sh2	
cinc:

	incl	%eax

sh2:
	
	addl	$1, %ebx
	cmpb	$0, (%ebx)
	jne	sh1

#RESTORE REGISTERS
	popl	%esi	
	popl	%edi
	popl	%edx
	popl	%ecx
	popl	%ebx
	popfl


	leave
	ret
	.size	show_string, .-show_string

	.section	.note.GNU-stack,"",@progbits
	.ident	"GCC: (GNU) 3.3.5"
