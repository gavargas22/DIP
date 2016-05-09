% Guillermo Vargas
% Final MATLAB section

% Clear everything
clear
% Tell user a message so that they know what is happening next.
warning('Lets start... Open up the UV light visible JPG... thanks!', 'modal');
% Lets get the image from the user
[FileName,PathName] = uigetfile('*','Open the UV light RGB JPG.');

blacklight_image_data = imread([PathName FileName]);

% Obtain sizes of image
[blacklight_image_rows, blacklight_image_columns, blacklight_number_of_channels] = size(blacklight_image_data);
% Convert the RGB image to grayscale.
grayscale_blacklight_image_data = rgb2gray(blacklight_image_data);
% Convert the uint to double to perform caluclations on the values.
double_converted_blacklight_image_data = im2double(grayscale_blacklight_image_data);


% Apply a lapciaan filter so that we can detect the most likely locations
% of the noise.
% =========================
% Create the filter.
default_laplacian_filter = fspecial('laplacian', 0.1);
% Apply filter to the red channel of the original image.
blacklight_filter_out = imfilter(double_converted_blacklight_image_data, default_laplacian_filter, 'replicate');
% I get an image with mostly the noise
% ========
% Now I apply a dilation operation to make the noise more clear.
dilation_structural_element = strel('square', 3);
dilated_noise_result = imdilate(blacklight_filter_out, dilation_structural_element);
% Tell user a message so that they know what is happening next.
warning('Up next... save the image of the noise only as JPG, please choose where you want to save it.');
% Convert the data into uint8 for image saving and other processing
integer_dilated_filter_result_image = im2uint8(dilated_noise_result);
[save_filename, save_path] = uiputfile({'*.jpg*', 'JPG' }, 'Save Noise Only Image');
% Save it
imwrite(integer_dilated_filter_result_image, [save_path save_filename], 'jpg');

% Tell user a message so that they know what is happening next.
warning('Up next... navigate to open the star night sky of mars image in JPG format.');
% I now open the star only image to apply noise cleansing to it.
[FileName, PathName] = uigetfile('*','Select the starry night image file.');
% Store the data in a matrix.
starry_night_image_data = imread([PathName FileName]);
% Convert to double precision  for calculations.
double_converted_starry_night_data = im2double(starry_night_image_data);


% Now I expand the noise to be binary to delete the noise pixels
binary_noise_result = im2bw(dilated_noise_result, 0.35);
% Convert binary to uint8 to remove the noise from the RGB image.
integer_converted_binary_noise_result = im2uint8(binary_noise_result);
% I start with the starry night image
% I create an empty matrix with n channels to store the substraction in RGB
noise_substracted_starry_night_rgb = zeros(blacklight_image_rows, blacklight_image_columns, blacklight_number_of_channels);
% Substract the noise out of the starry night image channel by channel.
for channel = 1:blacklight_number_of_channels
    noise_substracted_starry_night_rgb(:, :, channel) = double_converted_starry_night_data(:, :, channel) - binary_noise_result;
end
% Convert the data into uint8 for image saving.
% Tell user a message so that they know what is happening next.
warning('Up next... save the starry night sky without noise that was just created as a JPG. Please choose a name!');
integer_converted_noise_substracted_starry_night_rgb = im2uint8(noise_substracted_starry_night_rgb);
[save_filename, save_path] = uiputfile({'*.jpg*', 'JPG' }, 'Save the starry night JPG');
% Save it
imwrite(integer_converted_noise_substracted_starry_night_rgb, [save_path save_filename], 'jpg');


% ===========================================
% Remove the noise now from the image of the UV light.

