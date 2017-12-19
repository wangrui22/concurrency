#include <stdlib.h>  
#include <stdio.h>  
#include <cuda_runtime.h>  
#include <cuda.h>  
#include <assert.h>    


__global__ void cu_arrayDelete(int* arrayIO)
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    arrayIO[idx] = arrayIO[idx] - 16;
}
void checkCUDAError(const char *msg)
{
    cudaError_t err = cudaGetLastError();
    if (cudaSuccess != err) {
        printf("Cuda error: %s: %s./n", msg, cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }
}
int page_locked_mem(int argc, char *argv[])
{
    int* h_pData = NULL;
    int* d_pData = NULL;
    cudaDeviceProp deviceProp;
    cudaGetDeviceProperties(&deviceProp, 0);
    if (!deviceProp.canMapHostMemory) {
        printf("Device %d cannot map host memory!/n");
    }
    cudaSetDeviceFlags(cudaDeviceMapHost);
    checkCUDAError("cudaSetDeviceFlags");

    cudaHostAlloc(&h_pData, 512, cudaHostAllocMapped);
    cudaHostGetDevicePointer((void **)&d_pData, (void *)h_pData, 0);
    for (int i = 0; i<128; i++)
    {
        h_pData[i] = 255;
    }
    cu_arrayDelete << <4, 32 >> >(d_pData);
    cudaThreadSynchronize();
    for (int i = 0; i<128; i++)
        printf("%d/n", h_pData[0]);
    return 0;
}