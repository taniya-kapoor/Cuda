#include <stdio.h>


#include "gpuerrchk.h"

__global__ void plusOne(int *a,int nbelem)
{
	int tid=blockIdx.x*blockDim.x + threadIdx.x;

	if(tid < nbelem)
		a[tid]++;
}

int main(){
	int N=100000;

	int *a;
	int *a_d;
	
	a=(int*)malloc(N*sizeof(int));
	gpuErrchk( cudaMalloc(&a_d,N*sizeof(int)) );

	for(int i=0;i<N;i++){
		a[i]=i;
	}	

	cudaMemcpy(a_d,a,N*sizeof(int),cudaMemcpyHostToDevice);
	
	dim3 blocks = (N+127)/128;
	
	plusOne<<<blocks,128>>>(a_d,N);
	
	cudaMemcpy(a,a_d,N*sizeof(int),cudaMemcpyDeviceToHost);

	bool ok=true;
	for(int i=0;i<N;i++){
		if(a[i] != i+1)ok=false;
	}	
	printf("%s\n",ok?"ok":"not ok");
	
	free(a);
	cudaFree(a_d);
}
