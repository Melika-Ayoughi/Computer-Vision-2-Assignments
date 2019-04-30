function x = vl_isoctave()	 % DOCSTRING_GENERATED
 % VL_ISOCTAVE		 [add function description here]
 % INPUTS 
 % OUTPUTS 
 %			x = ..


% VL_ISOCTAVE   Determines whether Octave is running
%   X = VL_ISOCTAVE() returns TRUE if the script is running in the
%   Octave environment (instead of MATLAB).

persistent y ;

if isempty(y)
  y = exist('OCTAVE_VERSION','builtin') ~= 0 ;
end

x = y ;
