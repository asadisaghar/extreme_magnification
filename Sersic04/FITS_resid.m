% This script reads the images (matrices of surface brightness) in each filter. 
% These files are called 'F200d_SERSICINDEX.txt' and 'F444d_SERSICINDEX.txt'.
% Where sersic indices corresponding to n = 0.4, 4, and 14 are called 04, 4, and 14.
% 'color_crit' is the parameter you are interested in changind I think. 
% It sets the color limit, below which the flux is integrated.
% It's worth noticing that the integrated flux is not limited spatially, 
% so also includes the demagnified image(s), but as we're interested in bluest parts which are not detectable in those images, 
% the outcome is still correct but inaccurate within a few percent...

%%%%%%%%%%%%%%%%%%%%%%%
%% initialization
%%%%%%%%%%%%%%%%%%%%%%%
clear all
maindir = '/scratch/hathor/saas9842/1_proj/Sersic04/';
outputdir = [maindir,'out/'];
plotdir = [maindir,'plot/'];

res		    = 0.005;  	% native resolution in 'arcsec'(should match the Glafic input file)
pixel_scale	= 0.065;   	% Gaussian PSF's FWHM. should be larger than (or equal to) 'res' 
grid_edge	= 40;		% (should match the Glafic input file)
m200_max    = 30.9;     % JWST detection limit for F200W filter with 100h exposure of a point source (AB magnitude)
m444_max    = 30.1;     % JWST detection limit for F444W filter with 100h exposure of a point source (AB magnitude)
SB200_max   = -2.5*log10(10^(-m200_max/2.5)*(pixel_scale^2));
SB444_max   = -2.5*log10(10^(-m444_max/2.5)*(pixel_scale^2));
F200_max    = 10^(-SB200_max/2.5);
F444_max    = 10^(-SB444_max/2.5);

%HERE!!
color_crit  = -0.1;     % the color criterion
SERSICINDEX = 04; 	% Options are 04, 4, and 14

x = linspace(-grid_edge/2,grid_edge/2,grid_edge/pixel_scale);
y = linspace(-grid_edge/2,grid_edge/2,grid_edge/pixel_scale);
[XD,YD] = meshgrid(x,y);

xt = linspace(-grid_edge/2,grid_edge/2,grid_edge/res);
yt = linspace(-grid_edge/2,grid_edge/2,grid_edge/res);
[XDt,YDt] = meshgrid(xt,yt);

display('Reading files');
%%%%%%%%%%%%%%%%%%%%%%%
%% Reading the 'original' image and applying the PSF
%%%%%%%%%%%%%%%%%%%%%%%
% for filter=[200 444]
% output_o = ['gauss_',num2str(filter),'_image.fits'];
% name_o   = [outputdir,output_o];
% data_o   = fitsread(name_o); 
% % cluster  = data_o(:,:,1);
% % nebula   = data_o(:,:,2);
% data     = data_o(:,:,3);
%% 
%% output_S = ['gauss_',num2str(filter),'_source.fits'];
%% name_S   = [outputdir,output_S];
%% data_S   = fitsread(name_S); 
%% source   = data_S(:,:,3);
%% 
%% %reading the critical lines and caustics
%% cc_file = ['gauss_',num2str(filter),'_crit.dat'];
%% cc_name = [outputdir,cc_file];
%% cc = importdata(cc_name);
%% xi_1 = cc(:,1);
%% yi_1 = cc(:,2);
%% xs_1 = cc(:,3);
%% ys_1 = cc(:,4);
%% xi_2 = cc(:,5);
%% yi_2 = cc(:,6);
%% xs_2 = cc(:,7);
%% ys_2 = cc(:,8);
%% 
% if filter==200
% %     cluster200 = data_o(:,:,1);
% %     nebula200  = data_o(:,:,2);
%     data200    = data_o(:,:,3);
%%     source200    = data_S(:,:,3);
%     m_data200 = -2.5*log10(data200);
%%     figure();
%%     imagesc(x,y,m_data200);
%%     set(gca,'YDir','normal');
%%     hold on
%%     plot(xi_1,yi_1,'.r');
%%     hold on
%%     plot(xs_1,ys_1,'.k');
%%     
% else if filter==444 
% %     cluster444 = data_o(:,:,1);
% %     nebula444  = data_o(:,:,2);
%     data444    = data_o(:,:,3);
%%     source444    = data_S(:,:,3);
%     m_data444 = -2.5*log10(data444);
%%     figure();
%%     imagesc(x,y,m_data444);
%%     set(gca,'YDir','normal');
%%     hold on
%%     plot(xi_1,yi_1,'.r');
%%     hold on
%%     plot(xs_1,ys_1,'.k');
%%     plot(xi_2,yi_2,'.b');
%%     plot(xs_2,ys_2,'.g');
%% 
%     end
% end
% end

