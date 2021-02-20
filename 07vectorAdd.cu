#include <stdio.h>
#include <cuda_runtime.h>
#include "./gpuerrchk.h"

#define BLOCKSIZE 128

template<typename T>
__global__ void add(T* C,const T* A,const T* B,const int N){
    int tid=blockIdx.x*blockDim.x+threadIdx.x;

    if(tid<N){
        C[tid]=A[tid]+B[tid];
    }
}

int main(){
    int N=1<<20;

    int *A,*B,*C;
    int *A_d,*B_d,*C_d;

    A=(int*)malloc(N*sizeof(int));
    B=(int*)malloc(N*sizeof(int));
    C=(int*)malloc(N*sizeof(int));
    for(int i=0;i<N;i++){
        A[i]=i-N/2;
        B[i]=N/2-i;
        C[i]=i;
    }

    cudaMalloc(&A_d,N*sizeof(int));
    cudaMalloc(&B_d,N*sizeof(int));
    cudaMalloc(&C_d,N*sizeof(int));

    cudaMemcpy(A_d,A,N*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(B_d,B,N*sizeof(int),cudaMemcpyHostToDevice);

    dim3 nbblocks((N+BLOCKSIZE-1)/BLOCKSIZE);

    add<<<nbblocks,BLOCKSIZE>>>(C_d,A_d,B_d,N);

    cudaMemcpy(C,C_d,N*sizeof(int),cudaMemcpyDeviceToHost);

    bool ok=true;
    for(int i=0;i<N;i++)
        if(C[i]!=0)ok=false;

    printf("%s\n",ok?"OK!":"not OK!");

    free(A);free(B);free(C);
    cudaFree(A_d);
    cudaFree(B_d);
    cudaFree(C_d);
}
