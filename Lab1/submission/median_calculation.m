% The median of a data set is the middle number
% If the dataset contains an odd number of values
% then the median is exactly the middle number.
% 
% If the dataset contains an even number of values
% the median is the average of the two middle values

function median_output = median_calculation(x)
    median_output = 0;
    % Firstly sort the values in the 1x1 array given to start work.
    sorted_values = sort(x);
    % Save size of array for future use.
    array_length = length(x);
    % Check if the array has an even or odd number of values by taking the modulus divided by two.
    parity = mod(length(sorted_values), 2);
    % Start the process of getting the median.
    % If the parity of the modulus result is not equal to 0 the parity of the values given is even.
    if ~(parity == 0)
        %Take the size of the array given, substract one and divide by two, to the result add one and go to the index of the array at the result.
        index_at = ((array_length - 1)/2) + 1;
        % The median is the value located at the index: index_at
        median_value = sorted_values(index_at)
    else
        % We first get the index of the value to the left of the median.
        index_of_left_number_near_the_middle = (array_length/2);
        % We then get the index of the value to the right of the median.
        index_of_right_number_near_the_middle = (index_of_left_number_near_the_middle + 1);
        % Put these two values in an array.
        indices = [index_of_left_number_near_the_middle index_of_right_number_near_the_middle];
        % Get the mean of the values at the two indices.
        median_value = (sorted_values(index_of_left_number_near_the_middle) + sorted_values(index_of_right_number_near_the_middle))/(length(indices))
    end
    
end