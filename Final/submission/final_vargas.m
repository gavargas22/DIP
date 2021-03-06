% Guillermo Vargas
% Final MATLAB section

% Clear everything
clear
% Tell user a message so that they know what is happening next.
warning('Lets start... Open up the UV light visible JPG... thanks!');
% Lets get the image from the user
[FileName,PathName] = uigetfile('*','Open the UV light RGB JPG.');

blacklight_image_data = imread([PathName FileName]);
% Save memory by removing useless Scheisse.
clear FileName PathName;

% Obtain sizes of image
[blacklight_image_rows, blacklight_image_columns, blacklight_number_of_channels] = size(blacklight_image_data);
% Convert the original image to uint8 to use it later on.
double_converted_non_grey_scale_blacklight_image_data = im2double(blacklight_image_data);
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
% Save memory by removing useless Scheisse.
clear save_filename save_path;

% Tell user a message so that they know what is happening next.
warning('Up next... navigate to open the star night sky of mars image in JPG format.');
% I now open the star only image to apply noise cleansing to it.
[FileName, PathName] = uigetfile('*','Select the starry night image file.');
% Store the data in a matrix.
starry_night_image_data = imread([PathName FileName]);
% Convert to double precision  for calculations.
double_converted_starry_night_data = im2double(starry_night_image_data);
% Save memory by removing useless Scheisse.
clear FileName PathName;


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
% Save memory by removing useless Scheisse.
clear save_filename save_path;


% ===========================================
% Remove the noise now from the image of the UV light.
% Create empty matrix to store the cleaned up UV image.
noise_substracted_uv_light_rgb = zeros(blacklight_image_rows, blacklight_image_columns, blacklight_number_of_channels);
for channel = 1:blacklight_number_of_channels
    noise_substracted_uv_light_rgb(:, :, channel) = double_converted_non_grey_scale_blacklight_image_data(:, :, channel) - binary_noise_result;
end

% Now the resulting image, we apply a median filter to remove the zero points where the noise was.
% I pad the image to apply a transformation
% padded_noise_substracted_uv_light_rgb = padarray(noise_substracted_uv_light_rgb, 1, ones(3,3));
integer_uv_image_with_zeros = im2uint8(noise_substracted_uv_light_rgb);
% Create an empty matrix to store the filtered and averaged UV image
linearly_averaged_resultant_of_uv_image = im2uint8(zeros(blacklight_image_rows, blacklight_image_columns, blacklight_number_of_channels));
% Do channel by channel to get RGB
for channel =  1:blacklight_number_of_channels
    for col = 11:blacklight_image_columns - 10
        for row = 11:blacklight_image_rows - 10
            % If I find an area where the noise has been zeroed...
            if integer_uv_image_with_zeros(row, col, channel) < 2
                % Take a look 10 steps left and right of the current
                % location and average the values...
                linearly_averaged_resultant_of_uv_image(row, col, channel) = mean([integer_uv_image_with_zeros(row, col-1:col - 10, channel) integer_uv_image_with_zeros(row, col+1:col + 10, channel)]);
            else
                % If there is no noise zeroed, then just pull the original
                % value of brightness.
                linearly_averaged_resultant_of_uv_image(row, col, channel) = integer_uv_image_with_zeros(row, col, channel);
            end
        end
    end
    % Finally yo give it an even better filtering action, apply a
    % medianfilter.
    linearly_averaged_resultant_of_uv_image(:, :, channel) = medfilt2(linearly_averaged_resultant_of_uv_image(:, :, channel));
end
% Now I save the JPG
% Tell user a message so that they know what is happening next.
warning('Up next... save the averaged and filtered UV image as a JPG. Please choose a name!');
[save_filename, save_path] = uiputfile({'*.jpg*', 'JPG' }, 'Save the averaged and filtered UV image JPG');
% Save it
imwrite(linearly_averaged_resultant_of_uv_image, [save_path save_filename], 'jpg');
% Save memory by removing useless Scheisse.
clear save_filename save_path;


% Compare the two images!
% I use a simple approach, that of using a mathematical divison between the values of both images to each other.

% First, open the visible light image
% Tell user a message so that they know what is happening next.
warning('Navigate to load up the visible image');
% Lets get the image from the user
[FileName,PathName] = uigetfile('*','Open the visible light RGB JPG.');
% Open it and store it in memory
visible_light_image_data = imread([PathName FileName]);
% Save memory by removing useless Scheisse.
clear FileName PathName;
% Obtain sizes of image
[visible_image_rows, visible_image_columns, visible_image_number_of_channels] = size(visible_light_image_data);
% I proceed to resize the UV image, I noticed that the aspect ratio is exactly the same for both images! 1.36
resized_averaged_uv_light_image = imresize(linearly_averaged_resultant_of_uv_image, [visible_image_rows NaN]);


% The image is not really badly damaged in terms of noise so just apply a simple median filter.
for channel = 1:visible_image_number_of_channels
    visible_light_image_data(:, :, channel) = medfilt2(visible_light_image_data(:, :, channel));
end
% Save the median filtered visible image as JPG.
warning('Up next... save the visible median filtered image. Please choose a name!');
[save_filename, save_path] = uiputfile({'*.jpg*', 'JPG' }, 'Save the visible median filtered image JPG');
imwrite(visible_light_image_data, [save_path save_filename], 'jpg');
% Clear memory
clear save_filename save_path;


% Convert to double precisions both images
double_resized_uv = im2double(resized_averaged_uv_light_image);
double_resized_visible = im2double(visible_light_image_data);

% Do a simple division for all the channels of the image
% Store the results in an empty matrix.
simple_division_uv_and_visible_results = zeros(visible_image_rows, visible_image_columns, visible_image_number_of_channels);
for channel = 1:visible_image_number_of_channels
    simple_division_uv_and_visible_results(:, :, channel) = double_resized_uv(:, :, channel) - double_resized_visible(:, :, channel) ./ double_resized_visible(:, :, channel) + double_resized_uv(:, :, channel);
end
% I apply also greyscale index operations to see if we can get anything useful.
ratio_one = rgb2gray(double_resized_visible) - rgb2gray(double_resized_uv) ./ rgb2gray(double_resized_visible) + rgb2gray(double_resized_uv);
ratio_two = rgb2gray(double_resized_uv) - rgb2gray(double_resized_visible) ./ rgb2gray(double_resized_uv) + rgb2gray(double_resized_visible);

% Save the images as JPG, the ratios.
% Tell user a message so that they know what is happening next.
warning('Up next... save the ratios between the visible and UV. Please choose a name!');
[save_filename, save_path] = uiputfile({'*.jpg*', 'JPG' }, 'Save the ratios between the visible and UV image JPG');
% Save all the ratios, the rgb and greyscale!
imwrite(im2uint8(ratio_one), [save_path save_filename], 'jpg');
imwrite(im2uint8(ratio_two), [save_path 'ratio_two.jpg'], 'jpg');
imwrite(im2uint8(simple_division_uv_and_visible_results), [save_path 'ratio_rgb.jpg'], 'jpg');
% Save memory by removing useless Scheisse.
clear save_filename save_path;

% Take a look at the RGB ratio, it looks pretty interesting!

