#!/bin/bash
# Compile script used by the permuter.
# usage: ./compile.sh C_FILE -o OUTPUT_FILE

# Modify path to make sure agbcc and arm-non-eabi-as are available.
#export PATH=$PATH:/opt/devkitpro/devkitARM/bin/:/agbcc

CC1="agbcc"
CFLAGS="-O2 -Wimplicit -Wparentheses -Werror -Wno-multichar"
AS="arm-none-eabi-as"
ASFLAGS="-mcpu=arm7tdmi"

# Compile and assemble .c file
$CC1 $CFLAGS $1 -o - | $AS $ASFLAGS -o $3 -
