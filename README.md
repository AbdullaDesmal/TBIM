# TBIM
This repository shows the implementation of the Trained Born Iterative Method (TBIM) applied for electromagnetic imaging in the reference below.  
Keywords: Born Iterative Method (BIM), trained regularization, CNN, machine learning, deep learning, electromagnetic imaging (EMI), Iterative shrinkage algorithms (ISTA), trained iterative shrinkage algorithm, and inverse scattering problems (ISP). 

The repository includes two folders:
  1) Matlab: Matlab folder to generate the training, validation, and testing sets. 
  2) Python: Train the TBIM model using Pytorch 1.8.1, Cuda version. It also consists of the pre-trained model used in the reference below. 
The file "TBIM_slides.pdf" consist of presentation slides for the approach. 

# Matlab
The following files are created under the Matlab folder:
  1) "ProblemConfiguration.m": Run this file to generate the problem configuration that includes receiver-transmitter locations, investigation domain discretized grid, and cylindrical permittivity profiles used to train the model. The file will return "ProblemConfiguration.mat" used in scattered field computation.  
  2) "MoM_forward_solver_TM_v2.m": After running (1), run this file that will compute the 2D EM forward model for each example. The file will return "machine_learning_data.mat," which consists of each output's scattered field and permittivity profiles. The scattered field will be used as an input, while the profiles will be output. 
  3) "GeneratePythonData.m": This file will generate the final variables needed to run the training. It returns "dataForPythonBIMcmplx25dB.mat" containing the "noisy" scattered field and permittivity profiles, along with the matrixes and variables required to run the TBIM model. The generated "mat" data file must be relocated to the Python folder directory to use for training.   
  4) "BiCGFFTtm.m": Run the Stabilized Bi-Conjugate Gradient (BiCG) to solve the matrix inversion for the total field.
  5) “fftforwardtm.m” : Excute FFT matrix multiplciation needed in BiCG.
  6) matdiag.m : performs digonal matrix multiplication
 
 # Python
 The following files are created under the Python folder:
  1) "PreTrainedTBIM.ipynb" : To run the pre-trained model used in the article where "regNet1, regNet2, regNet3" are the trained networks for the first, second, and third regularization networks. The data file "dataForPythonBIMcmplx25dB.mat" is needed, which shall be generated from Matlab, as explained above. 
  2) " TrainTBIM.ipynb" : To train the TBIM as described in the article. The data file "dataForPythonBIMcmplx25dB.mat" is needed, which shall be generated from Matlab, as explained above. 



# Cite this work
@article{desmal2022trained,  
  title={A Trained Iterative Shrinkage Approach Based on Born Iterative Method for Electromagnetic Imaging},  
  author={Desmal, Abdulla},  
  journal={IEEE Transactions on Microwave Theory and Techniques},  
  year={2022},  
  publisher={IEEE}  
}  
DOI: 10.1109/TMTT.2022.3205650  
https://ieeexplore.ieee.org/abstract/document/9903536/   
To see the ArXiv version   
https://arxiv.org/abs/2112.13367
