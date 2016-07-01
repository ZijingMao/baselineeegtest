function [ test_xx ] = Convert2XDAWN( test_x, enhancedResponse )

	[channel, time, epoch] = size(test_x);
	
	downample_ratio = time/32;
	% downsample the train and test dataset
	if downample_ratio > 1 && isinteger(downample_ratio)
		permute_matrix = [2, 1, 3];
		tmp = downsample(permute(test_x, permute_matrix), downample_ratio);
		test_x = permute(tmp, permute_matrix);
		time = time/downample_ratio;
	end
	

	test_tmp = reshape(test_x, [channel, time*size(test_x, 3)]);
	data_test = test_tmp'*enhancedResponse.spatialFilter;
	data_test = data_test';
	test = reshape(data_test, [channel, time, size(data_test, 2)/time]);

	test_xx = [];
	for i = 1:8
		test_xx = [test_xx; squeeze(double(test(i, :, :)))];
    end
    
    test_xx = test_xx';

end

