% A function that takes in two arguments, the name of the image and the
% size of the desired subset. In the case of this image, its just 1400x1400
% comment line 6 if it is desired to give a specific size.

function image_display = simple_image_display()
    width = 1400; height = 1400;
    file_id = fopen('test\test.img', 'r', 'l');
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