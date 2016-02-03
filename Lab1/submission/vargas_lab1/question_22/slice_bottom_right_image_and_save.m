% Guillermo Vargas

% To run this function you have to give the size desired for the output
% image as well as the name desired for the output file, that argument
% should be given in '' since it is a string. In the lab's example we get a
% 100x100 image so comment line 7 if a custom size is desired.

function resulting_image = slice_bottom_right_image_and_save()
    width = 100; height = 100; output_name = 'slice';
    % Firstly we get the original image and put it a variable
    original_file_id = fopen('test\test.img', 'r', 'l');
    % Put all the data of the image in a variable 
    original_image_matrix = fread(original_file_id, [1400, 1400], 'uint8');
    % Size of the matrix to generate the output.
    [original_rows, original_columns] = size(original_image_matrix);
    % We then extract the lower right section according to the size given
    % in the arguments of the function.
    image_cutout = original_image_matrix((original_rows - height):(original_rows), (original_columns - width):(original_columns));
    % Write the subset to the file name given in the argument.
    to_write_file_id = fopen([output_name '.img'], 'wb');
    % Finally just write the data, ready for ENVI.
    fwrite(to_write_file_id, image_cutout, 'int16');
    
    % Display the image.
    new_image_file = fopen([output_name '.img'], 'r', 'l');
    new_image_data = fread( new_image_file, [width + 1 , height + 1] , 'uint8')';
    
    fclose(new_image_file);
    
    figure(1);
    hold off;
    imagesc(new_image_data);
    colormap(pink);
    axis image;
    title(output_name);
    xlabel('column');
    ylabel('row');
    hold on;
    % Close up original file id
    fclose(to_write_file_id);
    
end