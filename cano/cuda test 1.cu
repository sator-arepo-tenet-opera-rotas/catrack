// Consider a sparse matrix of size 10k x 10k with 9 in 10 zero values and the rest being 32 bit floating point numbers.  Make reasonable assumptions about the structure of the sparsity and probability distribution of the non-zero values. Design and code a system using CUDA that optimizes the total expected input memory used to store this matrix to make it as low as possible.  State and explain your assumptions.  If you choose a lossy solution, make sure you give the expected loss of your solution.

#include <iostream>
#include <cuda_runtime.h>
#include <random>

#define CHECK_CUDA(call)                                                    \
    {                                                                       \
        cudaError_t err = call;                                             \
        if (err != cudaSuccess) {                                           \
            std::cerr << "CUDA error: " << cudaGetErrorString(err)          \
                      << " at " << __FILE__ << ":" << __LINE__ << std::endl;\
            exit(EXIT_FAILURE);                                             \
        }                                                                   \
    }

#define TILE_SIZE 16  // You can tune this

void printGpuMemoryUsage(const char* tag = "")
{
    size_t free_bytes, total_bytes;
    cudaMemGetInfo(&free_bytes, &total_bytes);
    double free_mb = static_cast<double>(free_bytes) / (1024.0 * 1024.0);
    double total_mb = static_cast<double>(total_bytes) / (1024.0 * 1024.0);
    double used_mb = total_mb - free_mb;
    std::cout << "[GPU MEM] " << tag
        << " Used: " << used_mb << " MB, Free: "
        << free_mb << " MB, Total: " << total_mb << " MB\n";
}


// Kernel for basic matrix multiplication (C = A * B)
__global__ void matMulKernel(const float* A, const float* B, float* C,
    int N, int M, int K)
{
    // N: rows of A and C
    // M: cols of A, rows of B
    // K: cols of B and C
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < N && col < K) {
        float sum = 0.0f;
        for (int i = 0; i < M; ++i) {
            sum += A[row * M + i] * B[i * K + col];
        }
        C[row * K + col] = sum;
    }
}

