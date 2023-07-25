# cm

Version 0.1.0

See usage example in example.m


## REQUIREMENT

- Matlab image processing toolbox

## Description

cm (ColorMap) extracts a slice from an 3D matrix and renders it, 
returning graphical object handles of the image (fig) and the colorbar (cb) for easy
editing and saving
 
Obligatory input:   
&nbsp;&nbsp;imin         : matrix representing your image (currently 3D only!)   
&nbsp;&nbsp;pixdim       : vector of length 3 denoting the pixel dimensions corresponding to the image  
&nbsp;&nbsp;direction    : slice direction [ 0 - 2 ]  
&nbsp;&nbsp;slice        : slice selection  

Optional input:   
&nbsp;&nbsp;mask         : mask (will crop out region if specified)  
&nbsp;&nbsp;limits       : vector of length 2 that specifies intensity range (default: 100)  
&nbsp;&nbsp;sf           : scaling factor  
&nbsp;&nbsp;mycm         : colormap of choice, should be three-column matrix of RGB triplets (see example.m)  
&nbsp;&nbsp;mycbopt      : colorbar options, passed on to colorbar()  

Output:  
&nbsp;&nbsp;fig          : graphical object handle of the rendered slice  
&nbsp;&nbsp;cb           : object handle for colorbar  

See usage example in example.m

## TODO

- function not tested on 2D input
- inputParser is nicely readable but slow, possibly replace with alternative

## License

This project is licensed under the terms of the [MIT License](/LICENSE.md)

## Citation

Please [cite this project as described here](/CITATION.md).
