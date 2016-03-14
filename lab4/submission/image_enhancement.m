% Guillermo Vargas
% March 12, 2016

% This code will apply certain enhancements to the NASA images.
% First, we select the image that we want to analyze through a dialog
[FileName,PathName] = uigetfile('.JPG', 'Select the image to apply enhacements to.');
% Get the useful full name and path of the image on a variable
full_path_with_name = [PathName FileName];
% Get information about the image in question, save it into useful
% variables to use later.
information_about_image = imfinfo(full_path_with_name);
image_rows = information_about_image.Height;
image_columns = information_about_image.Width;
% I set a variable to the number of total items in the image for future
% use.
total_number_of_pixels = image_rows * image_columns;

% Now open up the image
image_data = imread(full_path_with_name);

% Get statstics from the image.
image_data_median = median(median(image_data));
image_data_standard_deviation = std2(image_data);

% Display the histogram using MATLAB's functions
imhist(image_data);

% Start doing the enhancements.
% First, we do the enhancement of the darkest spots of the images.

% ENhance lightests parts of the image

% Histogram Equalization

% Mean and standard deviation of all the images.