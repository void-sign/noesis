// Step by step working up from the minimal version
.global _noesis_read
_noesis_read:
    // Save buffer address from rsi
    movq %rsi, %r10
    
    // Check if buffer pointer is null
    testq %r10, %r10
    jz .return_zero
    
    // Check buffer size
    cmpq $5, %rdx
    jl .return_zero
    
    // Write "test" into the buffer
    movb $'t', (%r10)
    movb $'e', 1(%r10)
    movb $'s', 2(%r10)
    movb $'t', 3(%r10)
    movb $0, 4(%r10)
    
    // Return 4 bytes read
    movq $4, %rax
    ret

.return_zero:
    xorq %rax, %rax   // Return 0
    ret
