#include <linux/init.h>
#include <linux/module.h>
#include <linux/blkdev.h>
MODULE_LICENSE("Dual BSD/GPL");

#define MY_BLOCK_MAJOR	240
#define MY_BLKDEV_NAME	"my_block"

static __init int my_block_init(void)
{
	int status;
	status = register_blkdev(MY_BLOCK_MAJOR, MY_BLKDEV_NAME);
	if (status < 0) {
		 printk(KERN_ERR "unable to register mybdev block device\n");
		 return -EBUSY;
	}
	printk(KERN_INFO "Hello kernel\n");
	return 0;
}

static void __exit my_block_exit(void)
{
	printk(KERN_INFO "Goodbye\n");
	unregister_blkdev(MY_BLOCK_MAJOR, MY_BLKDEV_NAME);
}

module_init(my_block_init);
module_exit(my_block_exit);