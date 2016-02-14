%Example of using an if-(else)-then statement
%(and some other useful things)

clear %clear memory
clc %clear the display

n = 1 ; %size of the matrix we will create
%keep it n = 1 for this program to work
%would need modification if we chose other values for n

x = rand( n ) ;
%generates n x n matrix containing numbers between 0 and 1

x = 10 .* x ;
%multiply by 10 to get a number between 1 and 10

x = round( x ) ; %round to nearest integer

x %just prints x to the display so that we can see it

if x == 0
%this checks if x is exactly equal to 0
%it does not set x equal to 0
	disp( ‘This number is exactly 0!’ )
	%prints a message to the screen
	y = x + 10 ; %we can do something random here

elseif x > 0 && x < 5
%checks if x is greater than 0 AND if it is less than 5
%note the use of relational (>, < in this case)
%and logical operators (AND in this case)
%OR would be written:||
%==, >, <, >=, <= are all valid relational operators
	disp( ‘This number is smaller than 5 (but not 0)!’ )
	y = x .* exp( i .* pi ) ; %exponentials… too easy!

elseif x == 5 %checks if x is exactly equal to 5
	disp( ‘This number is exactly 5!’ )
	y = sqrt( x ) ; %square root… why not?

elseif x > 5 %checks if x is greater than 5
	disp( ‘This number is greater than 5!’ )
	y = ( ( 2 .* x ) .^ 2 ) + x ; %quadratic… yawn

else
%I’m not sure what other case there can be…
%but this covers the unexpected!
	disp( ‘I should never get here… but here I am! ‘ )
	y = 1e6 ;
	%say this number with your pinky to your mouth

end
%all flow control structures must have an end
%also note the indenting used in this program
%(omitting the comments makes the indenting clearer)
