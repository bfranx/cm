function [myslice,mypixdim] = getslice(imin,slice,pixdim,direction)
% helper function to fetch a 2D slice and corresponding pixdims from 3D
% image
switch direction
    case 0        
        imnew = imin(slice,:,:);
        mypixdim = pixdim([2,3]);
    case 1        
        imnew = imin(:,slice,:);
        mypixdim = pixdim([1,3]);
    case 2
        imnew = imin(:,:,slice);
        mypixdim = pixdim([1,2]);
    otherwise
        error('Unknown direction input')
end    
myslice=squeeze(imnew);
