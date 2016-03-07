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
figure, imagesc(image_data')

% Now I start the transformations.
% Scale the image by the given factor.

% We create an empty matrix where to store the new values for the new image
scaled_matrix = zeros(image_rows*image_scale_factor, image_columns*image_scale_factor);
[scaled_matrix_row, scaled_matrix_col] = size(scaled_matrix);

% The rotation transformation can be expressed in terms of a rotation matrix.
rotation_operation = [-sind(image_rotation_angle) cosd(image_rotation_angle) ; cosd(image_rotation_angle) sind(image_rotation_angle)];
rotated_matrix = zeros(image_rows, image_columns);

% Go col by col and row by row until all have been traversed, substract one because we
% don't want the extra pixel in the result
for col = 1:image_columns - 1
    for row = 1:image_rows - 1
        % Obtain the location x that should be scaled and scale it by the
        % scale factor, do the same for the y location add one to remove a
        % premature end to calculation when initial position is zero.
        x = floor(col*image_scale_factor)+1;
        y = floor(row*image_scale_factor)+1;
        % Using the rotation transformation matrix, set the location to the rotated position.
        position_of_pixel_to_transform = [x ; y];
        %transformed_position = floor(rotation_operation * position_of_pixel_to_transform)';
        % Insert at the scaled location the pixel value of the original
        % image at the current row and column in the iteration.
        scaled_matrix(x, y) = image_data(row, col);
        rotated_matrix(x, y) = image_data(row, col);
    end
end
figure(2), imagesc(scaled_matrix)

% Rotation operations
for rotated_x = scaled_matrix_col:-1:1
    for rotated_y = scaled_matrix_row:-1:1
        x_nought = floor(rotated_x*cosd(image_rotation_angle) + rotated_y*sind(image_rotation_angle));
        y_nought = floor(rotated_x*sind(image_rotation_angle) + rotated_y*cosd(image_rotation_angle));
        
        rotated_matrix(rotated_x, rotated_y) = rotated_matrix(x_nought, y_nought);
        
    end
end

%  Display the transformed matrix.
figure(3);
hold off;
imagesc(rotated_matrix');
axis image;
title('Scaled Image');
xlabel('column');
ylabel('row');
hold on;


