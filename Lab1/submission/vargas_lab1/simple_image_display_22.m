% Open up an image at th test path
% C:\Users\gavargas\Developer\DIP\Lab1\test

% A function that takes in two arguments, the name of the image and the
% size of the desired subset.

function image_display = simple_image_display(width, height) 
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
end