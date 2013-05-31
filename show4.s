	.data		#Define your variable (changeable) data here.

	.section	.rodata		#Define your constant (read-only) data here.

fmatP:	.string	"%c"

	.text
	.globl	show_string
	.type	show_string, @function
#Show String Function
# Takes One Argument 
# Takes the characters the user typed in. 
# Returns what the user typed but opposite case and the number of character user typed in.		
show_string:	
	pushl	%ebp
	movl	%esp, %ebp
#PROTECT THE REGISTERS, I DONT PUSH %EAX because I need it for returning the count
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
	#I could of made this more efficient, but due to heavy load this week, and not enough time, I took the easy approach. Works though!
	#I check if its lowercase or uppercase, then i do the math required.
	cmpb 	$96, (%ebx)
	jg	sub2

	cmpb 	$97, (%ebx)
	jl	add2



	jmp	print


sub2:
	cmpb 	$122, (%ebx)
	jg	print
	subl	$32, (%ebx)
	
	jmp	print

add2:	
	cmpb 	$90, (%ebx)
	jg	print

	cmpb 	$65, (%ebx)
	jl	print
	addl	$32, (%ebx)

	jmp	print


print:	
	pushfl
	pushl	%eax
	pushl	%ebx
	pushl	%ecx
	pushl	%edx
	pushl	%edi
	pushl	%esi

	pushl	(%ebx)
	pushl	$fmatP
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
#I restore the registers	
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
