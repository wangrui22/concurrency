#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "driver_types.h"
#include <stdio.h>
#include <fstream>

#define BLOCK_SIZE 16

typedef struct
{
    int width;
    int height;
    float* elements;
} Matrix;

__global__ void mat_mul_kernel(const Matrix a, const Matrix b, Matrix c) {
    int row = blockIdx.y*blockDim.y + threadIdx.y;
    int col = blockIdx.x*blockDim.x + threadIdx.x;

    float res = 0.0;
    for (int i = 0; i < a.width; ++i) {
        res += a.elements[row*a.height + i] * b.elements[i*b.width + col];
    }
    c.elements[row*c.width + col] = res;
}

int mat_mul(const Matrix a, const Matrix b, Matrix c) 
{
    //1 copy host memory to device(cudaMalloc + cudaMemcpy)
    cudaError_t cuda_error = cudaSuccess;
    Matrix d_a;
    d_a.width = a.width;
    d_a.height = a.height;
    cuda_error = cudaMalloc(&(d_a.elements), d_a.width*d_a.height*sizeof(float));
    if (cuda_error != cudaSuccess) {
        printf("cuda malloc failed." );
        return -1;
    }
    cuda_error = cudaMemcpy(d_a.elements, a.elements, d_a.width*d_a.height * sizeof(float), cudaMemcpyHostToDevice);
    if (cuda_error != cudaSuccess) {
        printf("cuda memcpy failed.");
        return -1;
    }

    Matrix d_b;
    d_b.width = b.width;
    d_b.height = b.height;
    cuda_error = cudaMalloc(&(d_b.elements), d_b.width*d_b.height * sizeof(float));
    if (cuda_error != cudaSuccess) {
        printf("cuda malloc failed.");
        return -1;
    }
    cuda_error = cudaMemcpy(d_b.elements, b.elements, d_b.width*d_b.height * sizeof(float), cudaMemcpyHostToDevice);
    if (cuda_error != cudaSuccess) {
        printf("cuda memcpy failed.");
        return -1;
    }

    Matrix d_c;
    d_c.width = c.width;
    d_c.height = c.height;
    cuda_error = cudaMalloc(&(d_c.elements), d_c.width*d_c.height * sizeof(float));
    if (cuda_error != cudaSuccess) {
        printf("cuda malloc failed.");
        return -1;
    }

    //2 invoke kernel to calculate (block thread)
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 dimGrid(b.width / dimBlock.x, a.height / dimBlock.y);
    //dim3 dimGrid = (4, 4);
    mat_mul_kernel<<<dimGrid,dimBlock>>>(d_a, d_b, d_c);

    //3 download to host
    cudaMemcpy(c.elements, d_c.elements, c.width*c.height*sizeof(float) , cudaMemcpyDeviceToHost);
    if (cuda_error != cudaSuccess) {
        printf("cuda memcpy failed.");
        return -1;
    }

    //4 release the device memeory
    cudaFree(d_a.elements);
    cudaFree(d_b.elements);
    cudaFree(d_c.elements);

    return 0;
}

int save_matrix(Matrix m, const char* file_name) {
    std::ofstream out(file_name, std::ios::out);
    if (!out.is_open()) {
        return -1;
    }

    for (int row = 0; row < m.height; ++row) {
        for (int col= 0; col < m.width; ++col) {
            out << m.elements[row*m.height + col] << " ";
        }
        out << std::endl;
    }

    out.close();
    return 0;
}

int cuda_matrix_mul(int argc , char* argv[]) 
{
    Matrix a;
    a.width = 64;
    a.height = 64;
    a.elements = new float[64*64];
    for (int i = 0; i < 64 * 64; ++i) {
        a.elements[i] = 1.0f;
    }

    Matrix b;
    b.width = 64;
    b.height = 64;
    b.elements = new float[64 * 64];
    for (int i = 0; i < 64 * 64; ++i) {
        b.elements[i] = 2.0f;
    }

    Matrix c;
    c.width = 64;
    c.height = 64;
    c.elements = new float[64 * 64];
    for (int i = 0; i < 64 * 64; ++i) {
        c.elements[i] = 0;
    }

    if (0 == mat_mul(a, b, c)) {
        printf("Success.\n");
        save_matrix(c, "D:/temp/mat.txt");
    }
    else {
        printf("Failed.\n");
    }
    
    return 0;
}