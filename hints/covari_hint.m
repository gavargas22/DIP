%program for doing covariance and correlation matrices

clear 
clc

fid = fopen( 'test_ms.img') ;
myimage = fread( fid , inf , 'uint8' ) ;
fclose( fid ) ;

numcol = 1400 ;
numrow = 1400 ;
numband = 9 ;
n = numcol .* numrow ;
q = 2 ;

myimage2 = reshape( myimage , numcol , numrow .* numband ) ;
myimage2 = myimage2' ;

%calculate means and standard deviations for each image

previous = 0 ;
for l = 1 : numband
   begin = previous + 1 ;
   ending = begin + ( numrow - 1 ) ;
   band = myimage2( begin : ending , : ) ;
   sdev( l ) = std( band( : ) ) ; 
   previous = ending ;
   clear band
end

clear previous begin ending 

%determine number of possible band combinations

howmany = factorial( n ) ./ ( factorial( q ) .* factorial( n - q ) ) ;

%calculate covariance matrix and correlation matrix

previous1 = 0 ; 
for j = 1 : numband
    begin1 = 
    ending1 =
    band1 =
    previous2 = 0 ;
    for k = 1 : numband
        begin2 = 
        ending2 = 
        band2 = 
        sp =    
        cv( k , j ) = 
        r( k , j ) = 
        previous2 = 
    end
    previous1 = ending1 ;
end

cv
r