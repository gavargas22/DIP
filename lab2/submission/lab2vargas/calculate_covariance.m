% Guillermo Vargas
% February 10,2016

% This function takes an image and calculates the covariance of the image of n bands.

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

% Here I generate a matrix where I will store all the results for the
% covariance calculation.
covariance_matrix = zeros(image_bands);


% ===============================
% For the calculation of the correlation matrix, we set up the following:
% Create a matrix where we store the values of the (number of bands) standard deviations.
standard_deviation_matrix = zeros(1, image_bands);
% Calculate standard deviation
for band_location = 1:numel(standard_deviation_matrix)
    % Stadard Deviation Calculation, I do it step by step to avoid bugs.
    for band_location = 1:numel(standard_deviation_matrix)
        substraction_values = (original_image_data(:, :, band_location) - band_mean_matrix(band_location)).^2;
        summation_of_values = (sum(sum(substraction_values)))/((image_rows*image_columns)-1);
        standard_deviation_matrix(band_location) = sqrt(summation_of_values);
    end    
end

% Create an empty matrix for storing the actual correlation matrix
% generated in the code below.
correlation_matrix = zeros(image_bands);
% ================================

% This following code calculates the covariance and correlation matrices.

% Value to keep track on what iteration we are on.
iteration_index = 1;
% These are just to keep track which band we are working on.
left_band = 1; right_band = left_band + 1;

% A while loop to continue calculating until we reach the end of the
% covariance matrix.
while iteration_index < numel(covariance_matrix) && right_band <= 9
    % Go through the whole matrix column by column first and row by row in each column.
    for col = 1:image_bands
        for row = 1:image_bands
            % Execute the numerator of the covariance calculation first.
            covariance_of_bands = sum(sum(((original_image_data(:, :, col)) - (band_mean_matrix(col))) .* (original_image_data(:, :, row) - (band_mean_matrix(row)))));
            % Calculate the covariance with the denominator of the formula.
            covariance_value = (covariance_of_bands) ./ (total_number_of_pixels - 1);
            % Insert the covariance value into its corresponding position.
            covariance_matrix(row, col) = covariance_value;
            % Now perform the computation of the correlation matrix.
            correlation_value = (covariance_value)/(standard_deviation_matrix(col)*standard_deviation_matrix(row));
            % Insert the correlation value into its matrix at corresponding row and col.
            correlation_matrix(row, col) = correlation_value;
            % Increase the iteration number to continue with the process.
            iteration_index = iteration_index + 1;
                
        end
    end
    % Show the resulting matrices, and that's it!
    covariance_matrix
    correlation_matrix
end
