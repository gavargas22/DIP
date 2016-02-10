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
% Use MATLAB to open a multiband image file.
original_image_data = multibandread([PathName FileName], [image_rows, image_columns, image_bands], 'uint8', 0, 'bsq', 'ieee-le'); 
fclose(original_file_id);

% Obtain the amount of combinations that are possible.
maximum_times = factorial(image_rows * image_columns) ./ (factorial(2) .* factorial(image_rows * image_columns - 2));


end

