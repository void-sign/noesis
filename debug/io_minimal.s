// Most basic version possible
.global _noesis_read
_noesis_read:
    // Just return 4
    movq $4, %rax
    ret
