%Example of using loops
%(and some other useful things)

clear
clc

i = 0 ;
j = 0 ;

A = zeros( 1000 ) ;

while i <= 1000

	disp( ‘This is my ‘ , num2str( i ) , ‘ time through the while loop!‘ )

	n = 5 ; %a constant we will use below

	for j = 1 : n : 1000
	
		str = sprintf( ‘This is my %d through the for loop!’ , j ) ;
		disp( str ) ;

		k = i + j ;
	
		A( i , j ) = k ;

	end %end of the for loop; note the indenting

	i = i + 1 ;
	
end % end of the while loop; note the indenting
