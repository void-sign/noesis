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

// backend_ibm.c – stub for IBM Quantum backend interaction

#include "../../include/quantum/backend.h"
#include "../../include/quantum/quantum.h"

int backend_send_to_ibm(const Circuit* circuit) {
    // NOTE: Real IBMQ integration would need HTTP/HTTPS API calls.
    // This stub simulates successful upload.
    
    // Iterate over the circuit and simulate sending
    int sent = 0;
    for (int i = 0; i < circuit->num_gates; ++i) {
        // simulate processing each gate
        ++sent;
    }

    // Return 0 on success
    return 0;
}
