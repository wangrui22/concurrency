#include <stdio.h>
extern int cuda_add(int argc, char*argv[]);
int cuda_matrix_mul(int argc, char* argv[]);
int cuda_matrix_mul_s(int argc, char* argv[]);
int page_locked_mem(int argc, char *argv[]);
int cuda_gl(int argc, char *argv[]);
int cuda_texture(int argc, char* argv[]);
int main(int argc, char* argv[]) 
{
    cuda_texture(argc,  argv);
}