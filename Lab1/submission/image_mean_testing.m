function result = image_mean_testing()
% The name of the output file, see line 54
output_filename = 'mean_calculation';
% Open up the image and assign it an id.
file_id = fopen('test\test.img', 'r', 'l');
% Get a subset of the image, the size is the regular size of the original
% image 1400x1400.
image_subset = fread(file_id, [1400, 1400], 'uint8');

% Calculate the mean brightness value of the image.
% Mean of pixel values. I round to the lowest possible non decimal integer.
% The function sums all the elements in the image matrix and spits out the
% single number in the double sum, then divides by the number of elements
% in the array through the MATLAB function numel.
mean = floor(sum(sum(image_subset))/numel(image_subset));

% Create a new matrix where to store the new calculated image will live.
new_image_data_matrix = ones(1400, 1400);

% Now I go through each pixel on the image and calculate whether the brightness
% value at that location is greater than equal to or less than the mean
% obtained above.

% Loop through the whole image subset. From the start of the matrix until
% the loop is executed as many times as there are values in the matrix.

for index = 1:numel(image_subset)
    % get pixel value of each element in  current iteration.
    pixel_value = image_subset(index);
    % Do some simple logic to create the new image.
    if pixel_value < mean
        new_image_data_matrix(index) = -1;
    elseif pixel_value == mean
        new_image_data_matrix(index) = 0;
    elseif pixel_value > mean
        new_image_data_matrix(index) = 1;
    end
end

% Display the image in MATLAB

figure(1);
hold off;
imagesc(new_image_data_matrix');
fclose(file_id);
axis image;
title('Test Image');
xlabel('column');
ylabel('row');
hold on;

% Write a file to be opened in ENVI as well just in case.
to_write_file_id = fopen([output_filename '.img'], 'wb');
% Finally just write the data and flip it.
fwrite(to_write_file_id, new_image_data_matrix', 'int16');
% Finish up by closing the file, ready for use.
fclose(to_write_file_id);

% Display useful message for useful header information for ENVI
disp('To open file in ENVI, select BIP, samples = 1400, lines = 1400 and integer.');


end