#include <iostream>
#include <cuda_runtime.h>

int main() {
    float *d_A;
    size_t size = 50000 * sizeof(float);

    cudaError_t err = cudaMalloc((void**)&d_A, size);
    if (err != cudaSuccess) {
        std::cerr << "Error allocating memory on GPU: " << err << "---" << cudaGetErrorString(err) << std::endl;
        return -1;
    }

    std::cout << "Memory allocated successfully!" << std::endl;
    cudaFree(d_A);
    return 0;
}
