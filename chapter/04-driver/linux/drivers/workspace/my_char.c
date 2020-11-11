#include <linux/init.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <asm/ioctl.h>
#include <linux/uaccess.h>
#include <linux/kernel.h>

MODULE_LICENSE("Dual BSD/GPL");

#define MY_CDEB_MAJOR	42
#define MY_CDEV_NAME	"my_char"
#define MY_MAX_MINORS  5

struct my_device_data {
	struct cdev cdev;
	char index;
};

struct my_device_data devs[MY_MAX_MINORS];

char arr[5];

static int my_open(struct inode *inode, struct file *file)
{ 
	struct my_device_data *my_data = container_of(inode->i_cdev, struct my_device_data, cdev);
	
	/* validate access to device */
    file->private_data = &my_data->index;
	return 0;
}

static int my_read(struct file *file, char __user *user_buffer,
					size_t size, loff_t *offset)
{
	copy_to_user(user_buffer, (arr + *(char*)(file->private_data)), 1);
	return 0;
}

static int my_write(struct file *file, const char __user *user_buffer,
					size_t size, loff_t * offset)
{
	copy_from_user((arr + *(char*)(file->private_data)), user_buffer, 1);
	return 0;
}

static int my_release(struct inode *inode , struct file *filp)
{
	return 0;
}

static long my_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
	return 0;
}

const struct file_operations my_fops = {
	.owner = THIS_MODULE,
	.open = my_open,
	.read = my_read,
	.write = my_write,
	.release = my_release,
	.unlocked_ioctl = my_ioctl
};

static __init int my_char_init(void)
{
	int i, err;
	err = register_chrdev_region(MKDEV(MY_CDEB_MAJOR, 0), MY_MAX_MINORS,
								MY_CDEV_NAME);
	if (err != 0) {
		/* report error */
		return err;
	}
	for(i = 0; i < MY_MAX_MINORS; i++) {
		/* initialize devs[i] fields */
		cdev_init(&devs[i].cdev, &my_fops);
		cdev_add(&devs[i].cdev, MKDEV(MY_CDEB_MAJOR, i), 1);
		devs[i].index = i;
	}
	printk(KERN_INFO "[MyChar][My_Char_Init] Hello kernel\n");
	return 0;
}

static void __exit my_char_exit(void)
{
	int i;
	printk(KERN_INFO "[MyChar][My_Char_Exit] Goodbye\n");

	for(i = 0; i < MY_MAX_MINORS; i++) {
		/* release devs[i] fields */
		cdev_del(&devs[i].cdev);
	}
	unregister_chrdev_region(MKDEV(MY_CDEB_MAJOR, 0), MY_MAX_MINORS);
}

module_init(my_char_init);
module_exit(my_char_exit);