int main()
{
    // Sparse matrix setup
    int N = 10000, M = 10000, K = 10000;
    float sparsity = 0.1f; // 10% non-zero
    size_t numElementsA = static_cast<size_t>(N) * M;
    size_t numElementsB = static_cast<size_t>(M) * K;
    size_t numElementsC = static_cast<size_t>(N) * K;

    // Estimate sparse counts (10% nonzero)
    size_t nnzA = static_cast<size_t>(numElementsA * sparsity);
    size_t nnzB = static_cast<size_t>(numElementsB * sparsity);

    std::cout << "Estimated non-zero elements: " << nnzA << " (A), " << nnzB << " (B)\n";

    // Allocate host memory as pinned (page-locked) for faster transfers
    float* h_A_vals, * h_B_vals, * h_C;
    int* h_A_rowIdx, * h_A_colIdx, * h_B_rowIdx, * h_B_colIdx;

    CHECK_CUDA(cudaHostAlloc((void**)&h_A_vals, nnzA * sizeof(float), cudaHostAllocDefault));
    CHECK_CUDA(cudaHostAlloc((void**)&h_B_vals, nnzB * sizeof(float), cudaHostAllocDefault));
    CHECK_CUDA(cudaHostAlloc((void**)&h_C, numElementsC * sizeof(float), cudaHostAllocDefault));
    CHECK_CUDA(cudaHostAlloc((void**)&h_A_rowIdx, nnzA * sizeof(int), cudaHostAllocDefault));
    CHECK_CUDA(cudaHostAlloc((void**)&h_A_colIdx, nnzA * sizeof(int), cudaHostAllocDefault));
    CHECK_CUDA(cudaHostAlloc((void**)&h_B_rowIdx, nnzB * sizeof(int), cudaHostAllocDefault));
    CHECK_CUDA(cudaHostAlloc((void**)&h_B_colIdx, nnzB * sizeof(int), cudaHostAllocDefault));

    // Print host allocation info
    printGpuMemoryUsage("Before allocation");

    // Allocate device memory only for sparse data
    float* d_A_vals, * d_B_vals, * d_C;
    int* d_A_rowIdx, * d_A_colIdx, * d_B_rowIdx, * d_B_colIdx;
    CHECK_CUDA(cudaMalloc((void**)&d_A_vals, nnzA * sizeof(float)));
    CHECK_CUDA(cudaMalloc((void**)&d_B_vals, nnzB * sizeof(float)));
    CHECK_CUDA(cudaMalloc((void**)&d_C, numElementsC * sizeof(float))); // full result
    CHECK_CUDA(cudaMalloc((void**)&d_A_rowIdx, nnzA * sizeof(int)));
    CHECK_CUDA(cudaMalloc((void**)&d_A_colIdx, nnzA * sizeof(int)));
    CHECK_CUDA(cudaMalloc((void**)&d_B_rowIdx, nnzB * sizeof(int)));
    CHECK_CUDA(cudaMalloc((void**)&d_B_colIdx, nnzB * sizeof(int)));

    printGpuMemoryUsage("After allocation");

    // --- Initialize sparse values efficiently ---
    std::mt19937 rng(123);
    std::normal_distribution<float> norm(0.0f, 1.0f);
    std::uniform_int_distribution<int> rowDist(0, N - 1);
    std::uniform_int_distribution<int> colDist(0, M - 1);

    for (size_t i = 0; i < nnzA; ++i) {
        h_A_vals[i] = norm(rng);
        h_A_rowIdx[i] = rowDist(rng);
        h_A_colIdx[i] = colDist(rng);
    }

    for (size_t i = 0; i < nnzB; ++i) {
        h_B_vals[i] = norm(rng);
        h_B_rowIdx[i] = rowDist(rng);
        h_B_colIdx[i] = colDist(rng);
    }

    std::fill(h_C, h_C + numElementsC, 0.0f);

    // Async copy sparse data to GPU
    cudaStream_t stream;
    CHECK_CUDA(cudaStreamCreate(&stream));
    CHECK_CUDA(cudaMemcpyAsync(d_A_vals, h_A_vals, nnzA * sizeof(float), cudaMemcpyHostToDevice, stream));
    CHECK_CUDA(cudaMemcpyAsync(d_B_vals, h_B_vals, nnzB * sizeof(float), cudaMemcpyHostToDevice, stream));
    CHECK_CUDA(cudaMemcpyAsync(d_A_rowIdx, h_A_rowIdx, nnzA * sizeof(int), cudaMemcpyHostToDevice, stream));
    CHECK_CUDA(cudaMemcpyAsync(d_A_colIdx, h_A_colIdx, nnzA * sizeof(int), cudaMemcpyHostToDevice, stream));
    CHECK_CUDA(cudaMemcpyAsync(d_B_rowIdx, h_B_rowIdx, nnzB * sizeof(int), cudaMemcpyHostToDevice, stream));
    CHECK_CUDA(cudaMemcpyAsync(d_B_colIdx, h_B_colIdx, nnzB * sizeof(int), cudaMemcpyHostToDevice, stream));
    CHECK_CUDA(cudaStreamSynchronize(stream));

    printGpuMemoryUsage("After data transfer");

    // --- Normally you'd call a sparse multiplication kernel here ---
    std::cout << "Sparse data initialized and transferred successfully.\n";

    // Cleanup
    CHECK_CUDA(cudaFree(d_A_vals));
    CHECK_CUDA(cudaFree(d_B_vals));
    CHECK_CUDA(cudaFree(d_C));
    CHECK_CUDA(cudaFree(d_A_rowIdx));
    CHECK_CUDA(cudaFree(d_A_colIdx));
    CHECK_CUDA(cudaFree(d_B_rowIdx));
    CHECK_CUDA(cudaFree(d_B_colIdx));
    CHECK_CUDA(cudaStreamDestroy(stream));

    printGpuMemoryUsage("After free");

    CHECK_CUDA(cudaFreeHost(h_A_vals));
    CHECK_CUDA(cudaFreeHost(h_B_vals));
    CHECK_CUDA(cudaFreeHost(h_C));
    CHECK_CUDA(cudaFreeHost(h_A_rowIdx));
    CHECK_CUDA(cudaFreeHost(h_A_colIdx));
    CHECK_CUDA(cudaFreeHost(h_B_rowIdx));
    CHECK_CUDA(cudaFreeHost(h_B_colIdx));

    return 0;
}