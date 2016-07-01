function vis_spatial_filter( spatialFilter, nameIdx, chanlocs )
% the filter structure should be 'channel * time'

spatialFilter = double(squeeze(spatialFilter));
spatialNorm = zeros(1, size(spatialFilter, 2));
for idx = 1:size(spatialFilter, 2)
    spatialNorm(idx) = norm(spatialFilter(:, idx));
end
[~, selectIdx] = max(spatialNorm);

handles.mycmap = set_mycmap();
handles.chanlocs = chanlocs;
handles.min_val = 0;
handles.max_val = 1;
handles.visible = true;
handles.saveFig = true;
handles.name = num2str(nameIdx);

generateBrainmap([], spatialFilter, selectIdx, handles);

end

