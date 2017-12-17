CC = nvcc

# CUDA_PATH = /usr/local/cuda-8.0
# CUDA_INCLUDE = $(CUDA_PATH)/include
# CUDA_LIB = $(CUDA_PATH)/lib64

TARGET = a
OBJS = a.o b.o

$(TARGET):$(OBJS)
	$(CC) --gpu-architecture=sm_50 a.o b.o -o $(TARGET) 

a.o : a.cu
	$(CC) --gpu-architecture=sm_50 --device-c a.cu

b.o : b.cu b.h
	$(CC) --gpu-architecture=sm_50 --device-c b.cu

.PHONY: clean
clean :
	rm *.o $(TARGET)
