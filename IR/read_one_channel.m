% Read the RGB image

RGB = imread('images/image.jpg');

% Obtain sizes of image
[r, c, ch] = size(RGB);
% Get an image subset.
image_subset = im2double(imcrop(RGB,[0 0 r r])); % xmin ymin width height
% Get the red channel
R = image_subset(:, :, 1);
B = image_subset(:, :, 3);

% Calculate NDVI
% (NIR-B)/(NIR+B)

calculation_matrix = ones(size(R));

for index = 1:numel(calculation_matrix)
    % get pixel value of each element in  current iteration.
    NDVI = single(R(index)-B(index))/(R(index)+B(index));
    calculation_matrix(index) = NDVI;
end

% Display image

figure(1);
hold off;
imagesc(calculation_matrix);
axis image;
title('Test Image');
xlabel('column');
ylabel('row');
hold on;

% Write a file to be opened in ENVI as well just in case.
to_write_file_id = fopen(['test' '.img'], 'wb');
% Finally just write the data and flip it.
fwrite(to_write_file_id, calculation_matrix', 'double');
% Finish up by closing the file, ready for use.
fclose(to_write_file_id);
