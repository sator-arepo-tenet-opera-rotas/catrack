// Design and code a 10k x 10k matrix multiplication using CUDA.  The input matrices are sparse with 9 in 10 being zero and the rest being 32 bit floating point numbers.  Make reasonable assumptions about the structure of the sparsity. Optimize to make it multiply as fast as possible.  State and explain your assumptions.

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

#define TILE_SIZE 32  // You can tune this

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

// Basic dense kernel for demo (C = A * B)
__global__ void matMulKernel(const float* A, const float* B, float* C,
    int N, int M, int K)
{
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
    // Matrix setup (smaller for timing test)
    int N = 1024, M = 1024, K = 1024; // 1024^2 = 1M elements
    size_t sizeA = N * M * sizeof(float);
    size_t sizeB = M * K * sizeof(float);
    size_t sizeC = N * K * sizeof(float);

    std::cout << "Matrix multiplication " << N << "x" << M << " * " << M << "x" << K << std::endl;

    // Host allocation
    float* h_A; CHECK_CUDA(cudaHostAlloc((void**)&h_A, sizeA, cudaHostAllocDefault));
    float* h_B; CHECK_CUDA(cudaHostAlloc((void**)&h_B, sizeB, cudaHostAllocDefault));
    float* h_C; CHECK_CUDA(cudaHostAlloc((void**)&h_C, sizeC, cudaHostAllocDefault));

    // Random initialization
    std::mt19937 rng(42);
    std::normal_distribution<float> norm(0.0f, 1.0f);
    for (int i = 0; i < N * M; ++i) h_A[i] = norm(rng);
    for (int i = 0; i < M * K; ++i) h_B[i] = norm(rng);

    // Device allocation
    printGpuMemoryUsage("Before allocation");
    float* d_A, * d_B, * d_C;
    CHECK_CUDA(cudaMalloc((void**)&d_A, sizeA));
    CHECK_CUDA(cudaMalloc((void**)&d_B, sizeB));
    CHECK_CUDA(cudaMalloc((void**)&d_C, sizeC));
    printGpuMemoryUsage("After allocation");

    // CUDA stream and events for timing
    cudaStream_t stream;
    CHECK_CUDA(cudaStreamCreate(&stream));

    cudaEvent_t start, stop;
    CHECK_CUDA(cudaEventCreate(&start));
    CHECK_CUDA(cudaEventCreate(&stop));

    float ms_total = 0.0f, ms_copyH2D = 0.0f, ms_kernel = 0.0f, ms_copyD2H = 0.0f;

    // --- Host to Device copy timing ---
    CHECK_CUDA(cudaEventRecord(start, stream));
    CHECK_CUDA(cudaMemcpyAsync(d_A, h_A, sizeA, cudaMemcpyHostToDevice, stream));
    CHECK_CUDA(cudaMemcpyAsync(d_B, h_B, sizeB, cudaMemcpyHostToDevice, stream));
    CHECK_CUDA(cudaEventRecord(stop, stream));
    CHECK_CUDA(cudaEventSynchronize(stop));
    CHECK_CUDA(cudaEventElapsedTime(&ms_copyH2D, start, stop));

    // --- Kernel timing ---
    dim3 block(TILE_SIZE, TILE_SIZE);
    dim3 grid((K + TILE_SIZE - 1) / TILE_SIZE, (N + TILE_SIZE - 1) / TILE_SIZE);

    CHECK_CUDA(cudaEventRecord(start, stream));
    matMulKernel << <grid, block, 0, stream >> > (d_A, d_B, d_C, N, M, K);
    CHECK_CUDA(cudaEventRecord(stop, stream));
    CHECK_CUDA(cudaEventSynchronize(stop));
    CHECK_CUDA(cudaEventElapsedTime(&ms_kernel, start, stop));

    // --- Device to Host copy timing ---
    CHECK_CUDA(cudaEventRecord(start, stream));
    CHECK_CUDA(cudaMemcpyAsync(h_C, d_C, sizeC, cudaMemcpyDeviceToHost, stream));
    CHECK_CUDA(cudaEventRecord(stop, stream));
    CHECK_CUDA(cudaEventSynchronize(stop));
    CHECK_CUDA(cudaEventElapsedTime(&ms_copyD2H, start, stop));

    // Total runtime
    ms_total = ms_copyH2D + ms_kernel + ms_copyD2H;

    printGpuMemoryUsage("After computation");

    // Print results
    std::cout << "\n=== Runtime Profiling ===\n";
    std::cout << "Host → Device transfer: " << ms_copyH2D << " ms\n";
    std::cout << "Kernel execution time:  " << ms_kernel << " ms\n";
    std::cout << "Device → Host transfer: " << ms_copyD2H << " ms\n";
    std::cout << "--------------------------------\n";
    std::cout << "Total GPU time:          " << ms_total << " ms\n";

    // Cleanup
    CHECK_CUDA(cudaFree(d_A));
    CHECK_CUDA(cudaFree(d_B));
    CHECK_CUDA(cudaFree(d_C));
    printGpuMemoryUsage("After free");

    CHECK_CUDA(cudaFreeHost(h_A));
    CHECK_CUDA(cudaFreeHost(h_B));
    CHECK_CUDA(cudaFreeHost(h_C));

    CHECK_CUDA(cudaEventDestroy(start));
    CHECK_CUDA(cudaEventDestroy(stop));
    CHECK_CUDA(cudaStreamDestroy(stream));

    return 0;
}
