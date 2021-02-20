#include <stdio.h>

//return global thread ID (for 2D grids and blocks) 
__device__ int globalID_2D(){
	int blockId = blockIdx.x + blockIdx.y * gridDim.x;
	return blockId * (blockDim.x * blockDim.y) + \
	 	(threadIdx.x + threadIdx.y*blockDim.x);
}

__global__ void print_ids(){
    printf("blockIdx.(x,y,z): %d %d %d\t threadIdx.(x,y,z): %d %d %d =>\t globalID: %d\n",\
                blockIdx.x,blockIdx.y,blockIdx.z, \
                threadIdx.x,threadIdx.y,threadIdx.z,globalID_2D());
    if(globalID_2D() == 0)
    	printf("==============\n");
}

int main(){
    //1D grid of 1D-blocks (1 x 16 threads )
    print_ids<<<1,16>>>();
    cudaDeviceSynchronize();

	//1D grid of 1D-blocks (4 x 4 threads)
    print_ids<<<4,4>>>();
    cudaDeviceSynchronize();

	//2D grid of 2D-blocks ((2x2) x (2x2) threads) 
    dim3 blocks(2,2,1);
    dim3 threads(2,2,1);
    print_ids<<<blocks,threads>>>();
    cudaDeviceSynchronize();
}
