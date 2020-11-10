#!/bin/bash
#
# Build ARM kernel 4.14.y for QEMU Raspberry Pi Emulation
#
#######################################################

cd linux
git checkout -- .
git clean -fd
cd ..

# Started QEMU with now Kernel
echo "Input target folder number:"
read foldernumber

cd linux

DISK_IMAGE=2018-11-13-raspbian-stretch.img
KERNEL_VERSION=$(make kernelversion)
KERNEL_TARGET_FILE_NAME=../qemu-kernel-$KERNEL_VERSION

if [ ! -e $KERNEL_TARGET_FILE_NAME ] ; then
    cd ../
    echo -e "${RED}Kernel Image Not Exist!!!${RESET}"
    exit -1
fi

if [ ! -e ../versatile-pb.dtb ] ; then
    cd ../
    echo -e "${RED}DTB Not Exist!!!${RESET}"
    exit -1
fi

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

cd ..
