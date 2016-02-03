%Example of using loops
%(and some other useful things)

clear
clc

i = 0 ;
j = 0 ;
%i and j are counters that we have created and initialized to 0
%loops work by counting and incrementing these counters
%each time through the loop, the counter(s) should be changed
%when the counter reaches the right value, it triggers a behavior

A = zeros( 1000 ) ;
%we make a big 1000 x 1000 matrix of zeros to put stuff into later

while i <= 1000
%i started at 0 and we do whatever is in this loop until i is 1000

	disp( ‘This is my ‘ , num2str( i ) , ‘ time through the while loop!‘ )
	%what does this do? look up disp and num2str…

	n = 5 ; %a constant we will use below

	for j = 1 : n : 1000
	%this for loop is nested within the while loop
	%this entire for loop is done in each while iteration
	%j is reinitialized to 1 and increments by n each time
	%the for loop terminates when j reaches (or exceeds) 1000

		str = sprintf( ‘This is my %d through the for loop!’ , j ) ;
		disp( str ) ;
		%what does this do? see the help for disp…

		k = i + j ;
		%some random, meaningless math using our counters
		%more commonly, the counters are used to index (see 19)
		%like this…

		A( i , j ) = k ;
		%we store our meaningless math result in specific location

	end %end of the for loop; note the indenting

	i = i + 1 ;
	%this is a critical line
	%it increments i by 1 each time through the while loop
	%what would happen if we didn’t do this?

end % end of the while loop; note the indenting
