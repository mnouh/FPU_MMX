	.data		#Define your variable (changeable) data here.

convert_ascii:	
	.byte	1, 1, 1, 1, 1, 1, 1, 1
ascii_average:
	.int	0
count:
	.int	0
converted:
	.byte	0 
converted_single:
	.byte	0
quotient:
	.int	0

	.section	.rodata		#Define your constant (read-only) data here.

	pint:	.string	"%c"
	
	.text
	.globl show_string
	.type	show_string, @function

show_string:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp			#Allocates space for local variables

	movl	8(%ebp), %edi			#Loads the input string into register
	movl	$0, %esi
	fldz					#Clears resgister %ST(0)

#load_fpu takes in one character at a time and returns and stores it into the FPU resgisters#

load_fpu:	
	pushl	%eax
	pushl	%ebx
	pushl	%ecx
	pushl	%edx
	pushl	%esi
	pushl	%edi

	movl	(%edi, %esi, 1), %ebx		#Reads in the input

	cmpl	$0, %ebx			#If it is empty moves onto MMX
	je	end_loop

	roll	$24, %ebx			#Rotates the input due to little endian order
	shrl	$24, %ebx			#Bit shifts the input in order to retrieve one character at a time

	movl	%ebx, -4(%ebp)			#Stores character's ascii value in local variable

	filds	-4(%ebp)			#Loads the character into the FPU register
	faddp	%st(0), %st(1)			#Adds %ST(0) and %ST(1) and stores result into $ST(0)

	incl	%esi
	jmp	load_fpu			#Jump to load next character of input

end_loop:

	popl	%edi
	popl	%esi
	popl	%edx
	popl	%ecx
	popl	%ebx
	popl	%eax

	movl	%esi, -4(%ebp)			#Saves the character counts into a local variable

	filds	-4(%ebp)			#Loads the count into FPU
	fdivrp					#Divides the sum on ascii values with number by the character count
	fistp	ascii_average			#Stores the average into a local variable

	movl	%esi, -8(%ebp)


##### MMX #####
	movl	$0, %edx
	movl	$0, %eax

	movl	$8, %ebx			#Determines the amount of 8 byte chunks in input
	movl	-8(%ebp), %eax			#Loads the number of characters in input

	divl	%ebx				
	
	movl	%eax, -20(%ebp)			#Saves the quotient into a local variable

	movl	$0, %esi			
	cmpl	$0, %eax
	jg	quotient_loop			#Jumps to the quotient loop

check_remainder:
	cmpl	$0, %edx			#If no remainder exit program
	je	end_program

	jmp	remainder_loop			#If there is remainder jump to remainder loop


quotient_loop:
	movq	(%edi, %esi, 8), %mm1		#Quotient loop takes in 8 bytes at a time
	movq	convert_ascii, %mm2
	paddb	%mm2, %mm1			#Adds 1 to each ascii value of the input
	movq	%mm1, converted			#Save results
	movl	-8(%ebp), %ecx
	movl	$converted, %ebx		#Moves results into general purpuse register

	jmp	print_mmx			#Prints reults

quotient_check:					#Checks if there is still a quotient
	decl	%eax
	cmpl	$0, %eax
	je	set_counter			
	incl	%esi
	jmp	quotient_loop

set_counter:					#Sets the counter to be used in the remainder loop
	movl	$8, %esi			#Used to place the pointer back at current character 
	movl	-20(%ebp), %eax			
	mull	%esi
	movl	%eax, %esi
	jmp	remainder_loop

print_mmx:					#Prints thye 8 byte inputs one byte at a time.

	#This Code Section is From CS-220 Lab #3 Write-Up
	pushfl
	pushl	%edi
	pushl	%esi
	pushl	%edx
	pushl	%ecx
	pushl	%ebx
	pushl	%eax
						#Loops through and prints each value of the 8 byte chunks
	pushl	(%ebx)
	pushl	$pint
	call	printf
	addl	$8, %esp

	popl	%eax
	popl	%ebx
	popl	%ecx
	popl	%edx
	popl	%esi
	popl	%edi
	popfl
	#End of Code Section from CS-220 Lab #3 Write-Up

	incl	%ebx
	cmpl	$0, (%ebx)				#Checks the value of each input and jump if value is not zero
	je	quotient_check
	loop	print_mmx

remainder_loop:
	movq	(%edi, %esi, 1), %mm1			#If there is remainder program jumps here
	movq	convert_ascii, %mm2			#Takes in one character at a time and adds 1 to each ascii value
	paddb	%mm2, %mm1				
	movq	%mm1, converted				#Saves the result into memory
	movl	$converted, %ebx			#Stores into a register to be printed


	pushfl
	pushl	%edi					#Prints each chracter one at a time
	pushl	%esi
	pushl	%edx
	pushl	%ecx
	pushl	%ebx
	pushl	%eax

	pushl	(%ebx)
	pushl	$pint
	call	printf
	addl	$8, %esp

	popl	%eax
	popl	%ebx
	popl	%ecx
	popl	%edx
	popl	%esi
	popl	%edi
	popfl


	incl	%esi

	decl	%edx					#Decreases the remainder count and loops if remainder is not zero
	cmpl	$0, %edx				#If there is no remainder program ends
	je	end_program

	incl	%ebx
	loop	remainder_loop

end_program:
	movl	ascii_average, %eax			#Retrieves the average and stores into %eax

	leave
	ret

	.size	show_string, .-show_string
