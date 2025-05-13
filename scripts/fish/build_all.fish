#!/usr/bin/env fish
#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#



echo "Building Noesis Core..."
rm -rf build/obj
rm -f noesis noesis_tests build/bin/qbuild build/bin/qrun
mkdir -p build/obj/core build/obj/utils build/obj/api build/obj/quantum build/obj/quantum/field build/bin
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/core/emotion.c -o build/obj/core/emotion.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/core/intent.c -o build/obj/core/intent.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/core/logic.c -o build/obj/core/logic.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/core/main.c -o build/obj/core/main.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/core/memory.c -o build/obj/core/memory.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/core/perception.c -o build/obj/core/perception.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/utils/data.c -o build/obj/utils/data.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/utils/helper.c -o build/obj/utils/helper.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/utils/io_helper.c -o build/obj/utils/io_helper.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/utils/io_functions.c -o build/obj/utils/io_functions.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/utils/noesis_lib.c -o build/obj/utils/noesis_lib.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/utils/noesis_libc_stubs.c -o build/obj/utils/noesis_libc_stubs.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/utils/timer.c -o build/obj/utils/timer.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/utils/string_functions.c -o build/obj/utils/string_functions.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/api/noesis_api.c -o build/obj/api/noesis_api.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/quantum/backend_ibm.c -o build/obj/quantum/backend_ibm.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/quantum/backend_stub.c -o build/obj/quantum/backend_stub.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/quantum/compiler.c -o build/obj/quantum/compiler.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/quantum/export_qasm.c -o build/obj/quantum/export_qasm.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/quantum/quantum.c -o build/obj/quantum/quantum.o
gcc -Wall -Wextra -std=c99 -Iinclude -I. -Ilibs/noesis_libc/include -c src/quantum/field/quantum_field.c -o build/obj/quantum/field/quantum_field.o
# Assembly files have been replaced with C implementations
gcc build/obj/core/emotion.o build/obj/core/intent.o build/obj/core/logic.o build/obj/core/main.o build/obj/core/memory.o build/obj/core/perception.o build/obj/utils/data.o build/obj/utils/helper.o build/obj/utils/io_helper.o build/obj/utils/io_functions.o build/obj/utils/noesis_lib.o build/obj/utils/noesis_libc_stubs.o build/obj/utils/timer.o build/obj/utils/string_functions.o build/obj/api/noesis_api.o build/obj/quantum/backend_ibm.o build/obj/quantum/backend_stub.o build/obj/quantum/compiler.o build/obj/quantum/export_qasm.o build/obj/quantum/quantum.o build/obj/quantum/field/quantum_field.o -Lbuild/lib -o noesis

echo "Build complete."
echo