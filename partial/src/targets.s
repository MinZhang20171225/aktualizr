	.file	"targets.c"
	.section	.rodata
.LC0:
	.string	"signatures"
.LC1:
	.string	"keyid"
.LC2:
	.string	"method"
.LC3:
	.string	"sig"
.LC4:
	.string	"signed"
.LC5:
	.string	"_type"
.LC6:
	.string	"expires"
.LC7:
	.string	"targets"
.LC8:
	.string	"custom"
.LC9:
	.string	"ecu_identifier"
.LC10:
	.string	"hardware_identifier"
.LC11:
	.string	"release_counter"
.LC12:
	.string	"hashes"
.LC13:
	.string	"sha256"
.LC14:
	.string	"sha512"
.LC15:
	.string	"length"
.LC16:
	.string	"version"
.LC17:
	.string	"*"
.LC18:
	.string	"["
	.data
	.align 32
	.type	targets_key_strings, @object
	.size	targets_key_strings, 152
targets_key_strings:
	.quad	.LC0
	.quad	.LC1
	.quad	.LC2
	.quad	.LC3
	.quad	.LC4
	.quad	.LC5
	.quad	.LC6
	.quad	.LC7
	.quad	.LC8
	.quad	.LC9
	.quad	.LC10
	.quad	.LC11
	.quad	.LC12
	.quad	.LC13
	.quad	.LC14
	.quad	.LC15
	.quad	.LC16
	.quad	.LC17
	.quad	.LC18
	.local	targets_ctxs
	.comm	targets_ctxs,200,32
	.local	targets_ctx_busy
	.comm	targets_ctx_busy,1,1
	.text
	.globl	targets_ctx_new
	.type	targets_ctx_new, @function
targets_ctx_new:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, -4(%rbp)
	jmp	.L2
.L5:
	movl	-4(%rbp), %eax
	cltq
	movzbl	targets_ctx_busy(%rax), %eax
	xorl	$1, %eax
	testb	%al, %al
	je	.L3
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	leaq	0(,%rax,4), %rdx
	addq	%rdx, %rax
	salq	$3, %rax
	addq	$targets_ctxs, %rax
	jmp	.L4
.L3:
	addl	$1, -4(%rbp)
.L2:
	cmpl	$0, -4(%rbp)
	jle	.L5
	movl	$0, %eax
.L4:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	targets_ctx_new, .-targets_ctx_new
	.globl	targets_ctx_free
	.type	targets_ctx_free, @function
targets_ctx_free:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	$targets_ctxs, %edx
	subq	%rdx, %rax
	shrq	$3, %rax
	movabsq	$2951479051793528259, %rdx
	mulq	%rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	movq	%rax, -16(%rbp)
	movq	-24(%rbp), %rax
	movq	120(%rax), %rax
	movq	%rax, %rdi
	call	gj_ctx_free
	movl	$0, -4(%rbp)
	jmp	.L7
