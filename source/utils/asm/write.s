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
.global ___start
.global _write_message
.global _pstring

___start:
    # Call write_message to print "Hello, World!\n"
    lea message(%rip), %rdi # pointer to message
    movq $14, %rsi         # message length
    call _write_message

    # Exit the program with status code 0
    movq $60, %rax         # syscall: exit on Linux
    xorq %rdi, %rdi        # exit code 0
    syscall

_write_message:
    # Use the arguments passed in registers
    movq $1, %rax          # syscall: write on Linux
    movq $1, %rdi          # file descriptor: stdout
    syscall
    ret

_pstring:
    # Simplified printf implementation for strings using _write_message
    movq %rsi, %rdi        # pointer to string
    movq %rdx, %rsi        # string length
    call _write_message    # call write_message to print
    ret

.section __TEXT,__cstring
message:
    .asciz "Hello, World!\n"
debug_message:
    .asciz "write_message called\n"
