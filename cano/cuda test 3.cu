// Create a function to approximately sort the rows of a matrix in CUDA. The matrix consists of an array of rows, where each row is an array of (key,value) pairs. Approximate sort means sort by value within 25% so for example: (4828,1.24), (3283,1.01), (13223,1.18), (422333,1.32), (3983,1.57), (3283,1.68), (3848,1.96) Is approximate-25% value sorted ascending.

#include <cuda_runtime.h>
#include <iostream>
#include <vector>
#include <random>


struct KeyValue {
    int key;
    float value;
};

// Swap helper
__device__ void swap(KeyValue& a, KeyValue& b) {
    KeyValue tmp = a;
    a = b;
    b = tmp;
}

// Kernel: fully sort each row ascending by value
__global__ void sortRows(KeyValue* matrix, int rows, int cols) {
    int row = blockIdx.x;
    if (row >= rows) return;

    extern __shared__ KeyValue sharedRow[];

    // Load row into shared memory
    for (int i = threadIdx.x; i < cols; i += blockDim.x)
        sharedRow[i] = matrix[row * cols + i];
    __syncthreads();

    // Simple bubble sort for demo
    for (int i = 0; i < cols - 1; ++i) {
        for (int j = i + 1; j < cols; ++j) {
            if (sharedRow[i].value > sharedRow[j].value)
                swap(sharedRow[i], sharedRow[j]);
        }
    }

    __syncthreads();

    // Write back to global memory
    for (int i = threadIdx.x; i < cols; i += blockDim.x)
        matrix[row * cols + i] = sharedRow[i];
}

// ---------------- Host Main ----------------
int main() {
    int rows = 4;
    int cols = 7;

    std::vector<KeyValue> h_matrix(rows * cols);

    // Random data
    std::mt19937 rng(42);
    std::uniform_int_distribution<int> keyDist(1000, 5000);
    std::uniform_real_distribution<float> valueDist(1.0f, 2.0f);

    for (int i = 0; i < rows * cols; ++i) {
        h_matrix[i].key = keyDist(rng);
        h_matrix[i].value = valueDist(rng);
    }

    // Print before
    std::cout << "=== BEFORE SORT ===\n";
    for (int r = 0; r < rows; ++r) {
        std::cout << "Row " << r << ": ";
        for (int c = 0; c < cols; ++c)
            std::cout << "(" << h_matrix[r * cols + c].key << ", " << h_matrix[r * cols + c].value << ") ";
        std::cout << "\n";
    }

    // Device memory
    KeyValue* d_matrix;
    size_t matrixSize = rows * cols * sizeof(KeyValue);
    cudaMalloc(&d_matrix, matrixSize);
    cudaMemcpy(d_matrix, h_matrix.data(), matrixSize, cudaMemcpyHostToDevice);

    // Launch: one block per row
    int threadsPerBlock = 128;
    sortRows << <rows, threadsPerBlock, cols * sizeof(KeyValue) >> > (d_matrix, rows, cols);
    cudaDeviceSynchronize();

    // Copy back
    cudaMemcpy(h_matrix.data(), d_matrix, matrixSize, cudaMemcpyDeviceToHost);
    cudaFree(d_matrix);

    // Print after
    std::cout << "\n=== AFTER SORT ===\n";
    for (int r = 0; r < rows; ++r) {
        std::cout << "Row " << r << ": ";
        for (int c = 0; c < cols; ++c)
            std::cout << "(" << h_matrix[r * cols + c].key << ", " << h_matrix[r * cols + c].value << ") ";
        std::cout << "\n";
    }

    return 0;
}
