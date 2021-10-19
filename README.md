# Chirp-3d-Encoding-Matlab-Code

This repo contains the code to reproduce results in:

[Pawar K, Chen Z, Zhang J, Shah NJ, Egan GF. Application of compressed sensing using chirp encoded 3D GRE and MPRAGE sequences. *International Journal of Imaging Systems and Technology. 2020 Feb 3*](https://doi.org/10.1002/ima.22401).

## Installation
Run setup.m to set all the required paths and dependencies. After installation Run the follwong .m files 

## Matlab code files
1. RetrospectiveReconF.m : Code to perform restrospective undersampling and MCS reconstuction on acquired Fouirer encoded invivo k-space data
2. RetrospectiveReconC.m : Code to perform restrospective undersampling and MCS reconstuction on acquired Chirp encoded invivo k-space data
3. ProspectiveReconF.m : Code to perform MCS reconstuction on propectively undersampled Fourier encoded invivo k-space data
4. ProspectiveReconC.m : Code to perform MCS reconstuction on propectively undersampled Chirp encoded invivo k-space data

5. MIP_CS_F: SWI processing and Minimmum intensity projection for accelerated Fourier encoding.
6. MIP_CS_C: SWI processing and Minimmum intensity projection for accelerated Chirp encoding.

The data for running all the codes (1-6) is (~1 GB) and available at: [link](https://bridges.monash.edu/ndownloader/files/24163349)

The raw k-space data (10 GB) is available at: [link](https://monash.figshare.com/articles/Chirp-Encoding-3D-K-Space-Data/7640453)


