/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
/* 
// Most basic version possible
.global _noesis_read
_noesis_read:
    // Just return 4
    movq $4, %rax
    ret
