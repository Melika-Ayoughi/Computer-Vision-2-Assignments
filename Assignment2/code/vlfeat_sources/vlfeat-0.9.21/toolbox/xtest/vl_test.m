function results = vl_test(varargin)	 % DOCSTRING_GENERATED
 % VL_TEST		 [add function description here]
 % INPUTS 
 %			varargin = ..
 % OUTPUTS 
 %			results = ..


% VL_TEST  Run test suite
%  RESULTS = VL_TEST() runs all VLFeat test suites. The tests
%  verify that VLFeat is working correctly.
%
%  RESULTS is a structure listing the result of each test,
%  as generated by the MATLAB Unit Test framework. failed
%
%  VL_TEST(PAR,VAL,...) supports the following options:
%
%  Break:: false
%    Set to true to break on failure.
%
%  TapFile:: []
%    Specify an optional TAP file to record the test results.
%
%  Command:: []
%    Specify an optional prefix for the test command to run.
%    For example, `vl_test('command','vl_test_aib')` only runs
%    the `vl_test_aib` tests.

% Author: Andrea Vedaldi

% Copyright (C) 2013-14 Andrea Vedaldi.
% Copyright (C) 2007-12 Andrea Vedaldi and Brian Fulkerson.
% All rights reserved.
%
% This file is part of the VLFeat library and is made available under
% the terms of the BSD license (see the COPYING file).

opts.break = false ;
opts.tapFile = [] ;
opts.command = 'vl_test_' ;
opts = vl_argparse(opts,varargin) ;

import matlab.unittest.constraints.* ;
import matlab.unittest.selectors.* ;
import matlab.unittest.plugins.TAPPlugin;
import matlab.unittest.plugins.ToFile;

% Choose which tests to run
sel = HasName(StartsWithSubstring(opts.command)) ;

% Run tests
suite = matlab.unittest.TestSuite.fromFolder(fullfile(vl_root,'toolbox','xtest'),sel) ;
runner = matlab.unittest.TestRunner.withTextOutput('Verbosity',3);
if opts.break
  runner.addPlugin(matlab.unittest.plugins.StopOnFailuresPlugin) ;
end
if ~isempty(opts.tapFile)
  if exist(opts.tapFile, 'file')
    delete(opts.tapFile);
  end
  runner.addPlugin(TAPPlugin.producingOriginalFormat(ToFile(opts.tapFile)));
end
result = runner.run(suite);
display(result)
