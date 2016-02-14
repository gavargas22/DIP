%for opening a n x n unsigned integer 8 bit envi file
fid = fopen( 'myfile' , 'r' , 'l' ) ;
myimage = fread( fid , [ 1400 , 1400 ] , 'uint8' ) ;
fclose( fid ) ;
myimage = myimage' ;

%solves permissions problem
%note that this also includes an alternative to specifying the rows and
%columns, but requires the image to be reshaped after opening...
fid = fopen( 'myfile') ;
myimage = fread( fid , inf , 'uint8' ) ;
fclose( fid ) ;

%reshaping for BSQ image
myimage2 = reshape( myimage , envi_columns , envi_rows .* envi_bands ) ;
myimage2 = myimage2' ;
myimage2_band1 = myimage2( 1 : envirows , : ) ;

%plot image
figure( 1 )	            % Makes a new figure window.
hold off		        % Allows the figure to be overwritten.
imagesc( myimage ) 	    % Plots the image.
colormap( pink )	    % Sets the colormap.
axis image		        % Formats the axes.
title( ' My Image  ' )	% Sets the title.
xlabel( ' column ' )	% Labels the x axis
ylabel( ' row ' )		% Labels the y axis
hold on		            % Prevents the figure from being overwritten.

%save image to envi compatible format
myimage = myimage' ;
fid = fopen( 'outputfilename' , 'wb' ) ;
fwrite( fid , myimage , 'int16' ) ;
fclose( fid ) ;
