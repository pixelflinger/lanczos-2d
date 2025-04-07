function y = linear_chirp(t, f0, t1, f1, phi0_deg)
%CUSTOM_LINEAR_CHIRP Generates a linear chirp signal without toolbox dependency.
%
% Syntax:
%   y = custom_linear_chirp(t, f0, t1, f1)
%   y = custom_linear_chirp(t, f0, t1, f1, phi0_deg)
%
% Description:
%   Generates a signal y evaluated at the time points specified in vector t.
%   The signal's instantaneous frequency sweeps linearly according to the
%   ideal definition: starting at f0 Hz at time 0 and reaching f1 Hz at time t1.
%
% Inputs:
%   t        - Time vector (seconds). Determines the points where the chirp
%              is sampled. Can be a row or column vector.
%   f0       - Instantaneous frequency at time t=0 (Hz). Must be scalar.
%   t1       - Time at which the frequency ideally reaches f1 (seconds).
%              Must be a positive scalar.
%   f1       - Instantaneous frequency at time t=t1 (Hz). Must be scalar.
%   phi0_deg - Initial phase in degrees (optional, default = 0). Scalar.
%
% Output:
%   y        - Output chirp signal, evaluated at times 't'. Same size as t.
%
% Note:
%   This function evaluates the ideal chirp defined by f0, f1, t1 at the
%   specific time points provided in the vector 't'. The start/end times
%   of the vector 't' do not alter the definition of the frequency sweep,
%   which always conceptually starts at time 0 with frequency f0.

% --- Input Argument Handling & Validation ---
if nargin < 4
    error('custom_linear_chirp:NotEnoughInputs', 'Requires at least t, f0, t1, f1.');
end
if nargin < 5 || isempty(phi0_deg)
    phi0_deg = 0; % Default initial phase is 0 degrees
end

if ~isvector(t)
    error('custom_linear_chirp:InvalidInput', 'Input ''t'' must be a vector.');
end
if ~isscalar(f0) || ~isscalar(t1) || ~isscalar(f1) || ~isscalar(phi0_deg)
    error('custom_linear_chirp:InvalidInput', 'Inputs f0, t1, f1, and phi0_deg must be scalar values.');
end
if t1 <= 0
   if f0 == f1
       % If t1 is zero/negative but frequencies are the same, treat as constant frequency
       k = 0;
       warning('custom_linear_chirp:ZeroT1', 't1 <= 0 specified; treating as constant frequency f0=f1=%.2f Hz.', f0);
   else
        error('custom_linear_chirp:InvalidInput', 'Input ''t1'' must be positive if f0 and f1 differ.');
   end
else
    % Calculate the rate of frequency change (slope)
    k = (f1 - f0) / t1;
end

% --- Chirp Calculation ---

% Convert initial phase from degrees to radians
phi0_rad = phi0_deg * pi / 180;

% Calculate the instantaneous phase for each time point in t
% phase(t) = 2*pi * (f0*t + (k/2)*t^2) + phi0_rad
% Use element-wise operators .* and .^ for the vector t
instantaneous_phase = 2 * pi * (f0 .* t + (k / 2) .* t.^2) + phi0_rad;

% Generate the chirp signal by taking the cosine of the phase
y = cos(instantaneous_phase);

% Ensure output orientation matches input t orientation
if size(t, 1) > 1 % if t is a column vector
    y = y(:); % Make y a column vector
else           % t is a row vector or scalar
    y = y(:).'; % Make y a row vector
end

end