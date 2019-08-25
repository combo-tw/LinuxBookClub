#!/bin/bash
#
# Build ARM kernel 4.14.y for QEMU Raspberry Pi Emulation
#
#######################################################

TOOLCHAIN=arm-linux-gnueabihf

# Combine homework with linux kernel source
git checkout -- linux
echo "Input target folder name:"
read foldername
cp -Rv ../chapter/$foldername/* ./

cd linux

# Use all available cores for compilation
MAKEFLAGS="-k -j$(nproc)"

KERNEL_VERSION=$(make kernelversion)
KERNEL_TARGET_FILE_NAME=../qemu-kernel-$KERNEL_VERSION

make ARCH=arm versatile_defconfig
echo "Building Qemu Raspberry Pi kernel qemu-kernel-$KERNEL_VERSION"

cat >> .config << EOF
CONFIG_CROSS_COMPILE="$TOOLCHAIN"
EOF

cat ../config_file >> .config
cat ../config_ip_tables >> .config

make $MAKEFLAGS ARCH=arm CROSS_COMPILE=${TOOLCHAIN}- menuconfig
make $MAKEFLAGS ARCH=arm CROSS_COMPILE=${TOOLCHAIN}- bzImage dtbs
cp arch/arm/boot/zImage $KERNEL_TARGET_FILE_NAME

if [ -e arch/arm/boot/dts/versatile-pb.dtb ] ; then
    cp arch/arm/boot/dts/versatile-pb.dtb ../

    read -p "Execute QEMU? [Y/n] " prompt

    if [[ $prompt =~ [yY](es)* ]] ; then
        if [ ! -e ../2018-11-13-raspbian-stretch.img ] ; then
            wget https://downloads.raspberrypi.org/raspbian/images/raspbian-2018-11-15/2018-11-13-raspbian-stretch.zip
            unzip 2018-11-13-raspbian-stretch.zip -d ../
            rm 2018-11-13-raspbian-stretch.zip
        fi

        sudo qemu-system-arm \
            -M versatilepb \
            -cpu arm1176 \
            -m 256 \
            -hda ../2018-11-13-raspbian-stretch.img \
            -net nic \
            -net user,hostfwd=tcp::5022-:22 \
            -dtb ../versatile-pb.dtb \
            -kernel $KERNEL_TARGET_FILE_NAME \
            -append 'root=/dev/sda2 panic=1' \
            -no-reboot
    fi
fi

cd ..
