function lastFourDigits = getLastFourDigits(inputString)
    % Extract all digits from the input string
    digits = regexp(inputString, '\d', 'match');
    
    % Convert digits to numbers
    digits = str2double(digits);
    
    % Get the last four digits
    if length(digits) >= 4
        lastFourDigits = digits(end-3:end);
    else
        lastFourDigits = digits;
    end
end