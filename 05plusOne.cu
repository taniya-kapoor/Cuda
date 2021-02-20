#include <stdio.h>
//#include <cuda_runtime.h>

__global__ void plusOne(int *a,int nbelem)
{
	if(threadIdx.x < nbelem)
		a[threadIdx.x]++;
}

int main(){
	int N=100;

	int *a;
	int *a_d;
	
	a=(int*)malloc(N*sizeof(int));
	
	cudaMalloc(&a_d,N*sizeof(int));

	for(int i=0;i<N;i++){
		a[i]=i;
	}	

	cudaMemcpy(a_d,a,N*sizeof(int),cudaMemcpyHostToDevice);
	
	plusOne<<<1,128>>>(a_d,N);
	
	cudaMemcpy(a,a_d,N*sizeof(int),cudaMemcpyDeviceToHost);

	bool ok=true;
	for(int i=0;i<N;i++){
		if(a[i] != i+1)ok=false;
	}	
	printf("%s\n",ok?"ok":"not ok");
	
	free(a);
	cudaFree(a_d);
}
