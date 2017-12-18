#include <stdio.h>
extern int cuda_add(int argc, char*argv[]);
int cuda_matrix_mul(int argc, char* argv[]);
int cuda_matrix_mul_s(int argc, char* argv[]);

int main(int argc, char* argv[]) 
{
    cuda_matrix_mul_s(argc,  argv);
}