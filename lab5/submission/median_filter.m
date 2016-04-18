% Guillermo Vargas
% 2D Median Filter Operation
% April 5,2016

% This code will apply certain transformations to the image selected.

% First, we select the image that we want to analyze through a dialog
[FileName,PathName] = uigetfile('*', 'Select the image to apply transformation to.');

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

% Gather information about the 2D filter that we will do.
filter_information_promt = {'Enter kernel row size:','Enter kernel column size:'};
filter_information_dialog_title = 'Kernel Size Information';
default_kernel_size = {'3', '3'};
user_gathered_kernel_information = inputdlg(filter_information_promt, filter_information_dialog_title, 1, default_kernel_size);
% We store in matrix the obtained strings and convert them to numbers.
kernel_information = str2double(user_gathered_kernel_information(:)');
kernel_rows = kernel_information(1);
kernel_columns = kernel_information(2);

% Now we use MATLAB to do a spatial filtering.
filtered_image = medfilt2(image_data, [kernel_rows kernel_columns]);

% Display the results side by side.
imshowpair(image_data, filtered_image, 'montage');

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
        fwrite(file_id, filtered_image, 'float');
        fclose(file_id);
        
    case 'No'
end

