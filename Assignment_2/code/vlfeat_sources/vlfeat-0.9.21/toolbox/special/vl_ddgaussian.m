function y = vl_ddgaussian(x)	 % DOCSTRING_GENERATED
 % VL_DDGAUSSIAN		 [add function description here]
 % INPUTS 
 %			x = ..
 % OUTPUTS 
 %			y = ..


% VL_DDGAUSSIAN Second derivative of the Gaussian density function
%   Y=VL_DDGAUSSIAN(X) computes the second derivative of the standard
%   Gaussian density.
%
%   To obtain the second derivative of the Gaussian density of
%   standard deviation S, do
%
%     Y = 1/S^3 * VL_DDGAUSSIAN(X/S) .
%
%   See also: VL_GAUSSIAN(), VL_DGAUSSIAN(), VL_HELP().

% Copyright (C) 2007-12 Andrea Vedaldi and Brian Fulkerson.
% All rights reserved.
%
% This file is part of the VLFeat library and is made available under
% the terms of the BSD license (see the COPYING file).

y = (x.^2 - 1)/sqrt(2*pi) .* exp(-0.5*x.^2) ;
