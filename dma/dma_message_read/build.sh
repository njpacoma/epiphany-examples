#!/bin/bash

set -e

ESDK=${EPIPHANY_HOME}
ELIBS=${ESDK}/tools/host/lib
EINCS="-I ${ESDK}/tools/host/include -I ${ESDK}/tools/host/include/uapi"
ELDF=${ESDK}/bsps/current/fast.ldf

# Create the binaries directory
mkdir -p bin/

CROSS_PREFIX=
case $(uname -p) in
	arm*)
		# Use native arm compiler (no cross prefix)
		CROSS_PREFIX=
		;;
	   *)
		# Use cross compiler
		CROSS_PREFIX="arm-linux-gnueabihf-"
		;;
esac

# Build HOST side application
${CROSS_PREFIX}gcc src/dma_message_a.c -o bin/dma_message_a.elf ${EINCS} -L ${ELIBS} -le-hal -le-loader -lpthread

# Build DEVICE side program
e-gcc -O3 -T ${ELDF} src/e_dma_message_a.c -o bin/e_dma_message_a.elf -le-lib 


# Convert ebinary to SREC file
e-objcopy --srec-forceS3 --output-target srec bin/e_dma_message_a.elf bin/e_dma_message_a.srec