%%%%%%%%%%%%%%%%%%%%%%%
%% Applying PSFs corresponding to each filter to images
%%%%%%%%%%%%%%%%%%%%%%%
display('applying PSFs');
% F200W = fitsread('PSF_NIRCam_F200W_revV-1.fits');
% F444W = fitsread('PSF_NIRCam_F444W_revV-1.fits');
for filter = [200 444]
if filter == 200
%     tic
%     F200_data    = convolve2(data200,F200W,'same');
%     fid200d=fopen('F200d.txt','wt');
%     for ii = 1:size(F200_data,1)
%     	fprintf(fid200d,'%g\t',F200_data(ii,:));
%     	fprintf(fid200d,'\n');
%     end
%     fclose(fid200d);
%     display(' F200W_data :');
%     toc 

     F200_data = importdata(['F200d_',num2str(SERSICINDEX),'.txt']);
     F200_data    = F200_data/pixel_scale^2;
     for i=1:length(F200_data)
         for j=1:length(F200_data)
             if F200_data(i,j)<F200_max
                 F200_data(i,j)=0.0000;
             end
         end
     end
     m200_data    = -2.5.*log10(F200_data);
 
         
% 1. rebinning the matrix to obtain the correct pixel scale
     F200_data_rebinned = interp2(XDt,YDt,F200_data,XD,YD);
     m200_data_rebinned = -2.5*log10(F200_data_rebinned);

% 2. smoothing the matrix with a Gaussian with the desired pixel scale as FWHM (or sigma?)
%      F200_data_filtered = gaussian_filter(F200_data,XD,YD,pixel_scale);
%      m200_data_filtered = -2.5*log10(F200_data_filtered);     


else if filter == 444
%     tic
%     F444_data = convolve2(data444,F444W,'same');
%     fid444d=fopen('F444d.txt','wt');
%     for ii = 1:size(F444_data,1)
%     	fprintf(fid444d,'%g\t',F444_data(ii,:));
%     	fprintf(fid444d,'\n');
%     end
%     fclose(fid444d);
% 
%     display('convolve2 F444W_data :');
%     toc 
        
    F444_data = importdata(['F444d_',num2str(SERSICINDEX),'.txt']);
    F444_data    = F444_data/pixel_scale^2;
     for i=1:length(F444_data)
         for j=1:length(F444_data)
             if F444_data(i,j)<F444_max
                 F444_data(i,j)=0.0000;
             end
         end
     end
    m444_data    = -2.5.*log10(F444_data);

     
% 1. rebinning the matrix to obtain the correct pixel scale
     F444_data_rebinned = interp2(XDt,YDt,F444_data,XD,YD);
     m444_data_rebinned = -2.5*log10(F444_data_rebinned);

% 2. smoothing the matrix with a Gaussian with the desired pixel scale as FWHM (or sigma?)
%      F444_data_filtered = gaussian_filter(F444_data,XD,YD,pixel_scale);
%      m444_data_filtered = -2.5*log10(F444_data_filtered);
     
    end
end
end

    color_data          = m200_data - m444_data;
    color_data_rebinned = m200_data_rebinned - m444_data_rebinned;

%%%%%%%%%%%%%%%%%%%%%%%    
%% Calculating the integrated flux over a an aperture including the cluster only
%%%%%%%%%%%%%%%%%%%%%%%
F200_bluest = F200_data(find(color_data<color_crit));
F200_int = 0;
for i=1:length(F200_bluest)
    F200_int = F200_int + F200_bluest(i);
end
m200_int = -2.5*log10(F200_int);
display(['Integrated F200 (bluer than ',num2str(color_crit),') = ', num2str(F200_int)]);
display(['corresponding AB mag. = ',num2str(m200_int)]);

