#include <stdio.h>

/*
 * __global__ void function == "a CUDA kernel"
 * Called from the host (CPU) and executed on the device
 */
__global__ void
helloCuda()
{
    /*
     * printf is supported since "compute capability" 2.0
     * This printf is executed by all threads in the current context (specified by kernel configuration).
     * Note that the function is called from the host, but the output takes place on the host system.
     * There is an output buffer (default size 1MB) that will be flushed at the next host-device synchronization
     */
    printf("hello from thread %d\n", threadIdx.x);
    /*only the first thread in each block executes the second printf*/
    if (threadIdx.x == 0)
        printf("==========\n");
}

int
main()
{
    /* launch kernel with 1 block of 1 thread*/
    helloCuda << < 1, 1 >> > ();
    cudaDeviceSynchronize();

    /* launch kernel with 1 block of 64 threads*/
    helloCuda << < 1, 64 >> > ();

    /*
     * without cudaDeviceSynchronize there will be no output!
     * The program ends before flushing the printf output buffer from the last (asynchronous) kernel call
     */
    cudaDeviceSynchronize();
}
