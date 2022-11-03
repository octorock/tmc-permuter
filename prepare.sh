#!/bin/bash
#set -x
# Prepares the input files so they can be used by the permuter.
# Expects input.c and input.s to be in this folder.
# Creates base.c and target.s.

source ./common.sh

BASE_C_FILE="base.c"
TARGET_S_FILE="target.s"
TARGET_O_FILE="target.o"

echo "Prepare base.c"

# https://github.com/eliben/pycparser/wiki/FAQ#what-do-i-do-about-__attribute
#echo "#define __attribute__(x)" > $BASE_C_FILE
#echo "#define static_assert(x)" >> $BASE_C_FILE
echo "" > $BASE_C_FILE

cat input.c >> $BASE_C_FILE
$CPP $CPPFLAGS $BASE_C_FILE -o base.i
$PREPROC $BUILD_NAME base.i $TMC/charmap.txt > $BASE_C_FILE

python prepare.py
# Remove assertions (as they currently fail because PACKED is not supported)
# sed -i '/^extern char assertion/d' $BASE_C_FILE

echo "Prepare target.s"
cat > $TARGET_S_FILE <<EOF
.include "asm/macros.inc"

.text
.syntax divided
EOF
cat input.s >> $TARGET_S_FILE

# Data pointer sections need to be aligned.
sed -i 's/^_data/\.align 2,0\n_data/gm' $TARGET_S_FILE

echo "Assemble target.o"
$PREPROC $BUILD_NAME $TARGET_S_FILE -- $PREPROC_INC_PATHS | $AS $ASFLAGS -o $TARGET_O_FILE