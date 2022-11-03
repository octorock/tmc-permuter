#!/bin/bash
export PATH=$PATH:/opt/devkitpro/devkitARM/bin/
TMC=/home/octorock/git/tmc

PREPROC=$TMC/tools/bin/preproc
PREPROC_INC_PATHS="$TMC"
AS="arm-none-eabi-as"
ASFLAGS="-mcpu=arm7tdmi"
BUILD_NAME="tmc"
CPP="arm-none-eabi-cpp -E"
CPPFLAGS="-I $TMC/tools/agbcc -I $TMC/tools/agbcc/include -iquote $TMC/include -nostdinc -undef"
CC1=$TMC/tools/agbcc/bin/agbcc
CFLAGS="-O2 -Wimplicit -Wparentheses -Werror -Wno-multichar"