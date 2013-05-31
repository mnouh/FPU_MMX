	.data		#Define your variable (changeable) data here.
#NO GLOBALS
# THIS IS JUST MY FPU STUFF, TO AVG ASCI VALUES, IF YOU WANT MMX, IT IS IN show6.s and repeat6 and test6.
	.section	.rodata		#Define your constant (read-only) data here.

pchar:	.string	"%c"

	.text
	.globl	show_string
	.type	show_string, @function
#Show String Function
# Takes One Argument 
# Takes the characters the user typed in. 
# Returns what the user typed and the average of ASCII	
show_string:	
	pushl	%ebp
	movl	%esp, %ebp
#Protect Registers
	pushfl
	pushl	%eax
	pushl	%ebx
	pushl	%ecx
	pushl	%edx
	pushl	%edi
	pushl	%esi
		
	movl	8(%ebp), %ebx
	movl	$0, %eax
	movl	$0, %ecx
	fldz				# Load Zero into the FPU, even though it says ZERO in GDB, that actually might be NULL or (Garbage Values)
	jmp	sh1

sh1:	
	#Protect Registers before I print
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
	
	popl	%esi
	popl	%esi

	
	popl	%esi	
	popl	%edi
	popl	%edx
	popl	%ecx
	popl	%ebx
	popl	%eax
	popfl


	#I Do the Shifting here so I can just get one character byte at a time into the FPU, the first Byte

	movl	(%ebx), %edx
	roll	$24, %edx
	shrl	$24, %edx
	movl	%edx, -4(%ebp)

	###############----------------------ACTUAL FPU INSTRUCTION HERE -----------------#######################	
	filds	-4(%ebp)
	faddp
	
	incl	%ecx
	addl	$1, %ebx
	cmpb	$0, (%ebx)
	jne	sh1
	
	movl	%ecx, -8(%ebp)
	filds	-8(%ebp)
	
	fdivrp			#DIVIDE IT BY THE COUNTER
	fistpl -4(%ebp)		
	movl -4(%ebp), %eax	#AVG IN EAX

	#RESTORE THE REGISTERS

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
