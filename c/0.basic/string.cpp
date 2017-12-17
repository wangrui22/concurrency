#include <stdio.h>

int main(int argc , char* argv[])
{
	char str[] = "123456789";
	printf("char %s size is %u\n", str, (unsigned int)sizeof(str));
	return 0;
}