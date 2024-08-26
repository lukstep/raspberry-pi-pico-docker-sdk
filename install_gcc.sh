#!/bin/bash

RET_VALUE=$?
RED='\033[0;31m'
NC='\033[0m' # No Color

apt-get update -y && \
apt-get upgrade -y && \
apt-get install -y autoconf automake autotools-dev curl python3 python3-pip libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev libslirp-dev


if [ $RET_VALUE != 0 ]; then
    echo "${RED}Instalation failed!${NC}"
    exit 1
fi

mkdir -p /opt/riscv/gcc14-rp2350-no-zcmp

chown -R "$(whoami)" /opt/riscv/gcc14-rp2350-no-zcmp

git clone --depth 1 https://github.com/riscv/riscv-gnu-toolchain /home/riscv-gnu-toolchain

if [ $RET_VALUE != 0 ]; then
    echo "${RED}Cloning RISC-V repo failed!${NC}"
    exit 1
fi

cd /home/riscv-gnu-toolchain || exit

git clone --depth 1 https://github.com/gcc-mirror/gcc gcc-14 -b releases/gcc-14

if [ $RET_VALUE != 0 ]; then
    echo "${RED}Cloning GCC repo failed!${NC}"
    exit 1
fi

./configure --prefix=/opt/riscv/gcc14-rp2350-no-zcmp \
    --with-arch=rv32ima_zicsr_zifencei_zba_zbb_zbs_zbkb_zca_zcb --with-abi=ilp32 \
    --with-multilib-generator="rv32ima_zicsr_zifencei_zba_zbb_zbs_zbkb_zca_zcb-ilp32--;rv32imac_zicsr_zifencei_zba_zbb_zbs_zbkb-ilp32--" \
    --with-gcc-src=`pwd`/gcc-14

if [ $RET_VALUE != 0 ]; then
    echo "${RED}Configure failed!${NC}"
    exit 1
fi

make -j$(nproc)

cd /home || exit

rm -rf /home/riscv-gnu-toolchain
