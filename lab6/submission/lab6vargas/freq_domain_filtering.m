% Guillermo Vargas
% Frequency Domain FIltering
% April 5, 2016

% This code will apply frequency domain filtering to an image file.

% First, we select the image that we want to analyze through a dialog
[FileName, PathName] = uigetfile('*', 'Select the image to apply filtering to.');
% Use MATLAB to open up the image file.
RGB = imread([PathName FileName]);
% Obtain sizes of image
[image_rows, image_columns, number_of_channels] = size(RGB);
% Get useful information for the future.
total_number_of_pixels = image_rows * image_columns;
median_location_of_rows = image_rows/2;
median_location_of_columns = image_columns/2;
%Create an initial figure window then show the image.
original_image_display = figure;
imshow(RGB);
% Now I save the image.

% Obtain the name and location where the image will be saved to.
[save_filename, save_path] = uiputfile({'*.*', 'All Files' }, 'Save Image');
% For now, I am saving as figure1.jpg regardless of what the input was,
% because that was what is required in the lab text.
save_filename = 'figure1.jpg';
% Save it to the chose location only we will use the name figure1.jpg as required per the lab documentation.
imwrite(RGB, [save_path save_filename]);

% Reopen the new image, so that we can start messing with it.
modifiable_image_rgb = imread([save_path save_filename]);
modifiable_image_grayscale = double(rgb2gray(modifiable_image_rgb));

% IN THE CASE OF THE IMAGE GIVEN WE DO NOT NEED PADDING BECAUSE THE SIZE OF
% THE IMAGE HAPPENS TO BE 1024, THE REASON WHY WE NEED PADDING ON ANY OTHER
% IMAGE THAT IS NOT A A POWER OF 2 IS BECAUSE THE FAST FOURIER TRANSFORM
% ONLY WORKS WITH IMAGES THAT HAVE A SIZE OF A POWER OF 2

% Do a Fourier Transform
fft_image = fft2(modifiable_image_grayscale, image_rows, image_columns);
% Shift the result
fft_shifted_image = fftshift(fft_image);
% Display the result.
figure(2);
subplot(2,2,1),imagesc(log(abs(fft_shifted_image)));
title('log(abs(fft(Enceladus image)))');
colormap gray;
colorbar;

% QUESTION 5 - The reason why we see the periodic fequencies away from the
% center is because they have a different frequency than the DC component,
% since we are working in the frequency domain.

% Enable pixel inspection on the first image to see the locations of the
% repeated frequencies.
impixelinfo

% We create an empty matrix with the size of the image, this one will
% contain the filter.
high_pass_filter_matrix = zeros(image_rows, image_columns);
% Insert the actual 3x3 matrix into the empty matrix.
high_pass_filter_matrix(median_location_of_rows - 1:median_location_of_rows + 1, median_location_of_columns - 1:median_location_of_columns + 1) = [-1 -1 -1; -1 9 -1; -1 -1 -1];

% Apply a fourier transform and shift the High Pass Filter kernel.
fourierized_high_pass_kernel = fft2(high_pass_filter_matrix, image_columns, image_rows);
fourierized_and_shifted_high_pass_kernel = fftshift(fourierized_high_pass_kernel);

% Display the fourierized and shifter High pass kernel.
subplot(2,2,2),imagesc(log(abs(fourierized_and_shifted_high_pass_kernel)))
title('fourier transformed kernel')
colormap gray
colorbar

% QUESTION 8. - The property that we are using in the below multiplication
% is the convolution property of Fourier Transform.

% Now we do a multiplication of the two transformed matrices.
result_of_multiplication = fourierized_and_shifted_high_pass_kernel .* fft_shifted_image;
% Remove the high frequencies manually.
result_of_multiplication((median_location_of_rows + 1) - 16, median_location_of_rows + 1) = 0;
result_of_multiplication((median_location_of_rows + 1), (median_location_of_rows + 1) - 16) = 0;
result_of_multiplication((median_location_of_rows + 1) + 16, (median_location_of_rows + 1)) = 0;
result_of_multiplication((median_location_of_rows + 1), (median_location_of_rows + 1) + 16) = 0;
result_of_multiplication(median_location_of_rows - 1:median_location_of_rows + 1, median_location_of_columns - 1:median_location_of_columns + 1) = [0 0 0 ; 0 0 0 ; 0 0 0];


% Plot the result of the multiplication above.
subplot(2,2,3),imagesc(log(abs(result_of_multiplication)))
title('image * kernel')
colormap gray
colorbar

% I now proceed to go back to getting the image.
inverse_transform_of_multiplication = fftshift(ifft2(fftshift(result_of_multiplication)));
% Make a new copy, so that I don't mess with the result.
filtered_image_result = inverse_transform_of_multiplication(1:image_rows, 1:image_columns);
% Normalize the pixel values.
rejected_pixels = filtered_image_result - min(min(filtered_image_result));
normalized_image_result = rejected_pixels/max(max(rejected_pixels))*255;
% Ask for a name to save the file to.
[save_filename, save_path] = uiputfile({'*.*', 'All Files' }, 'Save Image');
% Save it to the chose location only we will use the name figure1.jpg as required per the lab documentation.
imwrite(filtered_image_result, [save_path save_filename]);

% Display the image.
figure(4)
imshow(filtered_image_result);
colormap gray;

% QUESTION 11. - The result is pretty impressive, I recognize my face and
% the faces of my fellow classmates! Pretty cool lab!
