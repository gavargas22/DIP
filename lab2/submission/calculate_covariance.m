function [ output_args ] = calculate_covariance()
%This function takes an image and calculates the covariance of the image.
% First, we select the image that we want to analyze through a dialog
[FileName,PathName] = uigetfile('*.img','Select the image to analyze.');
% Proceed now to open the file
original_file_id = fopen([PathName FileName], 'r', 'l');
% Obtain information about the file from the user through a dialog box.
image_data_prompt = {'Enter image row size:','Enter image column size:', 'Enter the number of bands in image:'};
dialog_title = 'Image Size Information';
num_lines = 1;
default_answer = {'1400', '1400', '9'};
user_gathered_image_information = inputdlg(image_data_prompt, dialog_title, num_lines, default_answer);

% We store in matrix the obtained strings and convert them to numbers.
image_information = str2double(user_gathered_image_information(:)');
image_rows = image_information(1);
image_columns = image_information(2);
image_bands = image_information(3);
% I set a variable to the number of total items in the image.
total_number_of_pixels = image_rows * image_columns;

% Use MATLAB to open a multiband image file.
original_image_data = multibandread([PathName FileName], [image_rows, image_columns, image_bands], 'uint8', 0, 'bsq', 'ieee-le'); 
fclose(original_file_id);

% Obtain the amount of combinations that are possible.
maximum_times = factorial(image_bands) ./ (factorial(2) .* factorial(image_bands - 2));

% Now I calculate the mean value of each band and save it on a matrix.
band_mean_matrix = 1:9;
% Here is the calculation of the mean values.
for band_selector = 1:image_bands
    band_mean_matrix(band_selector) = mean(mean(original_image_data(:, :, band_selector)));
end

% Here I generate a matrix where I will store all the results.
covariance_matrix = zeros(image_bands);

% I need to do a sum total_number_of_pixels times.
for index = 1:numel(image_bands)
    left_band = index;
    right_band = index + 1;
    for col = 1:image_bands
        for row = 1:image_bands
            covariance_of_bands = sum(sum(((original_image_data(:, :, left_band)) - (band_mean_matrix(left_band))) .* (original_image_data(:, :, right_band) - (band_mean_matrix(right_band)))));
            covariance_value = (covariance_of_bands) ./ (total_number_of_pixels - 1);
            covariance_matrix(row, col) = covariance_value;
        end 
    end
end

% for band_iteration = 1:image_bands - 1
%     % Set some variables to keep track which bands are we working on.
%     left_band = band_iteration;
%     right_band = left_band + 1;
%     
%     % I execute the top part of the algorithm first.
%     covariance_of_bands = sum(sum(((original_image_data(:, :, left_band)) - (band_mean_matrix(left_band))) .* (original_image_data(:, :, right_band) - (band_mean_matrix(right_band)))));
%     % Now we execute the bottom part of the algorithm.
%     covariance_value = (covariance_of_bands) ./ (total_number_of_pixels - 1);
%     covariance_matrix(band_iteration) = covariance_value;
%     
% %     covariance_matrix(matrix_location) = ((original_image_data(band_selector - band_mean_matrix())*())/(covariance_matrix_size - 1)
% end