F200_bluest_rebibnned = F200_data_rebinned(find(color_data_rebinned<color_crit));
F200_int_rebinned = 0;
for i=1:length(F200_bluest_rebibnned)
    F200_int_rebinned = F200_int_rebinned + F200_bluest_rebibnned(i);
end
m200_int_rebinned = -2.5*log10(F200_int_rebinned);
display(['Integrated F200_rebinned (bluer than ',num2str(color_crit),') = ', num2str(F200_int_rebinned)]);
display(['corresponding AB mag. = ',num2str(m200_int_rebinned)]);

F444_bluest = F444_data(find(color_data<color_crit));
F444_int = 0;
for i=1:length(F444_bluest)
    F444_int = F444_int + F444_bluest(i);
end
m444_int = -2.5*log10(F444_int);
display(['Integrated F444 (bluer than ',num2str(color_crit),') = ', num2str(F444_int)]);
display(['corresponding AB mag. = ',num2str(m444_int)]);

F444_bluest_rebibnned = F444_data_rebinned(find(color_data_rebinned<color_crit));
F444_int_rebinned = 0;
for i=1:length(F444_bluest_rebibnned)
    F444_int_rebinned = F444_int_rebinned + F444_bluest_rebibnned(i);
end
m444_int_rebinned = -2.5*log10(F444_int_rebinned);
display(['Integrated F444_rebinned (bluer than ',num2str(color_crit),') = ', num2str(F444_int_rebinned)]);
display(['corresponding AB mag. = ',num2str(m444_int_rebinned)]);

%%%%%%%%%%%%%%%%%%%%%%%
%% |Mu| = 112 image 
%%%%%%%%%%%%%%%%%%%%%%%
amin = -1.5;
amax = 0.0;
zeroclr = [1 1 1];
cm = jet;
n = size(cm,1);
dmap = (amax-amin)/n;

figure(1);
%subplot(121)
him1 = imagesc(x,y,color_data);
set(gca,'YDir','normal');
hold on;
colormap([zeroclr; cm]);
caxis([amin-dmap amax]);
hcb1 = colorbar;
ylim(hcb1,[amin amax]);
title(['pixel scale = ',num2str(res),sprintf('\n'),'m_{200} \sim ', num2str(floor(m200_int)), sprintf('\n'),'m_{444} \sim ', num2str(floor(m444_int))],'FontSize',15);
xlabel('arcsec','FontSize',20);
ylabel('arcsec','FontSize',20);
%1(5"X5")
xlim([-11,-6]);
ylim([-8.5,-3.5]);
set(gca,'FontSize',15);

figure(2);
%subplot(122)
him2 = imagesc(x,y,color_data_rebinned);
set(gca,'YDir','normal');
hold on;
colormap([zeroclr; cm]);
caxis([amin-dmap amax]);
hcb2 = colorbar;
ylim(hcb2,[amin amax]);
title(['pixel scale = ',num2str(pixel_scale),sprintf('\n'),'m_{200} \sim ', num2str(floor(m200_int_rebinned)), sprintf('\n'),'m_{444} \sim ', num2str(floor(m444_int_rebinned))],'FontSize',15);
xlabel('arcsec','FontSize',20);
ylabel('arcsec','FontSize',20);
%1(5"X5")
xlim([-11,-6]);
ylim([-8.5,-3.5]);
set(gca,'FontSize',15);

%%%%%%%%%%%%%%%%%%%%%%%
% %% Applying PSFs corresponding to each filter to the source
%%%%%%%%%%%%%%%%%%%%%%%
% for filter = [200 444]
%     
% if filter == 200
%     tic
%     F200_source    = convolve2(source200,F200W,'same');
%     fid200S=fopen('S200S.txt','wt');
%     for ii = 1:size(F200_source,1)
%     	fprintf(fid200S,'%g\t',F200_source(ii,:));
%     	fprintf(fid200S,'\n');
%     end
%     fclose(fid200S);
%     display(' F200W_source :');
%     toc 
% 
%       
% %       F200_source = importdata('S200d.txt');
%       F200_source = F200_source/pixel_scale^2;
%       m200_source = -2.5.*log10(F200_source);
%     
% % rebinning the matrix to obtain the correct pixel scale
%      F200_source_rebinned = interp2(XDt,YDt,F200_source,XD,YD);
% %      F200_source_rebinned = F200_source_rebinned/pixel_scale^2;
%      m200_source_rebinned = -2.5*log10(F200_source_rebinned);
%     
% else if filter == 444
%     tic    
%     F444_source   = convolve2(source444,F444W,'same');
%     fid444S=fopen('S444S.txt','wt');
%     for ii = 1:size(F444_source,1)
%     	fprintf(fid444S,'%g\t',F444_source(ii,:));
%     	fprintf(fid444S,'\n');
%     end
%     fclose(fid444S);
%     display('convolve2 F444W_source :');
%     toc 
%  
% %      F444_source = importdata('S444d.txt');
%      F444_source = F444_source/pixel_scale^2;
%      m444_source = -2.5.*log10(F444_source);
%     
% % rebinning the matrix to obtain the correct pixel scale
%      F444_source_rebinned = interp2(XDt,YDt,F444_source,XD,YD);
% %      F444_source_rebinned = F444_source_rebinned/pixel_scale^2;
%      m444_source_rebinned = -2.5*log10(F444_source_rebinned);
%      
%     end
% end
% end
% 
%     color_source          = m200_source - m444_source;
%     color_source_rebinned = m200_source_rebinned - m444_source_rebinned;
    
