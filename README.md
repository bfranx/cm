# cm

Version 0.1.0

## REQUIREMENT

- Matlab image processing toolbox

## Description

 cm (ColorMap) extracts a slice from an 3D matrix and renders it, 
 returning graphical object handles of the image and the colorbar for easy
 editing and saving
 
 Obligatory input:
  imin         : matrix representing your image (currently 3D only!)
  pixdim       : vector of length 3 denoting the pixel dimensions corresponding to the image
  direction    : slice direction [ 0 - 2 ]
  slice        : slice selection
 Optional input:
  mask         : mask (will crop out region if specified)
  limits       : vector of length 2 that specifies intensity range (default: 100)
  sf           : scaling factor
  mycm         : colormap of choice, should be three-column matrix of RGB triplets (see example.m)
  mycbopt      : colorbar options, passed on to colorbar() 

 Author: bfranx 
 v0.1.0 (230725)

## TODO

- function not tested on 2D input
- inputParser is nicely readable but slow, possibly replace with alternative

## License

This project is licensed under the terms of the [MIT License](/LICENSE.md)

## Citation

Please [cite this project as described here](/CITATION.md).
