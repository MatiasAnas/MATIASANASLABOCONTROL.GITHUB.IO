#define S_FUNCTION_NAME  param
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"

static void mdlInitializeSizes(SimStruct *S)
{
    ssSetNumSFcnParams(S, 1);

    ssSetNumInputPorts(S, 1);
    ssSetInputPortWidth(S, 0, 1);
    ssSetInputPortDirectFeedThrough(S, 0, 1);

    ssSetNumOutputPorts(S,1);
    ssSetOutputPortWidth(S, 0, 1);
    ssSetNumSampleTimes(S, 1);
    //ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
}

static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
}


static void mdlOutputs(SimStruct *S, int_T tid)
{
    real_T            *p;
    real_T            *y = ssGetOutputPortRealSignal(S,0);    
    InputRealPtrsType uPtrs = ssGetInputPortRealSignalPtrs(S,0);
    p = mxGetPr(ssGetSFcnParam(S,0));
    *y = *p *(*uPtrs[0]); 
   
}


static void mdlTerminate(SimStruct *S)
{
}

#ifdef  MATLAB_MEX_FILE    
#include "simulink.c"      
#else
#include "cg_sfun.h"    
#endif
