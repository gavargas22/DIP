% matlab script to perform Fourier domain filtering

clear

% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% crop image first 

%image=imread('enceladus_cassini.jpg');		
%a=image(25:1000, 25:1000);	
%imwrite(a,gray(256),'Enceladus_fractures.jpg','jpg');

% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!	


% load in Enceladus image

image=imread('Enceladus_fractures.jpg');		
enceladus=double(rgb2gray(image));		


% plot the given image

figure(1)
imagesc(enceladus)
title('original Enceladus fractures image')
colormap gray
colorbar


% get size of original image, will need these numbers later

[height,width]=size(enceladus)


% take fourier transform of the image
% zero pad image out to nearest power of 2
% possible tries:  1024  2048  4096

xdim_zeropad=1024;
ydim_zeropad=1024;
xhalf=xdim_zeropad/2;
yhalf=ydim_zeropad/2;

Fenceladus=fft2(enceladus,xdim_zeropad,ydim_zeropad);	   % Fourier transform
FSenceladus=fftshift(Fenceladus);			   % shift the quadrants

% display the log(abs) of the fourier transformed image

figure(2)
subplot(2,2,1),imagesc(log(abs(FSenceladus)))
title('log(abs(fft(Enceladus image)))')
colormap gray
colorbar


% set pixval on or off and interactively zoom in to find outliers
% zoom in and out, inspect frequency spectrum

pixval on
pixval off



% at this stage, you can design a mask in Fourier domain for filtering, 
% or define one in spatial domain and fourier transform to filter.

%  create a 3x3 high pass filter mask 
%  set up a matrix of zeros, and imbed the 3x3 in the center

HP=zeros(ydim_zeropad, xdim_zeropad);
HP(yhalf-1:yhalf+1,xhalf-1:xhalf+1) = [-1 -1 -1; -1 9 -1; -1 -1 -1];


%  you can also set up a 3x3 low pass filter mask

LP=zeros(ydim_zeropad, xdim_zeropad);
LP(yhalf-1:yhalf+1,xhalf-1:xhalf+1) = [0.25 0.5 0.25; 0.5 1.00 0.50; 0.25 0.5 0.25];


% fourier transform the HP kernal, make it size of zero-padded enceladus image

Fkernal=fft2(HP,xdim_zeropad,ydim_zeropad);
FSkernal=fftshift(Fkernal);


% plot the fourier transformed mask (kernal)

subplot(2,2,2),imagesc(log(abs(FSkernal)))
title('fourier transformed kernal')
colormap gray
colorbar


% multiply the FT image and kernal

FS_HPenceladus = FSkernal.*FSenceladus;


% plot the result

subplot(2,2,3),imagesc(log(abs(FS_HPenceladus)))
title('image * kernal')
colormap gray
colorbar


% plot a zoom of result

subplot(2,2,4),imagesc(log(abs(FS_HPenceladus(yhalf-100:yhalf+100,xhalf-100:xhalf+100))))
title('zoom:  image * kernal')
colormap gray
colorbar


% now unshift and inverse fourier transform
% also reshape to original size

HP_enceladus_all=fftshift(ifft2(fftshift(FS_HPenceladus)));
HP_enceladus=HP_enceladus_all(1:height,1:width);


% Normalize between 0 and 255 :

junk =HP_enceladus - min(min(HP_enceladus));
enceladus_image_norm = junk/max(max(junk))*255;


% plot, adjust colorscale limits to your liking

figure(4)
cm=[120 200];					% color map scale, adjust saturation
imagesc(enceladus_image_norm,cm)
colormap gray
title('new ifft image, stripes removed')




