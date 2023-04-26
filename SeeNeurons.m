function [neuronsList,varargout] = SeeNeurons(binaryMatrix,varargin)
	% This function finds out neurons in a given binary image based on
	% diameter threshold (minDiameter) and circularity threshold (minCircularity)

	% Example:
	%		

	% Defaults
	minDiameter = 40; % unit: pixel
	maxDiameter = 40; % unit: pixel
	minCircularity = 0.6; % ranges from 0 (for a completely irregular shape) to 1 (for a perfect circle)
	noiseSigSizeScale = 2; % The max size of noise signal (connected area of ones) is minArea (calculated by minDiameter) devided by "noiseSigSizeScale" 

	% Optionals
	for ii = 1:2:(nargin-1)
	    if strcmpi('minDiameter', varargin{ii}) % trace mean value comparison (stim vs non stim). output of stim_effect_compare_trace_mean_alltrial
	        minDiameter = varargin{ii+1}; % normalize every FluoroData trace with its max value
	    elseif strcmpi('maxDiameter', varargin{ii})
            maxDiameter = varargin{ii+1};
	    elseif strcmpi('minCircularity', varargin{ii})
            minCircularity = varargin{ii+1};
	    elseif strcmpi('noiseSigSizeScale', varargin{ii})
            noiseSigSizeScale = varargin{ii+1};
	    end
	end

	% Decide the minSize using the minDiameter
	minArea = pi*(minDiameter/2)^2;


	% 1. Decrease the noise in the image with function "bwareaopen"
	% Optional: Open a GUI to display the binary Image Use the
	% slider in the GUI to set the threshold for noise size. Update the binary Image when threshold
	% is changed. 
	minSize = minArea/noiseSigSizeScale; 
	bmDenoised = bwareaopen(binaryMatrix, minSize); % get the de-noixed binaryMatrix 


	% 2. Get the properties of connected regions
	stats = regionprops(bmDenoised, 'Area', 'EquivDiameter', 'Circularity',...
		'MajorAxisLength','MinorAxisLength','centroid');


	% 3. Filter neurons in the list 
	neuronsList = [stats.EquivDiameter] >= minDiameter & [stats.EquivDiameter] <= maxDiameter & [stats.Circularity] >= minCircularity & [stats.Area] >= minArea;


	% 4. Calculate the mean, standard error, median, and normality for summary


	% 5. Plot histogram for Area, EquivDiameter, Circularity, MajorAxisLength, and MinorAxisLength


	% 6. Scatter plot of Area/Diameter vs circularity


	% 7. Create a binaryMatrix only contains the "isNeuron"
	bwNeurons = bwselect(bw, find(isNeuron));
end