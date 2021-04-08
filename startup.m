function startup
	path(pathdef)
	
	f = mfilename('fullpath');
	[d, ~, ~] = fileparts(f);
	addpath(fullfile(d, 'src'));
end