%%%%%%%%%%%%%%%%%%%%%%%
%% source
%%%%%%%%%%%%%%%%%%%%%%%
% CLIM = [-1.5 -0.0];
% m_cl=linspace(32,35,10);
% figure();
% 
% subplot(121)
% imagesc(xt,yt,color_source,CLIM);
% set(gca,'YDir','normal');
% % hold on;
% colorbar;
% 
% [CT200 h200] = contour(xt,yt,m200_source,m_cl,'k','LineWidth',2);
% % clabel(CT200);
% [CT444 h444] = contour(xt,yt,m444_source,m_cl,'g','LineWidth',2);
% % clabel(CT444);
% 
% title(['pixel scale = ',num2str(res)],'FontSize',20);
% xlabel('arcsec','FontSize',20);
% ylabel('arcsec','FontSize',20);
% set(gca,'FontSize',15);
% 
% %1(all covered by PSF)
% xlim([-5.5,1]);
% ylim([-7,-0]);
% 
% %2 (0.5"X0.5")
% % xlim([-2.5,-2]);
% % ylim([-3.9,-3.4]);
% % legend([h200,h444],'"F200W" (mag./arcsec^2)','"F444W" (mag./arcsec^2)','Position','NE');
% 
% subplot(122)
% imagesc(x,y,color_source_rebinned,CLIM);
% set(gca,'YDir','normal');
% % hold on;
% colorbar;
% 
% [CT200_re h200_re] = contour(x,y,m200_source_rebinned,m_cl,'k','LineWidth',2);
% % clabel(CT200_re);
% [CT444_re h444_re]= contour(x,y,m444_source_rebinned,m_cl,'g','LineWidth',2);
% % clabel(CT444_re);
% 
% title(['pixel scale = ',num2str(pixel_scale)],'FontSize',20);
% xlabel('arcsec','FontSize',20);
% ylabel('arcsec','FontSize',20);
% set(gca,'FontSize',15);
% 
% %1(all covered by PSF)
% xlim([-5.5,1]);
% ylim([-7,-0]);
% 
% %2 (0.5"X0.5")
% % xlim([-2.5,-2]);
% % ylim([-3.9,-3.4]);
% % legend([h200_re,h444_re],'"F200W" (mag./arcsec^2)','"F444W" (mag./arcsec^2)','Position','NE');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PSFs
%%%%%%%%%%%%%%%%%%%%%%%
% m_200W = -2.5.*log10(F200W);
% m_444W = -2.5.*log10(F444W);
% figure();
% subplot(121)
% imagesc(m_200W);
% % hold on;
% % contour(x,y,m_200W,5,'LineWidth',2);
% title('F200W');
% subplot(122)
% imagesc(m_444W);
% % hold on;
% % contour(XD,YD,m_444W,5,'LineWidth',2);
% title('F444W');

%%%%%%%%%%%%%%%%%%%%%%% 
%  %% Writing the final output into a file
%%%%%%%%%%%%%%%%%%%%%%%
% %outname=[plotdir,num2str(SUBtype),num2str(lgMASS_low),'_',num2str(lgMASS_up),'.eps'];
% outname=[plotdir,num2str(SUBtype),num2str(lgMASS),'.eps'];
% print(gcf,'-depsc' ,outname)


