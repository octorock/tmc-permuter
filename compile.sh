#!/bin/bash
# Compile script used by the permuter.
# usage: ./compile.sh C_FILE UNUSED? OUTPUT_O

source "$(dirname "$0")/common.sh"

# .c to .o
$CPP $CPPFLAGS $1 -o ${1%c*}i
$PREPROC $BUILD_NAME ${1%c*}i $TMC/charmap.txt | $CC1 $CFLAGS -o  ${1%c*}s
echo -e "\t.text\n\t.align\t2, 0 @ Don't pad with nop\n" >>  ${1%c*}s
$AS $ASFLAGS -o $3 ${1%c*}s

# Cleanup
rm ${1%c*}i ${1%c*}s


