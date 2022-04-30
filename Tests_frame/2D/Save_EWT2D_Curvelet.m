function Save_EWT2D_Curvelet(ewt2d,name)

%=========================================================================
%
% function Save_EWT2D_Curvelet(ewt2d,name)
%
% Save each subband image in separate files named 'Cxyname.png' where x
% and y are the indices of the scales and directions, respectively.
% The images are renormalized between 0 and 1.
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
% ========================================================================

nr=length(ewt2d);

% Plot each subband with the same normalization
gname=sprintf('C011%s.png',name);
imwrite((ewt2d{1}-min(ewt2d{1}(:)))/(max(ewt2d{1}(:))-min(ewt2d{1}(:))),gname,'png');
 
for r=2:nr;
    nc=length(ewt2d{r});
    for c=1:nc;
        gname=sprintf('C%02d%d%s.png',r,c,name);
        imwrite((ewt2d{r}{c}-min(ewt2d{r}{c}(:)))/(max(ewt2d{r}{c}(:))-min(ewt2d{r}{c}(:))),gname,'png');
    end
end
