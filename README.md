# TBIM
This repository shows the implementation of the Trained Born Iterative Method (TBIM) in the reference below applied for electromagnetic imaging.

The repositry includes two folders:
  1) Matlab: Matlab folder to generate the training, validation, and testing set. 
  2) Python: To traine the TBIM model using Pytorch 1.8.1 cuda. It also consist the pre-trained model used in the reference below. 


# Matlab
The following files are created under the Matlab folder:
  1) ProblemConfiguration.m : Run this file to generate the problem configuration that includes receiver-tranmitter locations, invistigation domain discritized grid, cylinderical permittivity profiles that are used to train the model. The file will return "ProblemConfiguration.mat" used in scattered field computation.  
  2) MoM_forward_solver_TM_v2.m : After running (1), run this file that will compute the 2D EM forward model for each example. The file will return "machine_learning_data.mat" the consist of the scatterd field and the permtivitty profiles of each output. The scattered field will be used as an input while the profiles as an output. 
  3) GeneratePythonData.m : This file will generate the final variables needed to run the trianing. It returnes "dataForPythonBIMcmplx25dB" that consist of the "noisy" scattered field, permittivity profiles, along with the matrixes and variables required to run the TBIM model. 
  4) BiCGFFTtm.m : Run the Stabilized Bi-Conjugate Gradient (BiCG) to solve the matrix inversion for the total field.
  5) fftforwardtm.m : Excute FFT matrix multiplciation needed in BiCG.
  6) matdiag.m : performs digonal matrix multiplication
 
 # Python
 The following files are created under the Python folder:
  1) PreTrainedTBIM.ipynb : To run the pre-trained model used in the artical where "regNet1, regNet2, regNet3" are the trained networks for the first, second, and third regularization networks. The data file "dataForPythonBIMcmplx25dB.mat" is needed, that shall be generated from Matlab as explained above. 
  2) TrainTBIM.ipynb : To trained the TBIM as desciped in the artical. The data file "dataForPythonBIMcmplx25dB.mat" is needed, that shall be generated from Matlab as explained above. 



 To cite this work:
 
@article{desmal2022trained,  
  title={A Trained Iterative Shrinkage Approach Based on Born Iterative Method for Electromagnetic Imaging},  
  author={Desmal, Abdulla},  
  journal={IEEE Transactions on Microwave Theory and Techniques},  
  year={2022},  
  publisher={IEEE}  
}
