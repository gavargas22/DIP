clear %clear memory
clc %clear the display

n = 1 ; %size of the matrix we will create

x = rand( n ) ;

x = 10 .* x ;

x = round( x ) ; %round to nearest integer

x %just prints x to the display so that we can see it

if x == 0

	disp( ‘This number is exactly 0!’ )
	
	y = x + 10 ; %we can do something random here

elseif x > 0 && x < 5

	disp( ‘This number is smaller than 5 (but not 0)!’ )
	
	y = x .* exp( i .* pi ) ; %exponentials… too easy!

elseif x == 5 %checks if x is exactly equal to 5
	
	disp( ‘This number is exactly 5!’ )
	
	y = sqrt( x ) ; %square root… why not?

elseif x > 5 %checks if x is greater than 5
	
	disp( ‘This number is greater than 5!’ )
	
	y = ( ( 2 .* x ) .^ 2 ) + x ; %quadratic… yawn

else

	disp( ‘I should never get here… but here I am! ‘ )
	
	y = 1e6 ;

end