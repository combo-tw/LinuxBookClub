#include <linux/kernel.h>
#include <sys/fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

int main(void)
{
	unsigned char test_data[] = {
		0xAA, 0x55, 0xA5, 0x5A, 0xff
	};
	unsigned char ans[] = {
		0x00, 0x00, 0x00, 0x00, 0x00
	};
	char fd[5];
	int i;
	unsigned char block = 0x60;

	system("sudo mknod /dev/mycdev_1 c 42 0");
	fd[0] = open("/dev/mycdev_1", O_RDWR);
	system("sudo mknod /dev/mycdev_2 c 42 1");
	fd[1] = open("/dev/mycdev_2", O_RDWR);
	system("sudo mknod /dev/mycdev_3 c 42 2");
	fd[2] = open("/dev/mycdev_3", O_RDWR);
	system("sudo mknod /dev/mycdev_4 c 42 3");
	fd[3] = open("/dev/mycdev_4", O_RDWR);
	system("sudo mknod /dev/mycdev_5 c 42 4");
	fd[4] = open("/dev/mycdev_5", O_RDWR);
	
	for (i = 0; i < 5; i++) {
		if (*(fd + i) < 0) {
			/* handle error */
			printf("FD[%hhd] not open\n", i);
		}
	}

	for (i = 0; i < 5; i++) {
		write(*(fd + i), test_data + i, 0);
	}

	for (i = 0; i < 5; i++) {
		printf("Write[%hhd]: %hhu\t", (4 - i), *(test_data + (4 - i)));
		printf("Ans_Ori[%hhd]: %hhu,\t", (4 - i), *(ans + (4 - i)));
		read(*(fd + (4 - i)), ans + (4 - i), 0);
		printf("Ans_New[%hhd]: %hhu\n", (4 - i), *(ans + (4 - i)));
	}

	for (i = 0; i < 5; i++) {
		assert(ans[i] == test_data[i]);
	}

	for (i = 1; i < 5; i++) {
		write(*(fd + 0), &block, i);
		read(*(fd + 0), ans + i, i);
		assert(ans[i] != test_data[i]);
	}
	
	for (i = 0; i < 5; i++) {
		close(*(fd + i));
	}

	return 0;
}
