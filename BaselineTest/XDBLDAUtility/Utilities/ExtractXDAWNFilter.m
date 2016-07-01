function [ train_xx, enhancedResponse ] = ExtractXDAWNFilter( train_x, train_y )

	[channel, time, epoch] = size(train_x);
	
	downample_ratio = time/32;
	% downsample the train and test dataset
	if downample_ratio > 1 && isinteger(downample_ratio)
		permute_matrix = [2, 1, 3];
		tmp = downsample(permute(train_x, permute_matrix), downample_ratio);
		train_x = permute(tmp, permute_matrix);
		time = time/downample_ratio;
	end
	
	s = reshape(train_x, [channel, time*epoch]);
	s = double(s');
	idx.blockLength = time;
	idx.indexStimulus = 1:time:epoch*time;

	nontarget = find(train_y == 0);
	idx.indexStimulus(nontarget) = [];

	[enhancedResponse, ~, ~] = mxdawn(s,idx, 0);

	data = s*enhancedResponse.spatialFilter;
	data = data';
	train = reshape(data, [channel, time, epoch]);

	train_xx = [];

	for i = 1:8
		train_xx = [train_xx; squeeze(double(train(i, :, :)))];    
	end

    train_xx = train_xx';

end

