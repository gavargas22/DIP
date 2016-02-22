% Guillermo Vargas
% February 20,2016

% This code will apply certain transformations to the image selected.

% First, we select the image that we want to analyze through a dialog
[FileName,PathName] = uigetfile('*.img','Select the image to apply transformation to.');
% Proceed now to open the file
original_file_id = fopen([PathName FileName], 'r', 'l');
% Obtain information about the file from the user through a dialog box.
image_data_prompt = {'Enter image row size:','Enter image column size:', 'Enter the scale factor in decimal fraction:', 'Enter the angle of rotation desired in degrees and clockwise direction:'};
dialog_title = 'Image Size & transofrmation information';
num_lines = 1;
default_answer = {'1400', '1400', '0.5', '30'};
user_gathered_image_information = inputdlg(image_data_prompt, dialog_title, num_lines, default_answer);

% We store in matrix the obtained strings and convert them to numbers.
image_information = str2double(user_gathered_image_information(:)');
image_rows = image_information(1);
image_columns = image_information(2);
image_scale_factor = image_information(3);
image_rotation_angle = image_information(4);
% I set a variable to the number of total items in the image for future
% use.
total_number_of_pixels = image_rows * image_columns;

% Use MATLAB to open the image file.
image_data = fread(original_file_id, [image_rows, image_columns], 'uint8');

% Now I start the transformations.
% Scale the image by the given factor.

scaling_factor_matrix = [2 0 0; 0 2 0; 0 0 1];
% scaling_transform = maketform('affine2d', scaling_factor_matrix);
% uv1 = tformfwd(scaling_transform, [x y]);

image_transform_operation = maketform('affine2d', scaling_factor_matrix);
J = tformfwd(image_data, image_transform_operation);

figure(1);
hold off;
imagesc(J');
fclose(original_file_id);
axis image;
title('Test Image');
xlabel('column');
ylabel('row');
hold on;

