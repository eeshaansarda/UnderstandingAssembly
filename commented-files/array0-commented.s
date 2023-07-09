	.text
	.file	"array.c"
	.globl	contains
	.p2align	4, 0x90
	.type	contains,@function
contains:
	.cfi_startproc
	pushq	%rbp                # Pushes rbp to stack
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp          # moving rsp (stack pointer) to rbp
	.cfi_def_cfa_register %rbp
    # to make place for the local variables
	subq	$48, %rsp           # (%rsp) -= 48
    # move rdi (array), rsi (elem), edx (left)
    # , ecx (right) to a relative location to rbp
    # where first two are long and the others are int
	movq	%rdi, -16(%rbp)
	movq	%rsi, -24(%rbp)
	movl	%edx, -28(%rbp)
	movl	%ecx, -32(%rbp)
    # eax is rax but least significant part of it
	movl	-32(%rbp), %eax     # (%eax) = right
	subl	-28(%rbp), %eax     # (%eax) = right - left
	cmpl	$1, %eax            # compare 1 to (right-left)
	jge	.LBB0_2             # jump if (right-left) >= 1
    # we know that the function will return false
	movb	$0, -1(%rbp)        # -1(%rbp) = 0
	jmp	.LBB0_8             # jumps to LBB0_8
.LBB0_2:
    # same thing
	movl	-32(%rbp), %eax     # (%eax) = right
	subl	-28(%rbp), %eax     # (%eax) = right - left
	cmpl	$1, %eax            # compare 1 to (right-left)
    # if 1 != eax
	jne	.LBB0_4             # i.e. jump if (right - left) > 1
	movq	-16(%rbp), %rax     # (%rax) = array
	movslq	-28(%rbp), %rcx     # (%rcx) = left
	movq	(%rax,%rcx,8), %rax # (%rax) = array[left]
	cmpq	-24(%rbp), %rax     # compare array[left] to elem
    # sets (%dl) = 1 if the array[left] == elem and 0 otherwise
	sete	%dl
	andb	$1, %dl             # (%dl) = true and (%dl)
	movb	%dl, -1(%rbp)       # -1(%rbp) = (%dl)
	jmp	.LBB0_8             # jump to LBB0_8
.LBB0_4:
	movl	-28(%rbp), %eax     # (%eax) = left
	movl	-32(%rbp), %ecx     # (%ecx) = right
	subl	-28(%rbp), %ecx     # (%ecx) = right - left
	movl	%eax, -40(%rbp)     # -40(%rbp) = left
	movl	%ecx, %eax          # (%eax) = right - left
	cltd                        # extends 4byte eax to 8byte rax
	movl	$2, %ecx            # (%ecx) = 2
	idivl	%ecx                # (%eax) = (right-left) / 2
	movl	-40(%rbp), %ecx     # (%ecx) = left
	addl	%eax, %ecx          # (%ecx) = left + (right - left)/2
	movl	%ecx, -36(%rbp)     # -36(%rbp) = left + (right-left)/2
	movq	-24(%rbp), %rsi     # (%rsi) = elem
	movq	-16(%rbp), %rdi     # (%rdi) = *array
	movslq	-36(%rbp), %r8      # (%r8) = mid
	cmpq	(%rdi,%r8,8), %rsi  # compare array[mid] to elem
	jge	.LBB0_6             # jump if elem >= array[mid]
    # set all the arguments again
    # (array, elem, left, mid)
	movq	-16(%rbp), %rdi
	movq	-24(%rbp), %rsi
	movl	-28(%rbp), %edx
	movl	-36(%rbp), %ecx
	callq	contains
    # return value of the function call
	andb	$1, %al             # (%al) = (%al) and 1
    # expand the value throughout ecx
	movzbl	%al, %ecx
	movl	%ecx, -44(%rbp)     # -44(%rbp) = (%ecx)
	jmp	.LBB0_7             # jump to .LBBO_7
.LBB0_6:
    # set all the arguments again
    # (array, elem, mid, right)
	movq	-16(%rbp), %rdi
	movq	-24(%rbp), %rsi
	movl	-36(%rbp), %edx
	movl	-32(%rbp), %ecx
	callq	contains
    # return value of the function call
	andb	$1, %al             # (%al) = (%al) and 1
    # expand the value throughout ecx
	movzbl	%al, %ecx
	movl	%ecx, -44(%rbp)     # -44(%rbp) = (%ecx)
.LBB0_7:
    # (%eax) = the return value of contains(arr, elem, left, mid)
	movl	-44(%rbp), %eax
	cmpl	$0, %eax            # compare with 0
    # set if not equal to zero
	setne	%cl                 # sets (%cl) = 1 if eax != 0
	andb	$1, %cl             # (%cl) = (%cl) and 1
	movb	%cl, -1(%rbp)       # -1(%rbp) = (%cl)
.LBB0_8:
    # since we know the return value, this part is to finish up
	movb	-1(%rbp), %al       # (%al) = -1(%rbp)
	andb	$1, %al             # (%al) = (%al) and 1
    # copy and expand
	movzbl	%al, %eax
    # adding to rsp to free space used for
    # local variables and saved register values
	addq	$48, %rsp           # (%rsp) = (%rsp) + 48
    # popping old value of rbp so that it
    # goes back to the value of the "caller"
    # or "restoring" it
	popq	%rbp
	.cfi_def_cfa %rsp, 8
    # the function "ends" ->
    #   pops the address and puts in rip
	retq
.Lfunc_end0:
	.size	contains, .Lfunc_end0-contains
	.cfi_endproc

	.ident	"clang version 10.0.1 (Red Hat 10.0.1-1.module_el8.3.0+467+cb298d5b)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym contains
