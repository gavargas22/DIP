function result = image_mean_testing(output_filename) 
% Open up the image
file_id = fopen('test\test.img', 'r', 'l');
image_subset = fread(file_id, [1400, 1400], 'uint8');

% Calculate the mean brightness value of the image.
% Mean of pixel values
mean = floor(sum(sum(image_subset))/numel(image_subset));


% Go through each pixel on the image and calculate whether the brightness
% value at that location is greater than equal to or less than the mean
% obtained above.

% Create a new matrix where to store everything with dimensions given
new_image_data_matrix = ones(1400, 1400);

% Loop through the whole dataset
for index = 1:numel(image_subset)
  % get pixel value of each element in iteration.
  pixel_value = image_subset(index);
    
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

% Write a file to be opened in ENVI

to_write_file_id = fopen([output_filename '.img'], 'wb');
% Finally just write the data.
fwrite(to_write_file_id, new_image_data_matrix, 'int16');
% Finish up by closing the file, ready for use.
fclose(to_write_file_id);
% Display useful message for header opening in ENVI
disp(['To open file in ENVI, select BIP, samples = 1400, lines = 1400 and integer.']);


end