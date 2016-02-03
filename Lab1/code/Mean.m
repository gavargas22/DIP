function [ mean , stdev ] = stat( x )
% Comments look like this (they start with a percent sign).
% They are not interpreted by MATLAB – they are ignored.
% They are handy for putting notes in your program.
% The "function" line above defines your program
% as a function that accepts input (x) and
% returns two outputs (mean and stdev).
% The name of the function is stat.
% You invoke the program by typing stat(x) at the
% command line. The program will then compute
% the mean and standard deviation of x.
% The next line returns the number of rows and
% columns in x.
[ m , n ] = size( x ) ;
% Below is a structure called an if-then-else
% statement. The double equal sign does not
% assign a value to m. It is a test of equality.
% Indenting makes your program easier to read.
if m == 1
m = n ;
end
% What do you think these next two lines do?
% What about the lack of semicolons?
mean = sum( x ) ./ m
stdev = sqrt( ( sum( ( x - mean ) .^ 2 ) ) ./ ( m ) )
% At this point the program stops and will have
% returned two values, the mean and standard deviation.