This folder contains all the malab code and data required to reproduce results presented in the manuscript "Implementation and evaluation of chirp encoding in 3D GRE and MPRAGE" 

####### Installation #########
Run setup.m to set all the required paths and dependencies. After installation Run the follwong .m files 

#### Matlab code file ######
1. RetrospectiveReconF.m : Code to perform restrospective undersampling and MCS reconstuction on acquired Fouirer encoded invivo k-space data
2. RetrospectiveReconC.m : Code to perform restrospective undersampling and MCS reconstuction on acquired Chirp encoded invivo k-space data
3. ProspectiveReconF.m : Code to perform MCS reconstuction on propectively undersampled Fourier encoded invivo k-space data
4. ProspectiveReconC.m : Code to perform MCS reconstuction on propectively undersampled Chirp encoded invivo k-space data

5. MIP_CS_F: SWI processing and Minimmum intensity projection for accelerated Fourier encoding.
6. MIP_CS_C: SWI processing and Minimmum intensity projection for accelerated Chirp encoding.

The data for running all the codes (1-6) is around (1 GB) and available at: https://drive.google.com/drive/folders/1FKhOIK9nDyfuqrDC_O8JaxmLYiAF6ESK?usp=sharing

The raw k-space data (10 GB) is available at: https://monash.figshare.com/articles/Chirp-Encoding-3D-K-Space-Data/7640453

