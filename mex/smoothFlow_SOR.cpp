#include "mex.h"
#include "project.h"
#include "Image.h"
#include "OpticalFlow.h"
#include <iostream>

using namespace std;

// void LoadImage(DImage& image,const mxArray* matrix)
// {
// 	if(mxIsClass(matrix,"uint8"))
// 	{
// 		image.LoadMatlabImage<unsigned char>(matrix);
// 		return;
// 	}
// 	if(mxIsClass(matrix,"int8"))
// 	{
// 		image.LoadMatlabImage<char>(matrix);
// 		return;
// 	}
// 	if(mxIsClass(matrix,"int32"))
// 	{
// 		image.LoadMatlabImage<int>(matrix);
// 		return;
// 	}
// 	if(mxIsClass(matrix,"uint32"))
// 	{
// 		image.LoadMatlabImage<unsigned int>(matrix);
// 		return;
// 	}
// 	if(mxIsClass(matrix,"int16"))
// 	{
// 		image.LoadMatlabImage<short int>(matrix);
// 		return;
// 	}
// 	if(mxIsClass(matrix,"uint16"))
// 	{
// 		image.LoadMatlabImage<unsigned short int>(matrix);
// 		return;
// 	}
// 	if(mxIsClass(matrix,"double"))
// 	{
// 		image.LoadMatlabImage<double>(matrix);
// 		return;
// 	}
// 	mexErrMsgTxt("Unknown type of the image!");
// }

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	// check for proper number of input and output arguments
	//if(nrhs<5 || nrhs>6)
		//mexErrMsgTxt("Only five or six input arguments are allowed!");
	if(nlhs<2 || nlhs>3)
		mexErrMsgTxt("Only two or three output arguments are allowed!");
    mexPrintf("--------nrhs=%d\n",nrhs);
	DImage Im1,Im2,warpIm2,u,v;
    Im1.LoadMatlabImage(prhs[0]);
    Im2.LoadMatlabImage(prhs[1]);
    warpIm2.LoadMatlabImage(prhs[2]);
    u.LoadUV(prhs[3]);
    v.LoadUV(prhs[4]);
    mexPrintf("width %d   height %d   nchannels %d\n",u.width(),u.height(),u.nchannels());
	//LoadImage(Im1,prhs[0]);
	//LoadImage(Im2,prhs[1]);
	mexPrintf("width %d   height %d   nchannels %d\n",Im1.width(),Im1.height(),Im1.nchannels());
	//mexPrintf("width %d   height %d   nchannels %d\n",Im2.width(),Im2.height(),Im2.nchannels());
	if(Im1.matchDimension(Im2)==false)
		mexErrMsgTxt("The two images don't match!");
	
	// get the parameters
	double alpha= 1;
	double ratio=0.5;
	int minWidth= 40;
	int nOuterFPIterations = 3;
	int nInnerFPIterations = 1;
	int nSORIterations= 20;
	if(nrhs>5)
	{
		int nDims=mxGetNumberOfDimensions(prhs[5]);
		const int *dims=reinterpret_cast <const int *>(mxGetDimensions(prhs[5]));
		double* para=(double *)mxGetData(prhs[5]);
		int npara=dims[0]*dims[1];
		if(npara>0)
			alpha=para[0];
		if(npara>1)
            nOuterFPIterations=para[1];
		if(npara>2)
            nInnerFPIterations=para[2];
		if(npara>3)
            nSORIterations = para[3];
	}
	//mexPrintf("alpha: %f   ratio: %f   minWidth: %d  nOuterFPIterations: %d  nInnerFPIterations: %d   nCGIterations: %d\n",alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nCGIterations);

	//DImage vx,vy,warpI2;
	//OpticalFlow::Coarse2FineFlow(vx,vy,warpI2,Im1,Im2,alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations);
    
    OpticalFlow::SmoothFlowSOR(Im1, Im2, warpIm2, u, v, alpha, nOuterFPIterations, nInnerFPIterations,nSORIterations);

	// output the parameters
	u.OutputToMatlab(plhs[0]);
	v.OutputToMatlab(plhs[1]);
	if(nlhs>2)
		warpIm2.OutputToMatlab(plhs[2]);
}