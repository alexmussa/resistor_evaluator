# resistor_evaluator
Matlab code that inputs an image of resistors and outputs their corresponding resistance values. The main function for the code is in img2resistance, which utilizes several custom functions as well as severl function from the Image Processing toolbox. I have included the custom functions in this repo, but you will need the image processing toolbox to run the code. 

The file, RunMe.m, was created to show an example of the code running on 10 different images. To run it:

1.) Open the matlab script, ‘RunMe.m’, in matlab. Make sure the other functions and images in the repo are added to the path.

2.) Change the value, x, in MRim = imread(images{x}) to a value between 1 and 10. This select which image to use.

3.) Hit ‘Run’ under editor and observe the output figures, as well as command prompt text for detected resistance bands, colors, and values.