.L9:
	movq	-24(%rbp), %rdx
	movl	-4(%rbp), %eax
	cltq
	movzbl	172(%rdx,%rax), %eax
	testb	%al, %al
	je	.L8
	movq	-24(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	addq	$22, %rdx
	movq	8(%rax,%rdx,8), %rax
	movq	%rax, %rdi
	call	crypto_verify_ctx_free
.L8:
	addl	$1, -4(%rbp)
.L7:
	movq	-24(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	-4(%rbp), %eax
	jg	.L9
	movq	-16(%rbp), %rax
	addq	$targets_ctx_busy, %rax
	movb	$0, (%rax)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	targets_ctx_free, .-targets_ctx_free
	.type	path_equal, @function
path_equal:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$104, %rsp
	movq	%rdi, -216(%rbp)
	movl	%esi, -220(%rbp)
	movq	%rdx, -160(%rbp)
	movq	%rcx, -152(%rbp)
	movq	%r8, -144(%rbp)
	movq	%r9, -136(%rbp)
	testb	%al, %al
	je	.L21
	movaps	%xmm0, -128(%rbp)
	movaps	%xmm1, -112(%rbp)
	movaps	%xmm2, -96(%rbp)
	movaps	%xmm3, -80(%rbp)
	movaps	%xmm4, -64(%rbp)
	movaps	%xmm5, -48(%rbp)
	movaps	%xmm6, -32(%rbp)
	movaps	%xmm7, -16(%rbp)
.L21:
	movl	$16, -208(%rbp)
	movl	$48, -204(%rbp)
	leaq	16(%rbp), %rax
	movq	%rax, -200(%rbp)
	leaq	-176(%rbp), %rax
	movq	%rax, -192(%rbp)
	movl	$0, -180(%rbp)
	jmp	.L12
.L17:
	movl	-208(%rbp), %eax
	cmpl	$47, %eax
	ja	.L13
	movq	-192(%rbp), %rax
	movl	-208(%rbp), %edx
	movl	%edx, %edx
	addq	%rdx, %rax
	movl	-208(%rbp), %edx
	addl	$8, %edx
	movl	%edx, -208(%rbp)
	jmp	.L14
.L13:
	movq	-200(%rbp), %rax
	leaq	8(%rax), %rdx
	movq	%rdx, -200(%rbp)
.L14:
	movl	(%rax), %eax
	movl	%eax, -184(%rbp)
	movl	-180(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-216(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	cmpl	-184(%rbp), %eax
	je	.L15
	cmpl	$17, -184(%rbp)
	je	.L15
	movl	$0, %eax
	jmp	.L20
.L15:
	addl	$1, -180(%rbp)
.L12:
	movl	-180(%rbp), %eax
	cmpl	-220(%rbp), %eax
	jl	.L17
	movl	-208(%rbp), %eax
	cmpl	$47, %eax
	ja	.L18
	movq	-192(%rbp), %rax
	movl	-208(%rbp), %edx
	movl	%edx, %edx
	addq	%rdx, %rax
	movl	-208(%rbp), %edx
	addl	$8, %edx
	movl	%edx, -208(%rbp)
	jmp	.L19
.L18:
	movq	-200(%rbp), %rax
	leaq	8(%rax), %rdx
	movq	%rdx, -200(%rbp)
.L19:
	movl	(%rax), %eax
	cmpl	$19, %eax
	sete	%al
.L20:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	path_equal, .-path_equal
	.type	process_keyid, @function
process_keyid:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-56(%rbp), %rax
	movzbl	163(%rax), %eax
	testb	%al, %al
	je	.L23
	movl	$1, %eax
	jmp	.L32
.L23:
	movq	-64(%rbp), %rax
	movl	$64, %esi
	movq	%rax, %rdi
	call	strnlen
	movq	%rax, -16(%rbp)
	cmpq	$64, -16(%rbp)
	je	.L25
	movl	$0, %eax
	jmp	.L32
.L25:
	movl	$0, -4(%rbp)
	jmp	.L26
.L27:
	movl	-4(%rbp), %eax
	movl	-4(%rbp), %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	addl	$1, %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %edx
	movl	-4(%rbp), %eax
	addl	%eax, %eax
	movslq	%eax, %rcx
	movq	-64(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	%edx, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	hex
	movl	%eax, %edx
	movl	-4(%rbp), %eax
	cltq
	movb	%dl, -48(%rbp,%rax)
	addl	$1, -4(%rbp)
.L26:
	cmpl	$31, -4(%rbp)
	jle	.L27
	movq	-56(%rbp), %rax
	movb	$1, 163(%rax)
	movl	$0, -4(%rbp)
	jmp	.L28
.L31:
	movq	-56(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	movq	8(%rax,%rdx,8), %rax
	movq	(%rax), %rax
	leaq	4(%rax), %rcx
	leaq	-48(%rbp), %rax
	movl	$32, %edx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	memcmp
	testl	%eax, %eax
	jne	.L29
	movq	-56(%rbp), %rax
	movl	-4(%rbp), %edx
	movl	%edx, 164(%rax)
	movq	-56(%rbp), %rax
	movb	$0, 163(%rax)
	jmp	.L30
.L29:
	addl	$1, -4(%rbp)
.L28:
	movq	-56(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	-4(%rbp), %eax
	jg	.L31
.L30:
	movq	-56(%rbp), %rax
	movb	$1, 160(%rax)
	movl	$1, %eax
.L32:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	process_keyid, .-process_keyid
	.type	process_method, @function
process_method:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	movzbl	163(%rax), %eax
	testb	%al, %al
	jne	.L34
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	crypto_keytype_supported
	testb	%al, %al
	je	.L35
.L34:
	movl	$1, %eax
	jmp	.L36
.L35:
	movl	$0, %eax
.L36:
	andl	$1, %eax
	movq	-8(%rbp), %rdx
	movb	%al, 163(%rdx)
	movq	-8(%rbp), %rax
	movb	$1, 161(%rax)
	movl	$1, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	process_method, .-process_method
	.type	process_sig, @function
process_sig:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-24(%rbp), %rax
	movzbl	163(%rax), %eax
	testb	%al, %al
	je	.L39
	movl	$1, %eax
	jmp	.L40
.L39:
	movq	-24(%rbp), %rax
	movzbl	160(%rax), %eax
	xorl	$1, %eax
	testb	%al, %al
	je	.L41
	movl	$0, %eax
	jmp	.L40
.L41:
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movl	%eax, -8(%rbp)
	cmpl	$128, -8(%rbp)
	je	.L42
	movl	$0, %eax
	jmp	.L40
.L42:
	movq	-24(%rbp), %rax
	movl	164(%rax), %edx
	movq	-24(%rbp), %rax
	movslq	%edx, %rdx
	movq	8(%rax,%rdx,8), %rax
	movq	%rax, -16(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L43
.L44:
	movl	-4(%rbp), %eax
	movl	-4(%rbp), %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	addl	$1, %eax
	movslq	%eax, %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %edx
	movl	-4(%rbp), %eax
	addl	%eax, %eax
	movslq	%eax, %rcx
	movq	-32(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	%edx, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	hex
	movl	%eax, %ecx
	movq	-16(%rbp), %rdx
	movl	-4(%rbp), %eax
	cltq
	movb	%cl, 8(%rdx,%rax)
	addl	$1, -4(%rbp)
.L43:
	cmpl	$63, -4(%rbp)
	jle	.L44
	movq	-24(%rbp), %rax
	movb	$1, 162(%rax)
	movl	$1, %eax
.L40:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	process_sig, .-process_sig
	.type	checkresult, @function
checkresult:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movzbl	132(%rax), %eax
	xorl	$1, %eax
	testb	%al, %al
	je	.L46
	movl	$13, %eax
	jmp	.L47
.L46:
	movq	-8(%rbp), %rax
	movzbl	133(%rax), %eax
	xorl	$1, %eax
	testb	%al, %al
	je	.L48
	movl	$14, %eax
	jmp	.L47
.L48:
	movq	-8(%rbp), %rax
	movzbl	134(%rax), %eax
	xorl	$1, %eax
	testb	%al, %al
	je	.L49
	movl	$15, %eax
	jmp	.L47
.L49:
	movq	-8(%rbp), %rax
	movl	168(%rax), %edx
	movq	-8(%rbp), %rax
	movl	20(%rax), %eax
	cmpl	%eax, %edx
	jge	.L50
	movl	$16, %eax
	jmp	.L47
.L50:
	movq	-8(%rbp), %rax
	movzbl	135(%rax), %eax
	xorl	$1, %eax
	testb	%al, %al
	je	.L51
	movq	-8(%rbp), %rax
	movzbl	175(%rax), %eax
	xorl	$1, %eax
	testb	%al, %al
	je	.L52
	movl	$6, %eax
	jmp	.L47
.L52:
	movq	-8(%rbp), %rax
	movzbl	176(%rax), %eax
	xorl	$1, %eax
	testb	%al, %al
	je	.L53
	movl	$7, %eax
	jmp	.L47
.L53:
	movl	$0, %eax
	jmp	.L47
.L51:
	movq	-8(%rbp), %rax
	movl	104(%rax), %edx
	movq	-8(%rbp), %rax
	movl	(%rax), %eax
	cmpl	%eax, %edx
	jne	.L54
	movl	$1, %eax
	jmp	.L47
.L54:
	movl	$2, %eax
.L47:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	checkresult, .-checkresult
	.section	.rodata
.LC19:
	.string	"Targets"
	.text
	.type	targets_json_handler, @function
targets_json_handler:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$104, %rsp
	.cfi_offset 3, -24
	movl	%edi, -84(%rbp)
	movq	%rsi, -96(%rbp)
	movq	%rdx, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	%rax, -56(%rbp)
	cmpl	$-1, -84(%rbp)
	jne	.L56
	movq	-56(%rbp), %rax
	movl	$9, 112(%rax)
	movl	$1, %eax
	jmp	.L57
.L56:
	cmpl	$1, -84(%rbp)
	jne	.L58
	movq	-56(%rbp), %rax
	movzbl	192(%rax), %eax
	testb	%al, %al
	je	.L59
	movl	$0, -20(%rbp)
	jmp	.L60
.L62:
	movq	-56(%rbp), %rdx
	movl	-20(%rbp), %eax
	cltq
	movzbl	172(%rdx,%rax), %eax
	testb	%al, %al
	je	.L61
	movq	-96(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %edx
	movq	-56(%rbp), %rax
	movl	-20(%rbp), %ecx
	movslq	%ecx, %rcx
	addq	$22, %rcx
	movq	8(%rax,%rcx,8), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	crypto_verify_putc
.L61:
	addl	$1, -20(%rbp)
.L60:
	movq	-56(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	-20(%rbp), %eax
	jg	.L62
.L59:
	movl	$0, %eax
	jmp	.L57
.L58:
	cmpl	$2, -84(%rbp)
	jne	.L63
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	movq	-56(%rbp), %rdx
	leaq	136(%rdx), %rdi
	movl	$19, %r8d
	movl	$18, %ecx
	movl	$0, %edx
	movl	%eax, %esi
	movl	$0, %eax
	call	path_equal
	testb	%al, %al
	je	.L64
	movq	-56(%rbp), %rax
	movb	$0, 160(%rax)
	movq	-56(%rbp), %rax
	movb	$0, 161(%rax)
	movq	-56(%rbp), %rax
	movb	$0, 162(%rax)
	movq	-56(%rbp), %rax
	movb	$0, 163(%rax)
.L64:
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	movq	-56(%rbp), %rdx
	leaq	136(%rdx), %rdi
	movl	$19, %r9d
	movl	$17, %r8d
	movl	$7, %ecx
	movl	$4, %edx
	movl	%eax, %esi
	movl	$0, %eax
	call	path_equal
	testb	%al, %al
	je	.L65
	movq	-56(%rbp), %rax
	movb	$0, 160(%rax)
	movq	-56(%rbp), %rax
	movb	$0, 173(%rax)
	movq	-56(%rbp), %rax
	movb	$0, 174(%rax)
.L65:
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	movq	-56(%rbp), %rdx
	leaq	136(%rdx), %rdi
	movl	$19, %ecx
	movl	$4, %edx
	movl	%eax, %esi
	movl	$0, %eax
	call	path_equal
	testb	%al, %al
	je	.L63
	movl	$0, -24(%rbp)
	jmp	.L66
.L68:
	movq	-56(%rbp), %rdx
	movl	-24(%rbp), %eax
	cltq
	movzbl	172(%rdx,%rax), %eax
	testb	%al, %al
	je	.L67
	movq	-56(%rbp), %rax
	movl	-24(%rbp), %edx
	movslq	%edx, %rdx
	addq	$22, %rdx
	movq	8(%rax,%rdx,8), %rax
	movq	%rax, %rdi
	call	crypto_verify_ctx_init
	movq	-56(%rbp), %rax
	movl	-24(%rbp), %edx
	movslq	%edx, %rdx
	addq	$22, %rdx
	movq	8(%rax,%rdx,8), %rax
	movl	$123, %esi
	movq	%rax, %rdi
	call	crypto_verify_putc
.L67:
	addl	$1, -24(%rbp)
.L66:
	movq	-56(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	-24(%rbp), %eax
	jg	.L68
	movq	-56(%rbp), %rax
	movb	$1, 192(%rax)
.L63:
	cmpl	$3, -84(%rbp)
	jne	.L69
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	movq	-56(%rbp), %rdx
	leaq	136(%rdx), %rdi
	movl	$19, %r8d
	movl	$18, %ecx
	movl	$0, %edx
	movl	%eax, %esi
	movl	$0, %eax
	call	path_equal
	testb	%al, %al
	je	.L70
	movq	-56(%rbp), %rax
	movzbl	163(%rax), %eax
	xorl	$1, %eax
	testb	%al, %al
	je	.L70
	movq	-56(%rbp), %rax
	movzbl	160(%rax), %eax
	testb	%al, %al
	je	.L70
	movq	-56(%rbp), %rax
	movzbl	161(%rax), %eax
	testb	%al, %al
	je	.L70
	movq	-56(%rbp), %rax
	movzbl	162(%rax), %eax
	testb	%al, %al
	je	.L70
	movq	-56(%rbp), %rax
	movl	164(%rax), %eax
	movq	-56(%rbp), %rdx
	cltq
	movb	$1, 172(%rdx,%rax)
	movq	-56(%rbp), %rax
	movl	164(%rax), %ebx
	call	crypto_verify_ctx_new
	movq	%rax, %rcx
	movq	-56(%rbp), %rax
	movslq	%ebx, %rdx
	addq	$22, %rdx
	movq	%rcx, 8(%rax,%rdx,8)
	movq	-56(%rbp), %rax
	movl	164(%rax), %edx
	movq	-56(%rbp), %rax
	movslq	%edx, %rdx
	addq	$22, %rdx
	movq	8(%rax,%rdx,8), %rax
	testq	%rax, %rax
	jne	.L71
	movq	-56(%rbp), %rax
	movl	$3, 112(%rax)
	movl	$1, %eax
	jmp	.L57
.L71:
	movq	-56(%rbp), %rax
	movl	168(%rax), %eax
	leal	1(%rax), %edx
	movq	-56(%rbp), %rax
	movl	%edx, 168(%rax)
.L70:
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	movq	-56(%rbp), %rdx
	leaq	136(%rdx), %rdi
	movl	$19, %r9d
	movl	$17, %r8d
	movl	$7, %ecx
	movl	$4, %edx
	movl	%eax, %esi
	movl	$0, %eax
	call	path_equal
	testb	%al, %al
	je	.L72
	movq	-56(%rbp), %rax
	movzbl	173(%rax), %eax
	testb	%al, %al
	je	.L72
	movq	-56(%rbp), %rax
	movzbl	174(%rax), %eax
	testb	%al, %al
	je	.L72
	movq	-56(%rbp), %rax
	movzbl	135(%rax), %eax
	testb	%al, %al
	je	.L73
	movq	-56(%rbp), %rax
	movl	$5, 112(%rax)
	movl	$1, %eax
	jmp	.L57
.L73:
	movq	-56(%rbp), %rax
	movb	$1, 135(%rax)
.L72:
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	movq	-56(%rbp), %rdx
	leaq	136(%rdx), %rdi
	movl	$19, %ecx
	movl	$4, %edx
	movl	%eax, %esi
	movl	$0, %eax
	call	path_equal
	testb	%al, %al
	je	.L74
	movb	$1, -25(%rbp)
	movl	$0, -32(%rbp)
	jmp	.L75
.L79:
	movq	-56(%rbp), %rdx
	movl	-32(%rbp), %eax
	cltq
	movzbl	172(%rdx,%rax), %eax
	testb	%al, %al
	je	.L76
	cmpb	$0, -25(%rbp)
	je	.L77
	movq	-56(%rbp), %rax
	movl	-32(%rbp), %edx
	movslq	%edx, %rdx
	addq	$22, %rdx
	movq	8(%rax,%rdx,8), %rax
	movq	%rax, %rdi
	call	crypto_verify_result
	testb	%al, %al
	je	.L77
	movl	$1, %eax
	jmp	.L78
.L77:
	movl	$0, %eax
.L78:
	movb	%al, -25(%rbp)
	andb	$1, -25(%rbp)
.L76:
	addl	$1, -32(%rbp)
.L75:
	movq	-56(%rbp), %rax
	movl	16(%rax), %eax
	cmpl	-32(%rbp), %eax
	jg	.L79
	movzbl	-25(%rbp), %eax
	xorl	$1, %eax
	testb	%al, %al
	je	.L80
	movq	-56(%rbp), %rax
	movl	$8, 112(%rax)
	movl	$1, %eax
	jmp	.L57
.L80:
	movq	-56(%rbp), %rax
	movb	$0, 192(%rax)
	movq	-56(%rbp), %rax
	movb	$1, 134(%rax)
.L74:
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	testl	%eax, %eax
	jne	.L69
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	checkresult
	movl	%eax, %edx
	movq	-56(%rbp), %rax
	movl	%edx, 112(%rax)
	movl	$1, %eax
	jmp	.L57
.L69:
	cmpl	$6, -84(%rbp)
	jle	.L81
	cmpl	$9, -84(%rbp)
	jg	.L81
	movb	$0, -33(%rbp)
	movq	-56(%rbp), %rax
	addq	$136, %rax
	movq	%rax, -64(%rbp)
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	movl	%eax, -68(%rbp)
	movl	-68(%rbp), %esi
	movq	-64(%rbp), %rax
	movl	$19, %r9d
	movl	$1, %r8d
	movl	$18, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	movl	$0, %eax
	call	path_equal
	testb	%al, %al
	je	.L82
	movq	-96(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	process_keyid
	movb	%al, -33(%rbp)
.L82:
	movl	-68(%rbp), %esi
	movq	-64(%rbp), %rax
	movl	$19, %r9d
	movl	$2, %r8d
	movl	$18, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	movl	$0, %eax
	call	path_equal
	testb	%al, %al
	je	.L83
	movq	-96(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	process_method
	movb	%al, -33(%rbp)
.L83:
	movl	-68(%rbp), %esi
	movq	-64(%rbp), %rax
	movl	$19, %r9d
	movl	$3, %r8d
	movl	$18, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	movl	$0, %eax
	call	path_equal
	testb	%al, %al
	je	.L84
	movq	-96(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	process_sig
	movb	%al, -33(%rbp)
.L84:
	movl	-68(%rbp), %esi
	movq	-64(%rbp), %rax
	movl	$19, %r8d
	movl	$5, %ecx
	movl	$4, %edx
	movq	%rax, %rdi
	movl	$0, %eax
	call	path_equal
	testb	%al, %al
	je	.L85
	movq	-96(%rbp), %rax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L86
	movq	-56(%rbp), %rax
	movl	$10, 112(%rax)
	movl	$1, %eax
	jmp	.L57
.L86:
	movb	$1, -33(%rbp)
.L85:
	movl	-68(%rbp), %esi
	movq	-64(%rbp), %rax
	movl	$19, %r8d
	movl	$6, %ecx
	movl	$4, %edx
	movq	%rax, %rdi
	movl	$0, %eax
	call	path_equal
	testb	%al, %al
	je	.L87
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	get_time
	movl	%eax, %edx
	movq	-56(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, %edx
	ja	.L88
	movq	-56(%rbp), %rax
	movl	$11, 112(%rax)
	movl	$1, %eax
	jmp	.L57
.L88:
	movq	-56(%rbp), %rax
	movb	$1, 133(%rax)
	movb	$1, -33(%rbp)
.L87:
	movl	-68(%rbp), %esi
	movq	-64(%rbp), %rax
	movl	$19, %r8d
	movl	$16, %ecx
	movl	$4, %edx
	movq	%rax, %rdi
	movl	$0, %eax
	call	path_equal
	testb	%al, %al
	je	.L89
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	get_num
	movl	%eax, %edx
	movq	-56(%rbp), %rax
	movl	%edx, 104(%rax)
	movq	-56(%rbp), %rax
	movl	104(%rax), %edx
	movq	-56(%rbp), %rax
	movl	(%rax), %eax
	cmpl	%eax, %edx
	jge	.L90
	movq	-56(%rbp), %rax
	movl	$12, 112(%rax)
	movl	$1, %eax
	jmp	.L57
.L90:
	movq	-56(%rbp), %rax
	movb	$1, 132(%rax)
	movb	$1, -33(%rbp)
.L89:
	movl	-68(%rbp), %esi
	movq	-64(%rbp), %rax
	subq	$8, %rsp
	pushq	$19
	movl	$9, %r9d
	movl	$8, %r8d
	movl	$17, %ecx
	movl	$4, %edx
	movq	%rax, %rdi
	movl	$0, %eax
	call	path_equal
	addq	$16, %rsp
	testb	%al, %al
	je	.L91
	movq	-56(%rbp), %rax
	movq	24(%rax), %rax
	movq	-96(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L92
	movq	-56(%rbp), %rax
	movb	$1, 173(%rax)
.L92:
	movb	$1, -33(%rbp)
.L91:
	movl	-68(%rbp), %esi
	movq	-64(%rbp), %rax
	subq	$8, %rsp
	pushq	$19
	movl	$10, %r9d
	movl	$8, %r8d
	movl	$17, %ecx
	movl	$4, %edx
	movq	%rax, %rdi
	movl	$0, %eax
	call	path_equal
	addq	$16, %rsp
	testb	%al, %al
	je	.L93
	movq	-56(%rbp), %rax
	movq	32(%rax), %rax
	movq	-96(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L94
	movq	-56(%rbp), %rax
	movb	$1, 174(%rax)
.L94:
	movb	$1, -33(%rbp)
.L93:
	movl	-68(%rbp), %esi
	movq	-64(%rbp), %rax
	subq	$8, %rsp
	pushq	$19
	movl	$14, %r9d
	movl	$12, %r8d
	movl	$17, %ecx
	movl	$4, %edx
	movq	%rax, %rdi
	movl	$0, %eax
	call	path_equal
	addq	$16, %rsp
	testb	%al, %al
	je	.L95
	movq	-56(%rbp), %rax
	movzbl	173(%rax), %eax
	testb	%al, %al
	je	.L96
	movq	-56(%rbp), %rax
	movzbl	174(%rax), %eax
	testb	%al, %al
	je	.L96
	movl	$0, -40(%rbp)
	jmp	.L97
.L98:
	movl	-40(%rbp), %eax
	movl	-40(%rbp), %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	addl	$1, %eax
	movslq	%eax, %rdx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %edx
	movl	-40(%rbp), %eax
	addl	%eax, %eax
	movslq	%eax, %rcx
	movq	-96(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	%edx, %esi
	movl	%eax, %edi
	movl	$0, %eax
	call	hex
	movl	%eax, %ecx
	movq	-56(%rbp), %rdx
	movl	-40(%rbp), %eax
	cltq
	movb	%cl, 40(%rdx,%rax)
	addl	$1, -40(%rbp)
.L97:
	cmpl	$63, -40(%rbp)
	jle	.L98
	movq	-56(%rbp), %rax
	movb	$1, 175(%rax)
.L96:
	movb	$1, -33(%rbp)
.L95:
	movl	-68(%rbp), %esi
	movq	-64(%rbp), %rax
	movl	$19, %r9d
	movl	$15, %r8d
	movl	$17, %ecx
	movl	$4, %edx
	movq	%rax, %rdi
	movl	$0, %eax
	call	path_equal
	testb	%al, %al
	je	.L99
	movq	-56(%rbp), %rax
	movzbl	173(%rax), %eax
	testb	%al, %al
	je	.L100
	movq	-56(%rbp), %rax
	movzbl	174(%rax), %eax
	testb	%al, %al
	je	.L100
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	get_num
	movl	%eax, %edx
	movq	-56(%rbp), %rax
	movl	%edx, 108(%rax)
	movq	-56(%rbp), %rax
	movb	$1, 176(%rax)
.L100:
	movb	$1, -33(%rbp)
.L99:
	movzbl	-33(%rbp), %eax
	xorl	$1, %eax
	testb	%al, %al
	je	.L81
	movq	-56(%rbp), %rax
	movl	$9, 112(%rax)
	movl	$1, %eax
	jmp	.L57
.L81:
	movq	-56(%rbp), %rax
	movl	128(%rax), %eax
	cmpl	$1, %eax
	je	.L102
	cmpl	$1, %eax
	jb	.L103
	cmpl	$2, %eax
	je	.L104
	jmp	.L101
.L103:
	cmpl	$2, -84(%rbp)
	jne	.L122
	movq	-56(%rbp), %rax
	movl	$1, 128(%rax)
	movl	$0, %eax
	jmp	.L57
.L102:
	cmpl	$3, -84(%rbp)
	jne	.L106
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	testl	%eax, %eax
	jne	.L107
	movq	-56(%rbp), %rax
	movl	$4, 112(%rax)
	movl	$1, %eax
	jmp	.L57
.L107:
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	leal	-1(%rax), %edx
	movq	-56(%rbp), %rax
	movl	%edx, 156(%rax)
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	testl	%eax, %eax
	je	.L108
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	leal	-1(%rax), %edx
	movq	-56(%rbp), %rax
	movslq	%edx, %rdx
	addq	$32, %rdx
	movl	8(%rax,%rdx,4), %eax
	cmpl	$18, %eax
	jne	.L108
	movq	-56(%rbp), %rax
	movl	$2, 128(%rax)
.L108:
	movl	$0, %eax
	jmp	.L57
.L106:
	cmpl	$6, -84(%rbp)
	jne	.L123
	movl	$0, -44(%rbp)
	jmp	.L110
.L113:
	movl	-44(%rbp), %eax
	cltq
	movq	targets_key_strings(,%rax,8), %rdx
	movq	-96(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L124
	addl	$1, -44(%rbp)
.L110:
	cmpl	$16, -44(%rbp)
	jle	.L113
	jmp	.L112
.L124:
	nop
.L112:
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	leal	1(%rax), %ecx
	movq	-56(%rbp), %rdx
	movl	%ecx, 156(%rdx)
	movl	-44(%rbp), %ecx
	movq	-56(%rbp), %rdx
	cltq
	addq	$32, %rax
	movl	%ecx, 8(%rdx,%rax,4)
	movq	-56(%rbp), %rax
	movl	$2, 128(%rax)
	movl	$0, %eax
	jmp	.L57
.L104:
	cmpl	$2, -84(%rbp)
	jne	.L114
	movq	-56(%rbp), %rax
	movl	$1, 128(%rax)
	movl	$0, %eax
	jmp	.L57
.L114:
	cmpl	$4, -84(%rbp)
	jne	.L115
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	leal	1(%rax), %ecx
	movq	-56(%rbp), %rdx
	movl	%ecx, 156(%rdx)
	movq	-56(%rbp), %rdx
	cltq
	addq	$32, %rax
	movl	$18, 8(%rdx,%rax,4)
	movl	$0, %eax
	jmp	.L57
.L115:
	cmpl	$5, -84(%rbp)
	jne	.L116
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	leal	-1(%rax), %edx
	movq	-56(%rbp), %rax
	movl	%edx, 156(%rax)
	movq	-56(%rbp), %rax
	movl	156(%rax), %edx
	movq	-56(%rbp), %rax
	movslq	%edx, %rdx
	addq	$32, %rdx
	movl	8(%rax,%rdx,4), %eax
	cmpl	$18, %eax
	jne	.L101
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	testl	%eax, %eax
	je	.L117
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	leal	-1(%rax), %edx
	movq	-56(%rbp), %rax
	movslq	%edx, %rdx
	addq	$32, %rdx
	movl	8(%rax,%rdx,4), %eax
	cmpl	$18, %eax
	je	.L118
.L117:
	movq	-56(%rbp), %rax
	movl	$1, 128(%rax)
.L118:
	movl	$0, %eax
	jmp	.L57
.L116:
	cmpl	$6, -84(%rbp)
	jle	.L101
	cmpl	$9, -84(%rbp)
	jg	.L101
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	leal	-1(%rax), %edx
	movq	-56(%rbp), %rax
	movslq	%edx, %rdx
	addq	$32, %rdx
	movl	8(%rax,%rdx,4), %eax
	cmpl	$18, %eax
	jne	.L119
	movl	$0, %eax
	jmp	.L57
.L119:
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	cmpl	$1, %eax
	je	.L120
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	leal	-2(%rax), %edx
	movq	-56(%rbp), %rax
	movslq	%edx, %rdx
	addq	$32, %rdx
	movl	8(%rax,%rdx,4), %eax
	cmpl	$18, %eax
	je	.L121
.L120:
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	leal	-1(%rax), %edx
	movq	-56(%rbp), %rax
	movl	%edx, 156(%rax)
	movq	-56(%rbp), %rax
	movl	$1, 128(%rax)
	movl	$0, %eax
	jmp	.L57
.L121:
	movq	-56(%rbp), %rax
	movl	156(%rax), %eax
	leal	-1(%rax), %edx
	movq	-56(%rbp), %rax
	movl	%edx, 156(%rax)
	movl	$0, %eax
	jmp	.L57
.L122:
	nop
	jmp	.L101
.L123:
	nop
.L101:
	movq	-56(%rbp), %rax
	movl	$9, 112(%rax)
	movl	$1, %eax
.L57:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	targets_json_handler, .-targets_json_handler
	.globl	targets_init
	.type	targets_init, @function
targets_init:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	%edx, -32(%rbp)
	movq	%rcx, -40(%rbp)
	movl	%r8d, -44(%rbp)
	movl	%r9d, -48(%rbp)
	movq	-24(%rbp), %rax
	movl	-28(%rbp), %edx
	movl	%edx, (%rax)
	movq	-24(%rbp), %rax
	movl	-32(%rbp), %edx
	movl	%edx, 4(%rax)
	movl	$0, -4(%rbp)
	jmp	.L126
.L129:
	cmpl	$0, -4(%rbp)
	jg	.L130
	movl	$0, %eax
	call	new_sig
	cltq
	movq	%rax, %rcx
	movq	-24(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	movq	%rcx, 8(%rax,%rdx,8)
	movq	-24(%rbp), %rax
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	movq	8(%rax,%rdx,8), %rcx
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$4, %rax
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, (%rcx)
	movq	-24(%rbp), %rdx
	movl	-4(%rbp), %eax
	cltq
	movb	$0, 172(%rdx,%rax)
	addl	$1, -4(%rbp)
.L126:
	movl	-4(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L129
	jmp	.L128
.L130:
	nop
.L128:
	movq	-24(%rbp), %rax
	movl	-4(%rbp), %edx
	movl	%edx, 16(%rax)
	movq	-24(%rbp), %rax
	movl	$0, 168(%rax)
	movq	-24(%rbp), %rax
	movl	-48(%rbp), %edx
	movl	%edx, 20(%rax)
	movq	-24(%rbp), %rax
	movl	$0, 128(%rax)
	movl	$0, %eax
	call	gj_ctx_new
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, 120(%rax)
	movq	-24(%rbp), %rax
	movq	120(%rax), %rax
	movq	-24(%rbp), %rdx
	movl	$targets_json_handler, %esi
	movq	%rax, %rdi
	call	gj_init
	movq	-24(%rbp), %rax
	movb	$0, 134(%rax)
	movq	-24(%rbp), %rax
	movzbl	134(%rax), %edx
	movq	-24(%rbp), %rax
	movb	%dl, 133(%rax)
	movq	-24(%rbp), %rax
	movzbl	133(%rax), %edx
	movq	-24(%rbp), %rax
	movb	%dl, 132(%rax)
	movq	-24(%rbp), %rax
	movl	$0, 156(%rax)
	movq	-24(%rbp), %rax
	movb	$0, 175(%rax)
	movq	-24(%rbp), %rax
	movb	$0, 176(%rax)
	movq	-24(%rbp), %rax
	movb	$0, 192(%rax)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	targets_init, .-targets_init
	.globl	targets_process
	.type	targets_process, @function
targets_process:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	%eax, %edx
	movq	-8(%rbp), %rax
	movq	120(%rax), %rax
	movq	-16(%rbp), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	gj_process
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	targets_process, .-targets_process
	.globl	targets_get_result
	.type	targets_get_result, @function
targets_get_result:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	movq	-8(%rbp), %rax
	leaq	40(%rax), %rcx
	movq	-16(%rbp), %rax
	movl	$64, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy
	movq	-8(%rbp), %rax
	movl	104(%rax), %edx
	movq	-32(%rbp), %rax
	movl	%edx, (%rax)
	movq	-8(%rbp), %rax
	movl	108(%rax), %edx
	movq	-24(%rbp), %rax
	movl	%edx, (%rax)
	movq	-8(%rbp), %rax
	movl	112(%rax), %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	targets_get_result, .-targets_get_result
	.ident	"GCC: (GNU) 6.3.1 20170109"
	.section	.note.GNU-stack,"",@progbits
