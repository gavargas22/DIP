% Guillermo Vargas

% A function that takes in two arguments, the name of the image and the
% size of the desired subset. In the case of this image, its just 1400x1400
% comment line 9 if it is desired to give a specific size.

function image_display = simple_image_display()
    % Set the width and height.
    width = 1400; height = 1400;
    % Give a reference number to the file and open from disk.
    file_id = fopen('test\test.img', 'r', 'l');
    % Get a subset of the desired size, the size given on line 9.
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
end