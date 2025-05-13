#!/usr/bin/env fish

echo "Fixing noesis_libc stdio types..."

# Replace all occurrences of FILE with NLIBC_FILE in src/stdio/stdio.c
set files_to_fix ./noesis_libc/src/stdio/stdio.c ./noesis_libc/src/stdio/stdio_tmp.c

# Make backup of files first
for file in $files_to_fix
    cp $file $file.bak
end

# Replace the struct type
echo "Replacing type definitions..."
for file in $files_to_fix
    sed -i '' 's/FILE /NLIBC_FILE /g' $file
    sed -i '' 's/FILE\* /NLIBC_FILE\* /g' $file
    sed -i '' 's/FILE\*)/NLIBC_FILE\*)/g' $file
    sed -i '' 's/sizeof(FILE)/sizeof(NLIBC_FILE)/g' $file
end

echo "Done! Original files backed up with .bak extension"
echo "Please compile the project to verify the fix"
