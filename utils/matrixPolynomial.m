% MATRIXPOLYNOMIAL Computes the matrix polynomial given a square matrix and polynomial coefficients.
%
%   Am = matrixPolynomial(A, poly_coeff) returns the matrix polynomial Am
%   for the square matrix A and the vector of polynomial coefficients poly_coeff.
%
%   Inputs:
%       A          - A square matrix (n x n).
%       poly_coeff - A vector containing the coefficients of the polynomial.
%
%   Outputs:
%       Am - The resulting matrix polynomial.
%
%   Example:
%       A = [1 2; 3 4];
%       poly_coeff = [1, 0, -1]; % Corresponds to the polynomial A^2 - I
%       Am = matrixPolynomial(A, poly_coeff);
%
%   Notes:
%       - The input matrix A must be a square matrix.
%       - The input poly_coeff must be a vector.
function Am = matrixPolynomial(A, poly_coeff)
    % Check whether A is a square matrix
    if size(A, 1) ~= size(A, 2)
        error('The input matrix A must be a square matrix.');
    end
    
    % Check the polynomial coefficients
    if ~isvector(poly_coeff)
        error('The input poly_coeff must be a vector.');
    end
    
    % Initialize the matrix polynomial
    Am = zeros(size(A));
    I = eye(size(A));
    
    % Calculate the matrix polynomial
    for i = 1:length(poly_coeff)
        Am = A*Am + poly_coeff(i) * I;
    end
end