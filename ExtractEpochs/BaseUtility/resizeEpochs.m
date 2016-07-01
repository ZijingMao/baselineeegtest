function [ resized_data ] = resizeEpochs( data )

assert(length(size(data)) == 4, 'select the correct dimension of data');

totalSize = size(data, 4);
resized_data = zeros(224, 224, 1, totalSize);

fprintf(1,'\nPercentage complete: ');
for idx = 1:totalSize
    resized_tmp_data = imresize(squeeze(data(:, :, 1, idx)), [224, 224]);
    resized_data(:, :, 1, idx) = resized_tmp_data;
    pcDone  =  num2str(floor(((idx-1)/totalSize) * 100));
    if(length(pcDone)  ==  1)
        pcDone(2)  =  pcDone(1);
        pcDone(1)  =  '0';
    end
    fprintf(1,'%s%%',pcDone);
    fprintf(1,'\b\b\b');
end
fprintf(1,'\b\bd.');
fprintf(1,'\n');

end

