#include <linux/kernel.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <stdio.h>
#include <assert.h>

#define __NR_factorial 398

int main(void)
{
    long long f_tbl[] = {
        1, 1, 2, 6, 24, 120,
        720, 5040, 40320, 362880, 3628800,
        39916800, 479001600, 6227020800, 87178291200
    };
    long long ans;
    int len = sizeof(f_tbl) / sizeof(f_tbl[0]);

    for (int i = 0; i < len; i++) {
        syscall(__NR_factorial, i, &ans);
        assert(ans == f_tbl[i]);
    }

    syscall(__NR_factorial, 20, &ans);
    assert(ans == 2432902008176640000);

    return 0;
}
