% 100x100 px subset
function resulting_image = slice_bottom_right_image_and_save(width, height, output_name)
    % Firstly we get the original image and put it a variable
    original_file_id = fopen('test\test.img', 'r', 'l');
    original_image_matrix = fread(original_file_id, [1400, 1400], 'uint8');
    % We then extract the lower right section according to the size given.
    image_cutout = original_image_matrix((length(original_image_matrix) - width):(length(original_image_matrix)), (length(original_image_matrix) - height):(length(original_image_matrix)));
    % Write the subset to the file name given...
    to_write_file_id = fopen([output_name '.img'], 'wb');
    % Finally just write the data.
    fwrite(to_write_file_id, image_cutout, 'int16');
    % Finish up by closing the file, ready for use.
    
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