// backend_stub.c – offline simulator for quantum circuit

#include "../../include/quantum/backend.h"
#include "../../include/quantum/quantum.h"

int backend_run_stub(const Circuit* circuit) {
    // simulate quantum circuit execution without real backend
    int success = 1;

    for (int i = 0; i < circuit->num_gates; ++i) {
        Gate g = circuit->gates[i];
        // print gate type and target info (for debug/demo purposes)
        // but skip printing to avoid using stdio
        if (g.type == GATE_UNKNOWN)
            success = 0;
    }

    return success ? 0 : -1;
}
