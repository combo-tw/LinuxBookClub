#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
#include <string.h>

int get_cmd(char *cmds, int *cmd_num, char *ret)
{
	// Do something
	return 0;
}

int main(void)
{
	struct sigaction sigchld_action;

	sigchld_action.sa_handler = SIG_DFL;
	sigchld_action.sa_flags = SA_NOCLDWAIT;

	char input[4096];
	char cmd;
	int cmd_num;

	do {
		// Get line
		printf("msh> ");
		gets(input);
		printf("Input is %s\n", input);	// The line are delete
		get_cmd(input, &cmd_num, &cmd);
		execvp(input, input);
	} while(strstr(input, "exit") == NULL);

	return 0;
}
