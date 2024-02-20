# Troubleshooting
## No OpenCL platforms found
If you get this error, it means that Immolate was unable to find any devices that support OpenCL on your computer. You may need to install drivers for OpenCL in order to use Immolate, or your computer may not be compatible. Check the websites of the vendors of your GPU and CPU to see if there are OpenCL drivers available.
## Errors involving cl_khr_fp64
If Immolate fails to create the OpenCL kernel with a bunch of errors mentioning `cl_khr_fp64`, it means that your OpenCL device isn't supported by Immolate. You will have to use another OpenCL device in order to use Immolate.
## Other errors when creating kernel
There are many other reasons why there could be an error when creating the OpenCL kernel. There could be an error in Immolate itself, or either the filter or modifications to `search.cl` could have produced an error. If errors are occuring inside of the directory `.\lib`, this means it is an error inside Immolate and should be reported. Otherwise, double check the code of the filter or of your modifications to `search.cl`.