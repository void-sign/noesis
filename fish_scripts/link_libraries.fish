#
# Copyright (c) 2025 Napol Thanarangkaun (napol@noesis.run)
# Licensed under Noesis License - See LICENSE file for details
#


# This script creates libraries from the core components
# Note: This provides the standard API for external projects

# Clean any previous builds
make clean

# Modify compilation flags for position-independent code
set CFLAGS "-Wall -Wextra -std=c99 -fPIC"
make CFLAGS="$CFLAGS"

# Create lib directory if it doesn't exist
mkdir -p lib

# Create the static library
ar rcs lib/libnoesis.a object/core/*.o object/utils/*.o object/asm/*.o object/api/*.o

# Create the shared library
gcc -shared -o lib/libnoesis.so object/core/*.o object/utils/*.o object/asm/*.o object/api/*.o

# Copy header files to include directory for distribution
mkdir -p lib/include/noesis
cp include/api/noesis_api.h lib/include/noesis/

# Create pkg-config file
mkdir -p lib/pkgconfig
cat > lib/pkgconfig/noesis.pc << EOF
prefix=(pwd)
exec_prefix=\${prefix}
includedir=\${prefix}/lib/include
libdir=\${prefix}/lib

Name: Noesis
Description: Synthetic consciousness simulation engine
Version: 1.0.0
Cflags: -I\${includedir}
Libs: -L\${libdir} -lnoesis
EOF

echo "Libraries created:"
echo " - Static library: lib/libnoesis.a"
echo " - Shared library: lib/libnoesis.so"
echo "Header files: lib/include/noesis/"
echo "Package configuration: lib/pkgconfig/noesis.pc"
echo
echo "To use in other projects, add the following to your compilation flags:"
echo "  CFLAGS=\"-I(pwd)/lib/include\""
echo "  LDFLAGS=\"-L(pwd)/lib -lnoesis\""
echo
echo "Or set PKG_CONFIG_PATH:"
echo "  set -x PKG_CONFIG_PATH \"(pwd)/lib/pkgconfig:\$PKG_CONFIG_PATH\""
echo "  pkg-config --cflags --libs noesis"
