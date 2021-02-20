#include <stdio.h>

#include <cuda_runtime.h>
#include "./gpuerrchk.h"

__global__ void hello(char* arr,int *offset){
    /*threads 0,1,2,3,4 in each block do this ....*/
    if(threadIdx.x<5){
        /*... interpret content of "arr" as integer,
        perform addition with offset and write result back to "arr"*/
        arr[threadIdx.x]+=offset[threadIdx.x];
    }
}

int main(){
    int N=5;

    char a[N]="Hello";
    int b[N]={-5,16,-8,-11,-78};

    char *a_d;
    int *b_d;

    /*allocate on device*/
    cudaMalloc(&a_d,N*sizeof(char));
    cudaMalloc(&b_d,N*sizeof(int));

    /*print "Hello" on host*/
    printf("%s ",a);

    /*copy "Hello" array "a" and integers "b" to device
    gpuErrchk is an error checking macro defined in "./gpuerrchk"*/
    gpuErrchk( cudaMemcpy(a_d,a,N*sizeof(char),cudaMemcpyHostToDevice) );
    gpuErrchk( cudaMemcpy(b_d,b,N*sizeof(int),cudaMemcpyHostToDevice) );

    /*launch kernel with 1 block and 32 threads
    (transforms a_d using b_d)
    */
    hello<<<1,32>>>(a_d,b_d);
    //Error checking ....
    gpuErrchk( cudaPeekAtLastError() );
    gpuErrchk( cudaDeviceSynchronize() );

    //copy transformed array 'a' back to host
    gpuErrchk( cudaMemcpy(a,a_d,N,cudaMemcpyDeviceToHost) );

    //print "Cuda!" on host
    printf("%s\n",a);

    //free on device
    cudaFree(a_d);
    cudaFree(b_d);
}
