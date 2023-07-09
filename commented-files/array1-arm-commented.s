	.text
	.file	"array.c"
	.globl	contains
	.p2align	2
	.type	contains,@function
contains:
	.cfi_startproc
    ;; x29 is frame pointer
    ;; x30 is stack pointer
	stp	x29, x30, [sp, #-16]!   ;; stores a pair of registers, offset -16
	mov	x29, sp                 ;; copies x29 = sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
    ;; w2 is the third arg
    ;; w3 is the fourth arg
	sub	w8, w3, w2              ;; w8 = w3 - w2 = right - left
	cmp	w8, #1                  ;; compare (right - left) with 1
	b.lt	.LBB0_3                 ;; jump if (right-left) < 1
    ;; jump if not equal to
	b.ne	.LBB0_4                 ;; (right-left) > 1
    ;; the following is in the case (right-left) == 1
    ;; load a word
    ;; sxtw is signed extend word
    ;; https://reverseengineering.stackexchange.com/questions/22962/ldr-specifier-combination-uxtw
	ldr	x8, [x0, w2, sxtw #3]   ;; x8 = array[left]
	cmp	x8, x1                  ;; compare array[left] to elem
	cset	w0, eq                  ;; if array[left] == elem then w0 = 1
	b	.LBB0_8                     ;; jump to LBB0_8
.LBB0_3:
	mov	w0, wzr                 ;; w0 = wzr = false
	b	.LBB0_8                     ;; jump to LBB0_8
.LBB0_4:
	cmp	w8, #0                  ;; compare (right-left) with 0
    ;; this never happens
	cinc	w8, w8, lt              ;; if less than then w8 = w8 + 1
    ;; arithmetic shift right
	add	w8, w2, w8, asr #1      ;; w8 = left + (right-left)/2
	ldr	x9, [x0, w8, sxtw #3]   ;; x9 = array[mid]
	cmp	x9, x1                  ;; compare elem to array[mid]
	b.le	.LBB0_6                 ;; jump if array[mid] <= elem
    ;; setting argument for contains call
	mov	w3, w8                  ;; w3 = mid
	b	.LBB0_7                     ;; jump to LBB0_7
.LBB0_6:
    ;; setting argument for contains call
	mov	w2, w8                  ;; w2 = mid
.LBB0_7:
    ;; calling contains again after setting the new val
	bl	contains
.LBB0_8:
	and	w0, w0, #0x1            ;; w0 = w0 and 0x1
    ;; load x29 and x30 from where stored earlier
    ;; and change the sp
	ldp	x29, x30, [sp], #16
    ;; return
	ret
.Lfunc_end0:
	.size	contains, .Lfunc_end0-contains
	.cfi_endproc

	.ident	"clang version 10.0.1 (Red Hat 10.0.1-1.module_el8.3.0+467+cb298d5b)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
