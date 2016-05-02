% Guillermo Vargas
% Lab 7

% Clear everything
clear
% Lets get the image from the user
[FileName,PathName] = uigetfile('*','Select the image file to apply transformation to.');
% Proceed now to open the file
original_file_id = fopen([PathName FileName], 'r', 'l');
% Obtain information about the file from the user through a dialog box.
image_data_prompt = {'Enter image row size:','Enter image column size:', 'Enter number of bands in image:'};
dialog_title = 'Image Information';
num_lines = 1;
default_answer = {'800', '800', '6'};
user_gathered_image_information = inputdlg(image_data_prompt, dialog_title, num_lines, default_answer);
% We store in matrix the obtained strings and convert them to numbers.
image_information = str2double(user_gathered_image_information(:)');
% Save thing in a useful place
image_rows = image_information(1);
image_columns = image_information(2);
image_bands = image_information(3);

total_number_of_pixels = image_rows * image_columns;

% Use MATLAB to open the image file.
% Use MATLAB to open a multiband image file.
original_image_data = multibandread([PathName FileName], [image_rows, image_columns, image_bands], 'uint8', 0, 'bsq', 'ieee-le'); 
fclose(original_file_id);

% Calculate the mean value of each band and save it on a matrix.
band_mean_matrix = 1:image_bands;
% Here is the calculation of the mean values.
for band_selector = 1:image_bands
    band_mean_matrix(band_selector) = mean(mean(original_image_data(:, :, band_selector)));
end

% In order to begin, I need to substract the mean of each band to all the
% pixels in each corresponding band to center the statistic distribution

centered_values_matrix = zeros(image_rows, image_columns, image_bands);
for band_selector = 1:image_bands
    centered_values_matrix(:, :, band_selector) = original_image_data(:, :, band_selector) - band_mean_matrix(band_selector);
end

% Here I generate a matrix where I will store all the results for the
% covariance calculation.
covariance_matrix = zeros(image_bands);

% For the calculation of the correlation matrix, we set up the following:
% Create a matrix where we store the values of the (number of bands) standard deviations.
standard_deviation_matrix = zeros(1, image_bands);
% Calculate standard deviation
for band_location = 1:numel(standard_deviation_matrix)
    % Stadard Deviation Calculation, I do it step by step to avoid bugs.
    for band_location = 1:numel(standard_deviation_matrix)
        substraction_values = (centered_values_matrix(:, :, band_location) - band_mean_matrix(band_location)).^2;
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
while iteration_index < numel(covariance_matrix) && right_band <= image_bands
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
end

% Now I calculate the eigenvectors of the correlation matrix
[V, D] = eig(covariance_matrix);

% Let's see which eigenvalues contain the most variance percentage
% Get all the eigenvalues in a matrix
eigenvalues_matrix = diag(D);

% Calculate the percentage of variance
percent_total_variance_matrix = (eigenvalues_matrix(:)*100)/sum(eigenvalues_matrix);

% Now I calculate the Correlation of each band with each component.
% We need the variance values
variance_values = diag(covariance_matrix);
correlation_of_band_to_component_matrix = zeros(image_bands, image_bands);
for component = 1:numel(eigenvalues_matrix)
    for band = 1:image_bands
        correlation_of_band_to_component_matrix(band, component) = (V(band, component)*sqrt(eigenvalues_matrix(component)))/(sqrt(variance_values(band)));
        if band == image_bands
            band = 1;
        end
    end
end

% Now we obtain the new brightness values
% The resulting image of the following operation will be stored in the following matrix
principal_component_image = zeros(image_rows, image_columns, image_bands);
% Get some info about the eigenvector matrix.
[bands_k, components_p] = size(V);
% Iterate to get the resulting image.
for col = 1:image_columns
    for row = 1:image_rows
        for band = 1:bands_k
            principal_component_image(row, col, band) = sum(V(:, band) .* squeeze(original_image_data(row, col, :)));
        end
        if band == image_bands
            band = 1;
        end
    end
end

% Convert to integers
integer_converted_principal_component_image = uint8(principal_component_image);

% Ask user for input on where to save the image
% Ask for a name to save the file to.
[save_filename, save_path] = uiputfile({'*.*', 'All Files' }, 'Save Image');
% Save it
multibandwrite(integer_converted_principal_component_image(:, :, 6), [save_path save_filename], 'bsq');
