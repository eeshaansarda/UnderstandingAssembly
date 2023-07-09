	.text
	.file	"array.c"
	.globl	contains
	.p2align	4, 0x90
	.type	contains,@function
contains:
	.cfi_startproc
	jmp	.LBB0_1
	.p2align	4, 0x90
.LBB0_7:
    # start again
	movl	%r8d, %edx          # (%edx) = mid
.LBB0_1:
	movl	%ecx, %r8d          # (%r8d) = right
	subl	%edx, %r8d          # (%r8d) = right - left
	jle	.LBB0_8             # jump if (right - left) <= 0
.LBB0_3:
	cmpl	$1, %r8d            # compare (right - left) with 1
	je	.LBB0_4                 # jump (right - left) == 1
    # this is shifting (%r8d) right by 1 byte
    # which is equivalent to /2
	shrl	%r8d                # (%r8d) = (%r8d)/2 = (right-left)/2
	addl	%edx, %r8d          # (%r8d) = (%r8d)+left = (right-left)/2 + left
    # 32bits to 64bits
	movslq	%r8d, %rax          # (%rax) = (%r8d) = (right-left)/2 + left
	cmpq	%rsi, (%rdi,%rax,8) # compare elem with array[mid]
    # not (elem < array[mid])
	jle	.LBB0_7             # jump if array[mid] <= elem
    # setting the fourth argument to be mid
	movl	%r8d, %ecx          # (%ecx) = mid
    # this is the new (right - left)
    # since right is now mid
	subl	%edx, %r8d          # (%r8d) = (%r8d) - (%edx)
    # jump if greater than and start again
    # otherwise goes to LBB0_8 and returns false
	jg	.LBB0_3
.LBB0_8:
    # this is setting the value to zero
    # this instruction is fewer bytes than mov
	xorl	%eax, %eax          # (%eax) = 0
	retq                        # return false
.LBB0_4:
	movslq	%edx, %rax          # copy left to rax (and expand)
	cmpq	%rsi, (%rdi,%rax,8) # compare array[left] and elem
	sete	%al                 # set to true if the previous expression is equal
	retq                        # return
.Lfunc_end0:
	.size	contains, .Lfunc_end0-contains
	.cfi_endproc

	.ident	"clang version 10.0.1 (Red Hat 10.0.1-1.module_el8.3.0+467+cb298d5b)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
