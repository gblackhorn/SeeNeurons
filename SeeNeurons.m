function [neuronsList,varargout] = SeeNeurons(binaryMatrix,varargin)
	% This function finds out neurons in a given binary image based on
	% diameter threshold (diaThreshold) and circularity threshold (cirThreshold)

	% Example:
	%		

	% Defaults
	diaThreshold = 40; % unit: pixel
	cirThreshold = 0.6; % ranges from 0 (for a completely irregular shape) to 1 (for a perfect circle)

	% Optionals
	for ii = 1:2:(nargin-1)
	    if strcmpi('diaThreshold', varargin{ii}) % trace mean value comparison (stim vs non stim). output of stim_effect_compare_trace_mean_alltrial
	        diaThreshold = varargin{ii+1}; % normalize every FluoroData trace with its max value
	    elseif strcmpi('cirThreshold', varargin{ii})
            cirThreshold = varargin{ii+1};
	    end
	end


	% 1. Decrease the noise in the image
	% Open a GUI to display the binary Image Use the slider in the GUI to set
	% the threshold for noise size. Update the binary Image when threshold is
	% changed.
	% Use function "bwareaopen"
	bmDenoised = bwareaopen(bm, minSize); % get the de-noixed binaryMatrix 


	% 2. Get the properties of connected regions
	stats = regionprops(bmDenoised, 'Area', 'EquivDiameter', 'Circularity',...
		'MajorAxisLength','MinorAxisLength','centroid');


	% 3. Filter neurons in the list 
	isNeuron = [stats.Area] >= minArea & [stats.EquivDiameter] >= minDiameter & [stats.Circularity] >= minCircularity;


	% 4. Create a binaryMatrix only contains the "isNeuron"
	bwNeurons = bwselect(bw, find(isNeuron));
end