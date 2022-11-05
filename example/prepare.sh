#!/bin/bash -e
# Prepares the input files so they can be used by the permuter.
# Expects input.c and input.s to be in this folder.
# Creates base.c and target.s.

export PATH=$PATH:/opt/devkitpro/devkitARM/bixn/
TMC=/repo

PREPROC=$TMC/tools/bin/preproc
PREPROC_INC_PATHS="$TMC"
AS="arm-none-eabi-as"
ASFLAGS="-mcpu=arm7tdmi"
BUILD_NAME="tmc"
CPP="arm-none-eabi-cpp -E"
CPPFLAGS="-I $TMC/tools/agbcc -I $TMC/tools/agbcc/include -iquote $TMC/include -nostdinc -undef"

BASE_C_FILE="base.c"
TARGET_S_FILE="target.s"
TARGET_O_FILE="target.o"

echo "Prepare base.c"
cat input.c > $BASE_C_FILE
$CPP $CPPFLAGS $BASE_C_FILE -o base.i
$PREPROC $BUILD_NAME base.i $TMC/charmap.txt > $BASE_C_FILE
python3 prepare.py

echo "Prepare target.s"
cat > $TARGET_S_FILE <<EOF
.include "asm/macros.inc"

.text
.syntax divided
EOF
cat input.s >> $TARGET_S_FILE
echo >> $TARGET_S_FILE # Add newline at the end.

# Data pointer sections need to be aligned.
sed -i 's/^_data/\.align 2,0\n_data/gm' $TARGET_S_FILE

echo "Assemble target.o"
$PREPROC $BUILD_NAME $TARGET_S_FILE -- $PREPROC_INC_PATHS | $AS $ASFLAGS -o $TARGET_O_FILE