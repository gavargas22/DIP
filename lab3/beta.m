I = checkerboard(20,1,1);
figure; imshow(I)
T = maketform('affine',[2 0 0 ; 0 2 0 ; 0 0 1]);
R = makeresampler('cubic','circular');
K = imtransform(I,T,R,'Size',[100 100],'XYScale',1);
figure, imshow(K)