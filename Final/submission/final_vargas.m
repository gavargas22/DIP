% Guillermo Vargas
% Final MATLAB section

% Clear everything
clear
% Lets get the image from the user
[FileName,PathName] = uigetfile('*','Select the image file to apply transformation to.');

blacklight_image_data = imread([PathName FileName]);

% Obtain sizes of image
[blacklight_image_rows, blacklight_image_columns, blacklight_number_of_channels] = size(blacklight_image_data);
% Convert the RGB image to grayscale.
grayscale_blacklight_image_data = rgb2gray(blacklight_image_data);
% Convert the uint to double to perform caluclations on the values.
double_converted_blacklight_image_data = im2double(grayscale_blacklight_image_data);

% I proceed to find the locations of anomalies, I will be using one channel
% of the visible picture and one channel of the blacklight picture.

% % Lets get the image from the user
% [FileName,PathName] = uigetfile('*','Select the visible light image.');
% 
% visible_light_image_data = imread([PathName FileName]);
% 
% % Obtain sizes of image
% [visible_image_rows, visible_image_columns, visible_number_of_channels] = size(visible_light_image_data);
% % Conver the uint to double to perform caluclations on the values.
% double_converted_visible_image_data = im2double(visible_light_image_data);

% Apply a lapciaan filter so that we can detect the most likely locations
% of the noise.
% =========================
% Create the filter.
default_laplacian_filter = fspecial('laplacian');
% Apply filter to the red channel of the original image.
blacklight_filter_out = imfilter(double_converted_blacklight_image_data, default_laplacian_filter, 'replicate');
% I get an image with mostly the noise, so save it ino JPEG
% ========
% Covnert the data into uint8 for image saving.
integer_filter_result_image = im2uint8(blacklight_filter_out);
[save_filename, save_path] = uiputfile({'*.jpg*', 'JPG' }, 'Save Noise Only Image');
% Save it
imwrite(integer_filter_result_image, [save_path save_filename]);