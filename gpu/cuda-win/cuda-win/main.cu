#include <stdio.h>
extern int cuda_add(int argc, char*argv[]);
int main(int argc, char* argv[]) 
{
    cuda_add(argc,  argv);
}