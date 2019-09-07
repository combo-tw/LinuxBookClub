#!/bin/bash
#
# Build ARM kernel 4.14.y for QEMU Raspberry Pi Emulation
#
#######################################################

TOOLCHAIN=arm-linux-gnueabihf

# Combine homework with linux kernel source
git checkout -- linux
echo "Input target folder number:"
read foldernumber
find ../chapter -type d -name $foldernumber-* -exec cp -Rv {}/linux/. ./linux/ \;

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

RETVAL=0
make $MAKEFLAGS ARCH=arm CROSS_COMPILE=${TOOLCHAIN}- menuconfig
make $MAKEFLAGS ARCH=arm CROSS_COMPILE=${TOOLCHAIN}- bzImage dtbs || RETVAL=-1  
cp arch/arm/boot/zImage $KERNEL_TARGET_FILE_NAME

if [ $RETVAL -eq -1 ] ; then
    RED=`tput setaf 1`
    RESET=`tput sgr 0`
    cd .. && echo -e "${RED}Compile Kernel Failed!!!${RESET}"
    exit -1
fi

if [ -e arch/arm/boot/dts/versatile-pb.dtb ] ; then
    cp arch/arm/boot/dts/versatile-pb.dtb ../

    read -p "Execute QEMU? [Y/n] " prompt

    if [[ $prompt =~ [yY](es)* ]] ; then
        DISK_IMAGE=2018-11-13-raspbian-stretch.img

        if [ ! -e ../$DISK_IMAGE ] ; then
            wget https://downloads.raspberrypi.org/raspbian/images/raspbian-2018-11-15/2018-11-13-raspbian-stretch.zip
            unzip 2018-11-13-raspbian-stretch.zip -d ../
            rm 2018-11-13-raspbian-stretch.zip
        fi

        # Copy test file to Raspbian disk image
        LOOPDEV=$(sudo losetup -P -f --show ../$DISK_IMAGE)

        cd ..
        mkdir one two
        sudo mount -o loop ${LOOPDEV}p1 ./one
        sudo mount -o loop ${LOOPDEV}p2 ./two

        rm -rf ./two/home/pi/test/*
        find ../chapter -type d -name $foldernumber-* -exec cp -Rv {}/test/. ./two/home/pi/test/ \;

        sudo umount ./one

        busy=true
        while $busy
        do
            sudo umount ./two 2> /dev/null
            if [ $? -eq 0 ] ; then
                busy=false   # mount successful
            else
                echo -n '.'  # mount failed
                sleep 2      # sleep 2 seconds
            fi
        done

        sudo losetup -d ${LOOPDEV}
        rm -r one two
        cd linux

        # Execute QEMU
        sudo qemu-system-arm \
            -M versatilepb \
            -cpu arm1176 \
            -m 256 \
            -hda ../$DISK_IMAGE \
            -net nic \
            -net user,hostfwd=tcp::5022-:22 \
            -dtb ../versatile-pb.dtb \
            -kernel $KERNEL_TARGET_FILE_NAME \
            -append 'root=/dev/sda2 panic=1' \
            -no-reboot
    fi
fi

cd ..
