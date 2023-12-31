function [fig,cb]=cm(imin,pixdim,direction,slice,varargin)

% cm (ColorMap) extracts a slice from an 3D matrix and renders it, 
% returning graphical object handles of the image and the colorbar for easy
% editing and saving
% 
% Obligatory input:
%  imin         : matrix representing your image (currently 3D only!)
%  pixdim       : vector of length 3 denoting the pixel dimensions corresponding to the image
%  direction    : slice direction [ 0 - 2 ]
%  slice        : slice selection
% Optional input:
%  mask         : mask (will crop out region if specified)
%  limits       : vector of length 2 that specifies intensity range (default: 100%)
%  sf           : scaling factor
%  interp       : interpolation method (bilinear, bicubic or nearest)
%  mycm         : colormap of choice, should be three-column matrix of RGB triplets (see example.m)
%  mycbopt      : colorbar options, passed on to colorbar() 
%
% Output:
%  fig          : graphical object handle of the rendered slice
%  cb           : object handle for colorbar

% Author: bfranx 
% v0.2.0 (231101)

slicevalidationFcn = @(x) (x > 0) && isnumeric(x) && isscalar(x);
pixdimvalidationFcn = @(x) all(x > 0) && isnumeric(x) && isvector(x) && isequal(length(x),3);
mycmvalidationFcn = @(x) ischar(x) || isnumeric(x);
interpvalidationFcn = @(x) ismember(x, {'nearest','bilinear','bicubic'});
maskvalidationFcn = @(x) all(ismember(x(:),[0 1]));

p = inputParser;
p.KeepUnmatched = false;
p.FunctionName = 'cm';
addRequired(p,'imin', @isnumeric)
addRequired(p,'pixdim',pixdimvalidationFcn)
addRequired(p,'direction', @isscalar)
addRequired(p,'slice', slicevalidationFcn)
addParameter(p,'mask', [], maskvalidationFcn)
addParameter(p,'limits', [], @isvector)
addParameter(p,'sf', [], @isscalar)
addParameter(p,'interp', [], interpvalidationFcn)
addParameter(p,'mycm', [], mycmvalidationFcn)
addParameter(p,'mycbopt', [], @isstring)

parse(p, imin, pixdim, direction, slice, varargin{:})

if isempty(p.Results.limits) % set default limits 0-100%
    limits = [prctl(imin(:),1) prctl(imin(:),100)];
else
    limits = p.Results.limits;
end

if ~isempty(p.Results.mask) % crop image with mask
    if ~all(size(imin)==size(p.Results.mask))
        error('Error. Image and mask dimensions do not match.')
    end
    measurements = regionprops(p.Results.mask, 'BoundingBox');
    BB = [measurements.BoundingBox];
    
    x1 = BB(1:6:end);
    x2 = BB(1:6:end) + BB(4:6:end);
    y1 = BB(2:6:end);
    y2 = BB(2:6:end) + BB(5:6:end);
    z1 = BB(3:6:end);
    z2 = BB(3:6:end) + BB(6:6:end);
    % Get the overall bounds
    xLeft = ceil(x1);
    xRight = floor(x2);
    yLeft = ceil(y1);
    yRight = floor(y2);
    zLeft = ceil(z1);
    zRight = floor(z2);
end
            
[imslice,mypixdim] = getslice(imin,p.Results.slice,p.Results.pixdim,p.Results.direction);

if ~isempty(p.Results.mask) % convert non-masked pixels as NaN if masking is desired
    [maskslice,~] = getslice(p.Results.mask,p.Results.slice,p.Results.pixdim,p.Results.direction);
    imslice(maskslice~=1)=NaN;
end

if ~isempty(p.Results.mask) % crop image
    switch direction
        case 0
            imslice = imslice(xLeft:xRight, zLeft:zRight);
        case 1
            imslice = imslice(yLeft:yRight, zLeft:zRight);
        case 2
            imslice = imslice(yLeft:yRight, xLeft:xRight);
        otherwise
            error('Unknown direction input')
    end
end

sz=size(imslice);

if mypixdim(1) ~= mypixdim(2) % make 2d slice isotropic. TODO: make optional or remove it (user responsibility)
    targetpixdim = repmat(min(mypixdim),[1,2]); % use smallest pixdim as target pixdim
    targetsz = ceil((sz-1).*mypixdim./targetpixdim)+1;
    imslice = imresize(imslice,targetsz, 'nearest');
end

if ( ~isempty(p.Results.sf) && p.Results.sf>0 && isempty(p.Results.interp))
    imslice = imresize(imslice, p.Results.sf, 'nearest');
elseif ( ~isempty(p.Results.sf) && p.Results.sf>0 && ~isempty(p.Results.interp))
    imslice = imresize(imslice, p.Results.sf, interp);
end

% set up display scene
h = imshow(imslice, limits); 
set(h,'AlphaData',~isnan(imslice)) % get white background if masking is enabled

% apply colormap
if isempty(p.Results.mycm)
    mycm=colormap("gray");
else
    mycm=p.Results.mycm;
end
colormap(mycm);

if ~isempty(p.Results.mycbopt)
    c=eval(p.Results.mycbopt); % set colorbar options supplied by user
end

fig = ancestor(h,'figure'); % returns figure handle

if ~isempty(p.Results.mycbopt)
    cb = ancestor(c,'Colorbar'); % returns colorbar handle for editing
else
    cb = []; % if user asks for cb object but no cbopts have been provdided: return empty
end

return 
