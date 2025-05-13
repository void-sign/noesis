/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 * Licensed under Noesis License - See LICENSE file for details
 */

/*
 * Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software under the following conditions:
 *
 * 1. The Software may be used, copied, modified, merged, published, distributed,
 *    sublicensed, and sold under the terms specified in this license.
 *
 * 2. Redistribution of the Software or modifications thereof must include the
 *    original copyright notice and this license.
 *
 * 3. Any use of the Software in production or commercial environments must provide
 *    clear attribution to the original author(s) as defined in the copyright notice.
 *
 * 4. The Software may not be used for any unlawful purpose, or in a way that could
 *    harm other humans, animals, or living beings, either directly or indirectly.
 *
 * 5. Any modifications made to the Software must be clearly documented and made
 *    available under the same Noesis License or a compatible license.
 *
 * 6. If the Software is a core component of a profit-generating system, 
 *    the user must donate 10% of the net profit directly resulting from such
 *    use to a recognized non-profit or charitable foundation supporting humans 
 *    or other living beings.
 */

.section __TEXT,__text
.global _scomp
_scomp:
    movq %rdi, %rax        # Copy first string pointer to RAX
    movq %rsi, %rbx        # Copy second string pointer to RBX
strcmp_loop:
    movb (%rax), %cl       # Load byte from first string
    movb (%rbx), %dl       # Load byte from second string
    cmpb %cl, %dl          # Compare bytes
    jne strcmp_done        # If not equal, jump to done
    testb %cl, %cl         # Check if null terminator
    je strcmp_equal        # If null, strings are equal
    incq %rax              # Move to next byte in first string
    incq %rbx              # Move to next byte in second string
    jmp strcmp_loop        # Repeat loop
strcmp_done:
    subb %dl, %cl          # Return difference of bytes
    movb %cl, %al
    ret
strcmp_equal:
    xorq %rax, %rax        # Return 0 for equal strings
    ret
