	.data		#Define your variable (changeable) data here.
#Avgerage of the ASCI VALUES FROM FPU
avg: 	.int	0x0
#Remainder when I do the Divide
remA:	.int	0x0
#Quotient to see how many times it divides by 8, since we are taking 8 bytes at a time.
quot:	.int	0x0
#How many characters the user entered
charC:	.int	0x0
#Saving the string after its out of MMX.
qStr:	.int	0x00000000, 0x00000000
#Saving the remainder string, after its out of MMX
rStr:	.int	0x00000000, 0x00000000
#What Ill be using to add to the MMX register since the ASCI values are stored x61, x62, x63(a, b, c) I'm just adding 1 to the first bit
addB:	.int	0x01010101, 0x01010101


	.section	.rodata		#Define your constant (read-only) data here.
#The format In Which I will print
pchar:	.string	"%c"
	.text

#Show String Function
# Takes One Argument 
# Takes the characters the user typed in. 
## Returns what the user typed in after MMX with the packed add and the average of ASCII BEFORE MMX so the original avg of ASCII before MMX	
#
#

	.globl	show_string
	.type	show_string, @function	
show_string:	
	pushl	%ebp	#Enter Code
	movl	%esp, %ebp #Enter Code
#Pushing the registers so I can protect them, I dont push %eax because I use it to calculate the average and its the accumulator.
	pushfl
	pushl	%ebx
	pushl	%ecx
	pushl	%edx
	pushl	%edi
	pushl	%esi
	
	
# I move the function's first argument and move it into %ebx. %ebx is now holding the position of where the first character is stored.
	movl	8(%ebp), %ebx	
	movl	$0, %eax
	movl	$0, %ecx
	fldz	
	jmp	sh1
#Floating Point Unit
# Here I calculate the ASCI value average before I do the MMX(Professor, didn't specify in which order it needs to happen)
sh1:	
	
	movl	(%ebx), %edx
	roll	$24, %edx
	shrl	$24, %edx
	movl	%edx, -4(%ebp)

	
	filds	-4(%ebp)
	faddp
	
	incl	%ecx
	addl	$1, %ebx
	cmp	$0, (%ebx)
	jne	sh1
	

	movl	%ecx, -8(%ebp)
	filds	-8(%ebp)

	movl	%ecx, charC	
	fdivrp		
	fistpl avg
	subl	%ecx, %ebx #Here I restore the position of %ebx since I kept adding to it, to print it out.
####################################################---------------MMX -----------------------############################
#This Calculates if there is a remainder and what is the quotient. I get the total number of characters	
calcbites:

	movl	$0x0, %edx
	movl	$0x0, %eax

	movl	%ecx, -12(%ebp)

	movl	$8, %esi	#What I will be dividing by

	movl	-12(%ebp), %eax

	divl 	%esi		#I do the division

	movl	%eax, quot	#Where the quotient is stored
	movl	%edx, remA	#Where remainder is stored

	movl	quot, %ecx

	cmpb	$0, (%ebx)	#First Case: User enters nothing
	je	done		#I exit the program

	cmpl	$0, %eax	#Characters typed are less than 8
	jg	quotei
	
	cmpl	$0, %edx	#Characters typed are more than 8
	jg	setrCount

	

quotei:
	movl	$0, %edx
	jmp quotient
	
quotient:
	movq	(%ebx, %edx, 8), %mm0	#Store into MMX
	movq	addB, %mm1		#There is where my global variable addB is stored and where I do the addition
	paddb	%mm1, %mm0		#I add to mm0 in MMX
	movq	%mm0, qStr		#I saved it to my Global Variable
	
	emms				#Exit out of MMX and make it use FPU. I also read that is efficient to emms after your done with MMX even 						#if you dont switch back to FPU
	
	movl $qStr, %edi
	
	pushl	%ecx	
	movl $8, %ecx
sh2:
	

	pushfl
	pushl	%eax
	pushl	%ebx
	pushl	%ecx
	pushl	%edx
	pushl	%edi
	pushl	%esi

	pushl	(%edi)			#Value at the memory Address
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
	
	addl	$1, %edi
	loop	sh2

	popl	%ecx
	
qdone:
	incl	%edx	
	loop	quotient
	jmp 	checkRemain
#	jmp	done #Will need it to jmp to a different label that checks if there is a remainder.

checkRemain:
	movl	remA, %edx
	cmpl	$0, %edx
	jg	setReg
	
	jmp done
setReg:
	
	movl remA, %ecx
	movl $0, %edx
	movl quot, %eax
	movl $8, %esi
	mull %esi
	addl %eax, %ebx
	jmp remainder


setrCount:
	movl charC, %ecx
	movl $0, %edx
	jmp remainder

remainder:

	movq	(%ebx, %edx, 1), %mm0	#I store the remainder into MMX
	movq	addB, %mm1		#Same I move this global variable into MMX
	paddb	%mm1, %mm0		#I do the packed add
	movq	%mm0, rStr		#I save the remainder string
	
	emms
	
	movl $rStr, %edi

#My LOOP that I use to print out just the remainder characters, there is another one for Quotient. I had this originally in a function to do it for both.
#To make things more efficient and cleaner, but I had some looping issues and returned back to this. I figured out the looping issues and I dont have time to implement the
#function.
remainderloop:

	
	pushfl
	pushl	%eax
	pushl	%ebx
	pushl	%ecx
	pushl	%edx
	pushl	%edi
	pushl	%esi

	pushl	(%edi)
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
	
	addl	$1, %edi
	incl	%edx
	loop	remainder
	#jmp	done #might need to be changed.

	
#rdone:
#	incl	%edx
#	loop	remainder
#	jmp	done #Will need it to jmp to a different label that checks if there is a remainder.

done:

	movl	avg, %eax	#I move the avg from global variable into %EAX
				#I dont pop %EAX, since I need it to hold the avg
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
