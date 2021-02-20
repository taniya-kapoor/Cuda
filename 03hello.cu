#include <stdio.h>
#define N 5

__global__ void hello(char* arr,int *offset){
    int tid=blockIdx.x*blockDim.x+threadIdx.x;

    arr[tid]+=offset[tid];
//    arr[blockIdx.x]+=offset[blockIdx.x];
}

int main(){
    char *A;
    int *B;

    cudaMallocManaged(&A,N*sizeof(char));
    cudaMallocManaged(&B,N*sizeof(int));

    A[0]='H'; A[1]='e'; A[2]='l'; A[3]='l'; A[4]='o';
    B[0]=-5;  B[1]=16;  B[2]=-8;  B[3]=-11; B[4]=-78;

    printf("%s ",A);
    hello<<<2,3>>>(A,B);
    cudaDeviceSynchronize();

    printf("%s\n",A);

    cudaFree(A);cudaFree(B);
}
