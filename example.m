% addpath('./matlab/cm')
% addpath('./matlab/export_fig') % path to export_fig package

myorientfunc = @(x) rot90(permute(x,[1,3,2])); % function to re-orient the image if needed

mask_='./data/B20_t2w_mask.nii.gz';
mask=niftiread(mask_);
mask=myorientfunc(mask);

imin_='./data/B20_t2w.nii.gz';
imin=niftiread(imin_);
imin=myorientfunc(imin);

cbopt="colorbar('Ticks',[5 10], 'TickLabels',{'5', '\geq10'}, 'FontSize', 25, 'Color', [0 0 0])"; % options for the colorbar passed to cm

mycm_mat = viridis(100); % colormap
[fig,cb] = cm(imin, [0.25 0.25 1], 2, 15, 'mask', mask, 'mycm',mycm_mat, 'sf',5, 'limits',[0 10], 'mycbopt',cbopt);
cb.Label.String='SI (A.U.)'; % edit colorbar label

% export_fig fig -tif -opengl -nocrop % save figure, refer to export_fig
% for usage and options: https://www.mathworks.com/matlabcentral/fileexchange/23629-export_fig