function image_display = simple_image_statistics(file, width, height) 
    % file_id = fopen(strcat('..\test\', image_name, extension), 'r', 'l');
    file_id = fopen(file, 'r', 'l');
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
    median_calculation(image_subset)
end