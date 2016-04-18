% Guillermo Vargas
% Unsharp Mask
% April 5,2016

% This code will apply certain transformations to the image selected.

% First, we select the image that we want to analyze through a dialog
[FileName,PathName] = uigetfile('*', 'Select the image to apply transformation to.');
% Proceed now to open the file
original_file_id = fopen([PathName FileName], 'r', 'l');
% Obtain information about the file from the user through a dialog box.
image_data_prompt = {'Enter image row size:','Enter image column size:'};
dialog_title = 'Image Size Information';
num_lines = 1;
default_answer = {'400', '400'};
user_gathered_image_information = inputdlg(image_data_prompt, dialog_title, num_lines, default_answer);

% We store in matrix the obtained strings and convert them to numbers.
image_information = str2double(user_gathered_image_information(:)');
image_rows = image_information(1);
image_columns = image_information(2);
% I set a variable to the number of total items in the image for future
% use.
total_number_of_pixels = image_rows * image_columns;

% Use MATLAB to open the image file.
image_data = multibandread([PathName FileName], [image_rows image_columns, 1], 'float', 0, 'bsq', 'ieee-le');

% Execute a La Placian Transform to sharpen image.
% ================================================
% Define the filter in matrix, kernel form.
laplace_filter = [0 1 0 ; 1 -4 1 ; 0 1 0];
% Initialize the matrix where to store the resulting data.
image_data_with_filter_applied = zeros(image_rows, image_columns);
% I now pad the image with zeros to run the kernel
padding_in_rows = 1;
padding_in_columns = 1;
padded_image_data = padarray(image_data, [padding_in_rows, padding_in_columns]);
% Get some information about the padded image data.
[padded_rows, padded_columns] = size(padded_image_data);

% Now we implement the equation for the laplacian sharpening. Going row by
% row and column by column, I substract two here because of the padding
% that I used.

for col = 1:padded_rows - 2
    for row = 1:padded_columns - 2
        % Apply the transformation here, defined by the equation of the
        % laplacian
        image_data_with_filter_applied(row, col) = sum(sum(laplace_filter .* padded_image_data(row:row + 2, col:col + 2)));
    end
end

sharpened_image = image_data_with_filter_applied - image_data;

% Display the results side by side.
imshowpair(image_data, sharpened_image, 'montage');

% Code to save the image
% ===========================
% First of all ask if user wants to save image.
choice = questdlg('Would you like to save the image for further enhancements?', 'Further Enhancements', 'Yes', 'No');
% Handle response
switch choice
    
    case 'Yes'
        % Open a dialog to save image.
        [filename, pathname] = uiputfile({'*.*', 'All Files' }, 'Save Image');
        file_id = fopen([pathname filename], 'w');
        fwrite(file_id, sharpened_image, 'float');
        fclose(file_id);
        
    case 'No'
end