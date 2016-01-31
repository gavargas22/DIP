function image_display = simple_image_statistics(width, height) 
    % file_id = fopen(strcat('..\test\', image_name, extension), 'r', 'l');
    file_id = fopen('C:\Users\gavargas\Developer\DIP\Lab1\test\test.img', 'r', 'l');
    image_subset = fread(file_id, [width, height], 'uint8');
    figure(1);
    hold off;
    imagesc(image_subset');
    fclose(file_id);
    axis image;
    title('Test Image');
    xlabel('column');
    ylabel('row');
    hold on;
    
    % Now get the statstics out of it.
    % Mean of pixel values
    mean = sum(sum(image_subset))/numel(image_subset)
    % Standard Deviation
    array_into_row = image_subset(:)';
    stdev = sqrt((sum((array_into_row - mean) .^ 2)) ./ (numel(image_subset)))
    % Median pixel value, I use the function defined in the
    % median_calculation M file.
    mean = median_calculation(image_subset)
    
    % Finally write the image, make sure to give the dimensions.
    slice_image_and_save(100, 100, image_subset);
    
    % 100x100 px subset
    function image_cutout = slice_image_and_save(width, height, original_file)
        write_file_id = fopen('C:\Users\gavargas\Developer\DIP\Lab1\submission\test_subset_envi.img', 'wb');
        written_image_subset = fread(original_file, [width, height], 'uint8')';
        fwrite(write_file_id, written_image_subset, 'int16');
        fclose(write_file_id);
    end
end